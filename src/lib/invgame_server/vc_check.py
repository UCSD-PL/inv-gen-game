from lib.common.util import nonempty, powerset, flattenSet, ccast, unique
import z3

from pyboogie.ast import ast_and, replace, AstBinExpr, AstTrue, \
        AstNumber, AstId, ReplMap_T, AstExpr
from pyboogie.z3_embed import expr_to_z3, Unknown, \
        And, tautology, boogieToZ3TypeEnv
from pyboogie.analysis import propagateUnmodifiedPreds
from pyboogie.bb import Function, BB
from pyboogie.inv_networks import checkInvNetwork, filterCandidateInvariants, Violation, InvNetwork
from pyboogie.interp import Store, BoogieVal
from .levels import BoogieTraceLvl

from typing import List, Tuple, Union, Optional, Any, Set, Iterable

def conservative_tautology(q: z3.ExprRef) -> bool:
  try:
    return tautology(q);
  except Unknown:
    return False;

def _from_dict(
  vs: List[str],
  vals: Store,
  missing: BoogieVal
  ) -> List[BoogieVal]:
    return [ (vals[vs[i]] if vs[i] in vals else missing) \
              for i in range(0, len(vs)) ]

# TODO: Here we are lying to the type system that values in traces are always ints. Need to assert this!
def traceConstantVars(lvl: BoogieTraceLvl) -> List[Tuple[str, int]]:
  vs = lvl['variables']
  table = lvl['data'][0]
  cInds = [ (x[0], list(x[1])[0]) for x in
    enumerate([set([table[row][col] for row in range(len(table))])
                for col in range(len(vs))]) if len(x[1]) == 1 ]
  return [ (vs[x[0]], x[1])  for x in cInds ]

def substitutions(expr: AstExpr, replMs: Iterable[ReplMap_T]) -> Set[AstExpr]:
  family = set([expr])
  for replM in replMs:
    family.add(ccast(replace(expr, replM), AstExpr))

  return family

def generalizeConstTraceVars(lvl: BoogieTraceLvl) -> List[ReplMap_T]:
  """ Given an expression and a set of pairs (Var, Num) where Var is always
      equal to Num in the traces presented to the user, add all variations
      of expr with Num substituded for Var and vice-versa. Note we don't do
      combinations of multiple substitutions where that is possible.
  """
  varNums = traceConstantVars(lvl)
  replMs: List[ReplMap_T] = [ { AstId(v[0]) : AstNumber(int(v[1])) for v in varNums } ]
  replMs += [ { AstNumber(int(v[1])) : AstId(v[0]) for v in varNums } ]
  return replMs

ViolatedExprList=List[Tuple[AstExpr, Violation]]
TryAndVerifyResult=Tuple[\
  Tuple[ViolatedExprList, ViolatedExprList],\
  Tuple[ViolatedExprList, ViolatedExprList],\
  Set[AstExpr],\
  List[Violation]]

def tryAndVerify(
  fun: Function,
  splitterPreds: List[AstExpr],\
  partialInvs: List[AstExpr],\
  userInvs: Iterable[AstExpr],\
  otherInvs: Iterable[AstExpr],\
  replMaps: Iterable[ReplMap_T],\
  timeout: Optional[int]=None
  ) -> TryAndVerifyResult:

    userInvs = flattenSet([substitutions(x, replMaps) for x in userInvs])
    invs = userInvs.union(otherInvs)
    invs = invs.union(partialInvs);

    if (len(splitterPreds) == 0):
      assert(len(partialInvs) == 0);
      (ovrefitted, nonind, sound, violations) = \
              tryAndVerify_impl(fun, set(), invs, timeout)
      return ((ovrefitted, []), (nonind, []), sound, violations) 
    else:
      return tryAndVerifyWithSplitterPreds(fun, set(), invs, \
                                           splitterPreds, \
                                           partialInvs, \
                                           timeout)

def tryAndVerifyLvl(
  lvl: BoogieTraceLvl,
  userInvs: Iterable[AstExpr],
  otherInvs: Set[AstExpr],
  timeout: Optional[int] = None, \
  useSplitters: bool = True,
  addSPs: bool = True,
  generalizeUserInvs: bool = False
  ) -> TryAndVerifyResult:
    """ Try and verify a given Lvl.

          lvl - level to verify
          userInvs - invariant candidate from the user
          otherInvs - invariant candidates from other sources (e.g. previous
                      users).
                      Note: We will keep userInvs and otherInvs separate in the
                      results.
          timeout - if specified, the z3 timeout for each query
          useSplitters - if the level supports splitter predicates, whether to
                         use them or not.
          addSPs - if true, try to propagte SP through the loop and add the
                   results as invariants. For example if before the loop we 
                   have "assert n>0;" and n is not modified in the loop, we
                   can determine that"n>0" holds through the loop and add
                   that to our cnadidate invariants.
          generalizeUserInvs - if true, for any invariant I involving a
                   constant C, where one of the variables V shown to the user
                   was always equal to C in the traces, try substituting C with V.
                   For example if in the level always n=4, and the user
                   entered i<=4, the generalizaition would also try i<=n.
    """
    fun: Function = lvl['program']
    loopHdr: BB = unique(fun.loopHeaders())
    partialInvs: List[AstExpr] = [ lvl['partialInv'] ] \
            if ('partialInv' in lvl) and useSplitters else []
    splitterPreds: List[AstExpr] = lvl['splitterPreds'] \
            if ('splitterPreds' in lvl) and useSplitters else [ ]
    if (generalizeUserInvs):
      replMaps: List[ReplMap_T] = generalizeConstTraceVars(lvl);
    else:
      replMaps = []

    # Push any SPs that are syntactically unmodified
    if (addSPs):
      sps = propagateUnmodifiedPreds(fun)[(loopHdr, 0)]
      if (sps is not None):
        otherInvs = otherInvs.union(set(sps))

    return tryAndVerify(fun, splitterPreds, partialInvs, \
                        userInvs, otherInvs, replMaps, timeout);

