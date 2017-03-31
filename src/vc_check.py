from lib.boogie.ast import ast_and, replace, AstBinExpr, AstAssert, AstAssume, AstTrue
from lib.common.util import split, nonempty, powerset
from lib.boogie.z3_embed import expr_to_z3, AllIntTypeEnv, Unknown, counterex, Implies, And, tautology, satisfiable, unsatisfiable
from lib.boogie.paths import nd_bb_path_to_ssa, ssa_path_to_z3, _ssa_stmts
from lib.boogie.ssa import SSAEnv
from lib.boogie.predicate_transformers import wp_stmts, sp_stmt
from copy import copy
from lib.boogie.bb import entry, exit
from lib.boogie.inv_networks import *

def conservative_tautology(q):
  try:
    return tautology(q);
  except Unknown:
    return False;

def _from_dict(vs, vals):
    if type(vals) == tuple:
        return ( _from_dict(vs, vals[0]), _from_dict(vs, vals[1]) )
    else:
        return [ vals[vs[i]] if vs[i] in vals else None for i in xrange(0, len(vs)) ]

def tryAndVerify_impl(bbs, loop, old_sound_invs, invs, timeout=None):
    """ Wrapper around checkInvNetwork for the case of a function
        with a single loop and no pre- post- conditions.
        Returns a tuple (overfitted, nonind, sound, violations) where
          overfitted, nonind are each a list of tuples (inv, Violation)
          sound is a set of sound invariants
          violations is a (potentially empty) list of safety Violations
            for the sound invariants.
    """
    assert isinstance(old_sound_invs, set)
    assert isinstance(invs, set)
    loopHdr = loop.loop_paths[0][0]
    cps = { loopHdr: set(old_sound_invs).union(set(invs)) }

    (overfitted, nonind, sound, violations) =\
      filterCandidateInvariants(bbs, AstTrue(), AstTrue(), cps, timeout);

    overfitted = list(overfitted[loopHdr])
    nonind_invs = list(nonind[loopHdr])
    sound = sound[loopHdr]

    return overfitted, nonind_invs, sound, violations

def tryAndVerifyWithSplitterPreds(bbs, loop, old_sound_invs, boogie_invs,
  splitterPreds, partialInvs, timeout=None):
    """ Wrapper around tryAndVerify_impl that adds implication with
        the splitter predicates to all candidate invariants. Returns
          ((p1_overfit, p2_overfit), (p1_nonindg, p2_nonind), sound, violations)

        Where
        
          p1_overfit, p2_ovefit are lists of pairs of overfittted invariants and their
              respective counterexamples from passes 1 and 2
          p1_nonind, p2_ovefit are lists of pairs of noninductive invariants and their
              respective counterexamples from passes 1 and 2
          sound is a set of sound invariants
          violations is a list of any safety violations permitted by the sound invariants
    """
    assert isinstance(old_sound_invs, set)
    assert isinstance(boogie_invs, set)
    assert isinstance(partialInvs, list)
    assert isinstance(splitterPreds, list)

    initial_sound = old_sound_invs.union(partialInvs)

    # First lets find the invariants that are sound without implication
    p1_overfitted, p1_nonind, p1_sound, violations =\
      tryAndVerify_impl(bbs, loop, initial_sound, boogie_invs, timeout)
    p1_sound = set([x for x in p1_sound if not conservative_tautology(expr_to_z3(x, AllIntTypeEnv()))])

    # Next lets add implication  to all unsound invariants from first pass
    # Also add manually specified partialInvs
    unsound = [ inv_ctr_pair[0] for inv_ctr_pair in p1_overfitted + p1_nonind ]
    candidate_precedents = [ ast_and(pSet) for pSet in nonempty(powerset(splitterPreds)) ]
    p2_invs = [ AstBinExpr(precc, "==>", inv)
      for precc in candidate_precedents for inv in unsound] + partialInvs

    p2_invs = set([ x for x in p2_invs if not conservative_tautology(expr_to_z3(x, AllIntTypeEnv())) ])

    # And look for any new sound invariants
    p2_overfitted, p2_nonind, p2_sound, violations = tryAndVerify_impl(bbs, loop, \
      p1_sound.union(set(partialInvs)), p2_invs, timeout)
    sound = p1_sound.union(p2_sound)

    return ((p1_overfitted, p2_overfitted), (p1_nonind, p2_nonind), sound, violations)

def loopInvOverfittedCtrex(loop, inv, bbs):
  """ Given a candidate loop invariant inv find 'overfittedness'
      counterexamples.  I.e. find counterexamples to "precondition ==> inv".
      Returns a potentially empty set of environments (dicts) that the invariant
      should satisfy.
  """
  loopHdr = loop.loop_paths[0][0]
  cps = { loopHdr : set(invs) }
  violations = checkInvNetwork(bbs, AstTrue(), AstTrue(), cps, timeout);
  entryBB = entry(bbs);

  return set([ x.endEnv() for x in violations
    if x.isInductive() and # Implication fail
       x.startBB() == entryBB and # From entry
       x.endBB() == loopHdr ]) # To loop inv
