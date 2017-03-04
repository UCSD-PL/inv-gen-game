from lib.boogie.ast import ast_and, replace, AstBinExpr, AstAssert, AstAssume, AstTrue
from boogie_loops import loop_vc_pre_ctrex, _unssa_z3_model
from util import split, nonempty, powerset
from lib.boogie.z3_embed import expr_to_z3, AllIntTypeEnv, Unknown, counterex, Implies, And, tautology, Bool, satisfiable, unsatisfiable
from lib.boogie.paths import nd_bb_path_to_ssa, ssa_path_to_z3, _ssa_stmts
from lib.boogie.ssa import SSAEnv
from lib.boogie.predicate_transformers import wp_stmts, sp_stmt
from copy import copy
from lib.boogie.bb import entry, exit

def _from_dict(vs, vals):
    if type(vals) == tuple:
        return ( _from_dict(vs, vals[0]), _from_dict(vs, vals[1]) )
    else:
        return [ vals[vs[i]] if vs[i] in vals else None for i in xrange(0, len(vs)) ]

def tryAndVerify_impl(bbs, loop, old_sound_invs, invs, timeout=None):
    # 0. First get the overfitted invariants out of the way. We can check overfitted-ness
    #    individually for each invariant.
    pre_ctrexs = map(lambda inv:    (inv, loop_vc_pre_ctrex(loop, inv, bbs)), invs)
    overfitted, rest = split(lambda ((inv, ctrex)): ctrex != None, pre_ctrexs)
    rest = map(lambda x:    x[0], rest)

    nonind_ctrex = { }

    body_ssa, ssa_env = nd_bb_path_to_ssa([loop.loop_paths], bbs, SSAEnv(None, ""))
    z3_path_pred = ssa_path_to_z3(body_ssa, bbs);

    rest = list(rest) + old_sound_invs
    old_rest = []

    # Repeat till quiescence (while rest is shrinking)
    while (len(old_rest) != len(rest)):
      old_rest = rest
      rest = []

      z3_pre_cond = expr_to_z3(ast_and(old_rest), AllIntTypeEnv())

      for inv in old_rest:
        z3_inv_post = expr_to_z3(replace(inv, ssa_env.replm()), AllIntTypeEnv())
        q = Implies(And(z3_pre_cond, z3_path_pred), z3_inv_post)

        try:
          ctr = counterex(q, timeout);
        except Unknown:
          ctr = { }

        if (ctr == None):
          rest.append(inv);
        else:
          nonind_ctrex[inv] = (_unssa_z3_model(ctr, {}), _unssa_z3_model(ctr, ssa_env.replm()));

    new_sound = set(rest)

    # 6. Label remainder as non-inductive
    nonind_invs = [ ]
    overfitted_set = set([ x[0] for x in overfitted ])

    for inv in invs:
        if inv not in overfitted_set and inv not in new_sound:
            nonind_invs.append((inv, nonind_ctrex[inv]))

    return overfitted, nonind_invs, list(new_sound)

def tryAndVerifyWithSplitterPreds(bbs, loop, old_sound_invs, boogie_invs,
  splitterPreds, partialInvs, timeout=None):
    initial_sound = partialInvs + old_sound_invs

    # First lets find the invariants that are sound without implication
    overfitted, nonind, sound = tryAndVerify_impl(bbs, loop, initial_sound, boogie_invs, timeout)
    sound = [x for x in sound if not tautology(expr_to_z3(x, AllIntTypeEnv()))]

    # Next lets add implication  to all unsound invariants from first pass
    # Also add manually specified partialInvs
    unsound = [ inv_ctr_pair[0] for inv_ctr_pair in overfitted + nonind ]
    candidate_antecedents = [ ast_and(pSet) for pSet in nonempty(powerset(splitterPreds)) ]
    p2_invs = [ AstBinExpr(antec, "==>", inv)
      for antec in candidate_antecedents for inv in unsound ] + partialInvs
    p2_invs = [ x for x in p2_invs if not tautology(expr_to_z3(x, AllIntTypeEnv())) ]

    # And look for any new sound invariants
    overfitted, nonind, sound_p2 = tryAndVerify_impl(bbs, loop, sound, p2_invs, timeout)
    sound = set(sound).union(sound_p2)

    return (overfitted, nonind, sound)

def checkInvNetwork(bbs, preCond, postCond, cutPoints, timeout=None):
    cps = copy(cutPoints);
    entryBB = entry(bbs); exitBB = exit(bbs);
    cps[entryBB] = preCond;
    aiTyEnv = AllIntTypeEnv()

    for cp in cps:
      initial_path, intial_ssa_env = nd_bb_path_to_ssa([cp], bbs, SSAEnv())
      workQ = [(initial_path, intial_ssa_env, expr_to_z3(cps[cp], aiTyEnv))]
      visited = set()
      while len(workQ) > 0:
        path, curFinalSSAEnv, sp = workQ.pop(0);

        nextBB, nextReplMaps = path[-1]
        processedStmts = []
        ssa_stmts = _ssa_stmts(bbs[nextBB].stmts, nextReplMaps)

        for s in ssa_stmts:
          if (isinstance(s, AstAssert)):
            c = counterex(Implies(sp, expr_to_z3(s.expr, aiTyEnv)), timeout);
            if (c != None):
              # Current path can violate assertion
              return ("unsafe", path, processedStmts + [s], sp, c)
          elif (isinstance(s, AstAssume)):
            if (unsatisfiable(And(sp, expr_to_z3(s.expr, aiTyEnv)), timeout)):
              break;
          processedStmts.append(s)
          new_sp = sp_stmt(s, sp, aiTyEnv)
          #print "SP: {", sp, "} ", s, " {", new_sp, "}"
          sp = new_sp

        if (len(processedStmts) != len(bbs[nextBB].stmts)):
          # Didn't make it to the end of the block - path must be unsat
          continue;

        if (len(bbs[nextBB].successors) == 0): # This is exit
          assert nextBB == exit(bbs)
          postSSA = expr_to_z3(replace(postCond, curFinalSSAEnv.replm()), aiTyEnv)
          c = counterex(Implies(sp, postSSA), timeout)
          if (c != None):
            return ("unsafe", path, succ, sp, c)
        else:
          for succ in bbs[nextBB].successors:
            if succ in cps:
              # Check implication
              post = cps[succ]
              postSSA = replace(post, curFinalSSAEnv.replm())
              postSSAZ3 = expr_to_z3(postSSA, aiTyEnv)
              c = counterex(Implies(sp, postSSAZ3), timeout)
              if (c != None):
                return ("nonind", path, succ, Implies(sp, postSSAZ3), c)
            else:
              assert succ not in path; # We should have cutpoints at every loop
              succSSA, nextFinalSSAEnv = nd_bb_path_to_ssa([succ], bbs, SSAEnv(curFinalSSAEnv));
              workQ.append((path + succSSA, nextFinalSSAEnv, sp));
    return True

def checkLoopInv(bbs, loop, invs, timeout=None):
  loopHdr = loop.loop_paths[0][0]
  cps = { loopHdr : ast_and(invs) }
  res = checkInvNetwork(bbs, AstTrue(), AstTrue(), cps, timeout);
  entryBB = entry(bbs); exitBB = exit(bbs);

  if (res == True):
    return True
  else:
    (failure, path, arg, sp, ctrex) = res
    if (failure == "unsafe"):
      return "unsafe"
    else:
      if path[0][0] == entryBB:
        assert arg == loopHdr
        return "overfitted"
      else:
        assert path[0][0] == loopHdr and arg == loopHdr
        return "non-inductive"
