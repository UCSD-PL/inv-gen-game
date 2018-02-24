#pylint: disable=no-self-argument
from lib.boogie.ast import ast_and, replace, AstBinExpr, AstAssert, AstAssume, \
        AstTrue, AstExpr, AstStmt, _force_expr, ReplMap_T
from lib.common.util import split, nonempty, powerset
from lib.boogie.z3_embed import expr_to_z3, Unknown, counterex, \
        Implies, And, tautology, satisfiable, unsatisfiable, to_smt2,\
        get_typeenv
from lib.boogie.paths import nd_bb_path_to_ssa, _ssa_stmts,\
        NondetSSAPath, SSABBNode, NondetPath
from lib.boogie.ssa import SSAEnv, unssa_z3_model, get_ssa_tenv
from lib.boogie.predicate_transformers import wp_stmts, sp_stmt
from lib.boogie.interp import Store
from copy import copy
from lib.boogie.bb import Function, Label_T, BB
from typing import Dict, Optional, Set, Tuple, List
import z3

# TODO: Can I make these an instance of forward dataflow analysis?
class Violation:
  def __init__(s, typ: str, path: NondetSSAPath, lastBBCompletedStmts: List[Tuple[AstStmt, ReplMap_T]], query: z3.ExprRef, ctrex: Store) -> None:
    s._typ = typ
    s._path = path
    s._lastBBCompletedStmts = lastBBCompletedStmts
    s._query = query
    s._ctrex = ctrex

  def isInductive(s) -> bool:
      return s._typ == "inductiveness"
  def isSafety(s) -> bool:
      return s._typ == "safety"
  def startBB(s) -> Label_T:
      assert isinstance(s._path[0], SSABBNode)
      return s._path[0].bb.label
  def endBB(s) -> Label_T:
      assert isinstance(s._path[-1], SSABBNode)
      return s._path[-1].bb.label
  def startReplM(s) -> ReplMap_T:
      assert isinstance(s._path[0], SSABBNode)
      return s._path[0].repl_maps[0]
  def endReplM(s) -> ReplMap_T:
      # TODO: Fix
      if (len(s._lastBBCompletedStmts) > 0):
        stmt_idx = len(s._lastBBCompletedStmts) - 1
        assert isinstance(s._path[-1], SSABBNode)
        return s._path[-1].repl_maps[stmt_idx]
      assert isinstance(s._path[-2], SSABBNode)
      return s._path[-2].repl_maps[0]

  @staticmethod
  def _filterStore(s: Store, repl_m: ReplMap_T) -> Store:
    return {k: v for (k,v) in s.items() if not k.startswith("k!")}

  def startEnv(s) -> Store:
    assert {} == s.startReplM()
    rm = s.startReplM()
    return s._filterStore(unssa_z3_model(s._ctrex, rm), rm)

  def endEnv(s) -> Store:
    rm = s.endReplM()
    return s._filterStore(unssa_z3_model(s._ctrex, rm), rm)

  def __str__(s) -> str:
    typeStr = "Safety" if s.isSafety() else "Inductiveness@"
    return "{}@{}:".format(typeStr, str(s._path) + " : " + str(s.startEnv()) + " -> " + str(s.endEnv()))

  def __repr__(s) -> str:
    return s.__str__()

InvNetwork = Dict[Label_T, Set[AstExpr]]
ViolationNetwork = Dict[Label_T, Set[Tuple[AstExpr, "Violation"]]]