def tryAndVerify_impl(
  fun: Function,
  oldSoundInvs: Iterable[AstExpr],
  invs: Iterable[AstExpr],
  timeout: Optional[int]=None
  ) -> Tuple[List[Tuple[AstExpr, Violation]], List[Tuple[AstExpr, Violation]], Set[AstExpr], List[Violation]]:
    """ Wrapper around checkInvNetwork for the case of a function
        with a single loop and no pre- post- conditions.
        Returns a tuple (overfitted, nonind, sound, violations) where
          overfitted, nonind are each a list of tuples (inv, Violation)
          sound is a set of sound invariants
          violations is a (potentially empty) list of safety Violations
            for the sound invariants.
    """
    loopHdr = unique(fun.loopHeaders()).label
    cps: InvNetwork = { loopHdr: set(oldSoundInvs).union(set(invs)) }

    (overfitted, nonind, sound, violations) =\
      filterCandidateInvariants(fun, AstTrue(), AstTrue(), cps, timeout)

    overfittedL = list(overfitted[loopHdr])
    nonindInvsL = list(nonind[loopHdr])
    soundL = sound[loopHdr]

    return overfittedL, nonindInvsL, soundL, violations

def tryAndVerifyWithSplitterPreds(
  fun: Function,
  old_sound_invs: Set[AstExpr],
  boogie_invs: Set[AstExpr],
  splitterPreds: List[AstExpr],
  partialInvs: List[AstExpr],
  timeout: Optional[int]=None
  ) -> TryAndVerifyResult:
    """ Wrapper around tryAndVerify_impl that adds implication with
        the splitter predicates to all candidate invariants. Returns
          ((p1_overfit, p2_overfit), (p1_nonindg, p2_nonind), sound, violations)

        Where

          p1_overfit, p2_ovefit are lists of pairs of overfittted invariants
                    and their respective counterexamples from passes 1 and 2
          p1_nonind, p2_nonind are lists of pairs of noninductive invariants
                    and their respective counterexamples from passes 1 and 2
          sound is a set of sound invariants
          violations is a list of any safety violations permitted by the sound
          invariants
    """
    initial_sound = old_sound_invs.union(partialInvs)
    boogieTypeEnv = fun.getTypeEnv()
    z3TypeEnv = boogieToZ3TypeEnv(boogieTypeEnv)

    # First lets find the invariants that are sound without implication
    p1_overfitted, p1_nonind, p1_sound, violations =\
      tryAndVerify_impl(fun, initial_sound, boogie_invs, timeout)
    p1_sound = \
        set([x for x in p1_sound \
               if not conservative_tautology(expr_to_z3(x, z3TypeEnv))])

    # Next lets add implication  to all unsound invariants from first pass
    # Also add manually specified partialInvs
    unsound: List[AstExpr] = [ inv_ctr_pair[0] for inv_ctr_pair in p1_overfitted + p1_nonind ]
    candidate_precedents: List[AstExpr] = \
            [ ast_and(pSet) for pSet in nonempty(powerset(splitterPreds)) ]
    p2_invs: List[AstExpr] = [ AstBinExpr(precc, "==>", inv)
      for precc in candidate_precedents for inv in unsound]
    p2_invs += partialInvs

    p2_invs = \
        list(set([ x for x in p2_invs \
                if not conservative_tautology(expr_to_z3(x, z3TypeEnv)) ]))

    # And look for any new sound invariants
    p2_overfitted, p2_nonind, p2_sound, violations = \
            tryAndVerify_impl(fun, p1_sound.union(set(partialInvs)), \
                              p2_invs, timeout)
    sound = p1_sound.union(p2_sound)

    return ((p1_overfitted, p2_overfitted), \
            (p1_nonind, p2_nonind), \
            sound, \
            violations)

def loopInvOverfittedCtrex(
  fun: Function, \
  invs: Iterable[AstExpr], \
  timeout: Optional[int] = None
  ) -> List[Store]:
  """ Given a candidate loop invariant inv find 'overfittedness'
      counterexamples.  I.e. find counterexamples to "precondition ==> inv".
      Returns a potentially empty set of environments (dicts) that the invariant
      should satisfy.
  """
  loopHdr = unique(fun.loopHeaders()).label
  cps: InvNetwork = { loopHdr : set(invs) }
  violations = checkInvNetwork(fun, AstTrue(), AstTrue(), cps, timeout)
  entryBB = fun.entry().label

  return ([ x.endEnv() for x in violations
    if x.isInductive() and # Implication fail
       x.startBB() == entryBB and # From entry
       x.endBB() == loopHdr ]) # To loop inv

def loopInvSafetyCtrex(
  fun: Function, \
  invs: Iterable[AstExpr], \
  timeout: Optional[int] = None
  ) -> List[Store]:
  """ Given a candidate loop invariant inv find 'safety'
      counterexamples.  I.e. find counterexamples to "inv ==> post" or "inv ==>
      assert".  Returns a potentially empty set of environments (dicts) that
      the invariant should satisfy.
  """
  loopHdr = unique(fun.loopHeaders()).label
  cps: InvNetwork = { loopHdr : set(invs) }
  violations = checkInvNetwork(fun, AstTrue(), AstTrue(), cps, timeout)

  return ([ x.endEnv() for x in violations
    if x.isSafety() and # Safety fail
       x.startBB() == loopHdr ]) # From Inv