def filterCandidateInvariants(fun: Function, preCond: AstExpr, postCond: AstExpr, cutPoints: InvNetwork, timeout: Optional[int]=None) -> Tuple[ViolationNetwork, ViolationNetwork, InvNetwork, List[Violation]]:
    assert (len(cutPoints) == 1)
    entryBB = fun.entry()

    cps = { bb : set(cutPoints[bb]) for bb in cutPoints } # type: InvNetwork
    cps[entryBB.label] = set([ preCond ])
    overfitted = { bb : set([]) for bb in cps } # type: ViolationNetwork
    nonind = { bb : set([]) for bb in cps } # type: ViolationNetwork

    # The separation in overfitted and nonind is well defined only in the
    # Single loop case. So for now only handle these. Can probably extend later

    tenv = get_ssa_tenv(get_typeenv(fun))
    cpWorkQ = set([ entryBB.label ] + list(cps.keys()))

    while (len(cpWorkQ) > 0):
      cp = cpWorkQ.pop()
      cur_bb = fun.get_bb(cp)
      cp_inv = expr_to_z3(ast_and(cps[cp]), tenv)

      initial_path, intial_ssa_env = nd_bb_path_to_ssa(NondetPath([cur_bb]), SSAEnv())
      pathWorkQ = [(initial_path, intial_ssa_env, cp_inv)]

      # Pass 1: Widdle down candidate invariants at cutpoints iteratively
      while len(pathWorkQ) > 0:
        path, curFinalSSAEnv, sp = pathWorkQ.pop(0)

        assert isinstance(path[-1], SSABBNode)
        nextBB, nextReplMaps = path[-1].bb, path[-1].repl_maps
        processedStmts = []
        ssa_stmts = _ssa_stmts(nextBB,  nextReplMaps)

        for s in ssa_stmts:
          if (isinstance(s, AstAssert)):
            pass; # During the first pass we ignore safety violations. We just
                  # want to get an inductive invariant network
          elif (isinstance(s, AstAssume)):
            try:
              if (unsatisfiable(And(sp, expr_to_z3(s.expr, tenv)), timeout)):
                break
            except Unknown:
              pass; # Conservatively assume path is possible on timeout
          processedStmts.append(s)
          new_sp = sp_stmt(s, sp, tenv)
          #print "SP: {", sp, "} ", s, " {", new_sp, "}"
          sp = new_sp

        if (len(processedStmts) != len(nextBB)):
          # Didn't make it to the end of the block - path must be unsat
          continue

        if (len(nextBB.successors()) == 0): # This is exit
          assert nextBB == fun.exit()
          # During Pass 1 we don't check the postcondition is implied
        else:
          for succ in nextBB.successors():
            if succ in cps:
              # Check implication
              assert isinstance(initial_path[0], SSABBNode)
              start = initial_path[0].bb

              candidate_invs = copy(cps[succ.label])
              for candidate in candidate_invs:
                ssaed_inv = _force_expr(replace(candidate,
                                                curFinalSSAEnv.replm()))
                candidateSSA = expr_to_z3(ssaed_inv, tenv)
                try:
                  c = counterex(Implies(sp, candidateSSA), timeout,
                                "Candidate: " + str(candidate))
                except Unknown:
                  c = { } # On timeout conservatively assume fail

                if (c != None):
                  v = Violation("inductiveness",
                                NondetSSAPath(path + [SSABBNode( succ, [])]),
                                [],
                                Implies(sp, candidateSSA),
                                c)

                  if (start == entryBB):
                    overfitted[succ.label].add((candidate, v))
                  else:
                    nonind[succ.label].add((candidate, v))

                  cps[succ.label].remove(candidate)
              if (len(candidate_invs) != len(cps[succ.label])):
                cpWorkQ.add(succ.label)
            else:
              assert succ not in path; # We should have cutpoints at every loop
              succSSA, nextFinalSSAEnv = \
                      nd_bb_path_to_ssa(NondetPath([succ]), SSAEnv(curFinalSSAEnv))
              pathWorkQ.append((NondetSSAPath(path + succSSA), nextFinalSSAEnv, sp))

    sound = cps

    # Pass 2: Check for safety violations
    violations = checkInvNetwork(fun, preCond, postCond, sound, timeout)
    for v in violations:
      if (not v.isSafety()):
        print(v)
      assert (v.isSafety()) # sound should be an inductive network

    return (overfitted, nonind, sound, violations)

def checkInvNetwork(fun: Function, preCond: AstExpr, postCond: AstExpr, cutPoints: InvNetwork, timeout: Optional[int] = None) -> List[Violation]:
    cps = copy(cutPoints)
    entryBB = fun.entry()
    cps[entryBB.label] = set([ preCond ])
    tenv = get_ssa_tenv(get_typeenv(fun))
    violations = [ ] # type: List[Violation]

    for cp in cps:
      cp_bb = fun.get_bb(cp)
      initial_path, intial_ssa_env = nd_bb_path_to_ssa(NondetPath([cp_bb]), SSAEnv())
      workQ = [ (initial_path,
                 intial_ssa_env,
                 expr_to_z3(ast_and(cps[cp]), tenv)) ]
      while len(workQ) > 0:
        path, curFinalSSAEnv, sp = workQ.pop(0)
        assert isinstance(path[-1], SSABBNode)
        nextBB, nextReplMaps = path[-1].bb, path[-1].repl_maps
        processedStmts = [] # type: List[Tuple[AstStmt, ReplMap_T]]
        ssa_stmts = list(zip(_ssa_stmts(nextBB, nextReplMaps), nextReplMaps))

        for (s, replM) in ssa_stmts:
          if (isinstance(s, AstAssert)):
            try:
              #print ("Checking path to assert {}\n {}\n {}\n {}\n".format(path, curFinalSSAEnv, sp, Implies(sp, expr_to_z3(s.expr, tenv))))
              c = counterex(Implies(sp, expr_to_z3(s.expr, tenv)), timeout, "Safety bunch: {}".format(Implies(sp, expr_to_z3(s.expr, tenv))))
              #print ("Done")
            except Unknown:
              c = { } # On timeout conservatively assume fail
            if (c != None):
              # Current path can violate assertion
              v = Violation("safety", path, processedStmts + [(s, replM)],
                            Implies(sp, expr_to_z3(s.expr, tenv)),
                            c)
              violations.append(v)
              break
          elif (isinstance(s, AstAssume)):
            try:
              if (unsatisfiable(And(sp, expr_to_z3(s.expr, tenv)), timeout, "Unsat? :{}".format(And(sp, expr_to_z3(s.expr, tenv))))):
                break
            except Unknown:
              print ("Timeout: Assuming path feasible: {}".format(path))
              pass; # Conservatively assume path is possible on timeout
          processedStmts.append((s, replM))
          new_sp = sp_stmt(s, sp, tenv)
          #print "SP: {", sp, "} ", s, " {", new_sp, "}"
          sp = new_sp

        if (len(processedStmts) != len(nextBB)):
          # Didn't make it to the end of the block - path must be unsat or
          # violation found
          continue

        if (len(nextBB.successors()) == 0): # This is exit
          assert nextBB == fun.exit()
          ssaed_postcond = _force_expr(replace(postCond, curFinalSSAEnv.replm()))
          postSSAZ3 = expr_to_z3(ssaed_postcond, tenv)
          try:
            #print ("Checking path to exit {}\n {}\n {}\n {}\n".format(path, postCond, postSSAZ3, Implies(sp, postSSAZ3)))
            c = counterex(Implies(sp, postSSAZ3), timeout, "Exit: {}".format(Implies(sp, postSSAZ3)))
            #print ("Done")
          except Unknown:
            c = { } # On timeout conservatively assume fail
          if (c != None):
            v = Violation("safety",
                          path,
                          processedStmts,
                          Implies(sp, postSSAZ3),
                          c)
            violations.append(v)
        else:
          for succ in nextBB.successors():
            if succ.label in cps:
              # Check implication
              post = ast_and(cps[succ.label])
              postSSA = _force_expr(replace(post, curFinalSSAEnv.replm()))
              postSSAZ3 = expr_to_z3(postSSA, tenv)
              #print ("Checking path from cp {} to cp {}: {}\n {}\n {}\n".format(cp, succ, path, postSSA, Implies(sp, postSSAZ3)))
              try:
                #print ("Inductiveness query: {}->{}: {}".format(nextBB.label, succ.label, Implies(sp, postSSAZ3)))
                c = counterex(Implies(sp, postSSAZ3), timeout, "Induction: {}".format(Implies(sp, postSSAZ3)))
              except Unknown:
                try:
                  # Sometimes its easier to check each post-invariant
                  # individually rather than all of them at once (similarly
                  # to the filter case). Try this if the implication of the
                  # conjunction of all of them fails
                  for p in cps[succ.label]:
                    postSSA = _force_expr(replace(p, curFinalSSAEnv.replm()))
                    postSSAZ3 = expr_to_z3(postSSA, tenv)
                    c = counterex(Implies(sp, postSSAZ3), timeout, "Induction(small): {}".format(Implies(sp, postSSAZ3)))
                    # If any of them doesn't hold, neither does their conj
                    if (c != None):
                        break
                except Unknown:
                  c = { } # On timeout conservatively assume fail
              #print ("Done")
              if (c != None):
                v = Violation("inductiveness",
                  NondetSSAPath(path + [SSABBNode(succ, [])]),
                  [],
                  Implies(sp, postSSAZ3), c)
                violations.append(v)
            else:
              assert succ not in path; # We should have cutpoints at every loop
              succSSA, nextFinalSSAEnv = \
                      nd_bb_path_to_ssa(NondetPath([succ]), SSAEnv(curFinalSSAEnv))
              workQ.append((NondetSSAPath(path + succSSA), nextFinalSSAEnv, sp))

    return violations
