from lib.boogie.ast import ast_and, replace, AstBinExpr, AstAssert, AstAssume, AstTrue
from boogie_loops import _unssa_z3_model
from util import split, nonempty, powerset
from lib.boogie.z3_embed import expr_to_z3, AllIntTypeEnv, Unknown, counterex, Implies, And, tautology, Bool, satisfiable, unsatisfiable
from lib.boogie.paths import nd_bb_path_to_ssa, ssa_path_to_z3, _ssa_stmts
from lib.boogie.ssa import SSAEnv
from lib.boogie.predicate_transformers import wp_stmts, sp_stmt
from copy import copy
from lib.boogie.bb import entry, exit
from lib.boogie.inv_networks import *

def _from_dict(vs, vals):
    if type(vals) == tuple:
        return ( _from_dict(vs, vals[0]), _from_dict(vs, vals[1]) )
    else:
        return [ vals[vs[i]] if vs[i] in vals else None for i in xrange(0, len(vs)) ]

def tryAndVerify_impl(bbs, loop, old_sound_invs, invs, timeout=None):
    loopHdr = loop.loop_paths[0][0]
    cps = { loopHdr: set(old_sound_invs + invs) }

    (overfitted, nonind, sound, violations) =\
      filterCandidateInvariants(bbs, AstTrue(), AstTrue(), cps, timeout);

    overfitted = [(x, None) for x in overfitted[loopHdr]]
    nonind_invs = [(x, None) for x in nonind[loopHdr]]
    sound = list(sound[loopHdr])

    return overfitted, nonind_invs, sound

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

def checkLoopInv(bbs, loop, invs, timeout=None):
  loopHdr = loop.loop_paths[0][0]
  cps = { loopHdr : set(invs) }
  res = checkInvNetwork(bbs, AstTrue(), AstTrue(), cps, timeout);
  entryBB = entry(bbs); exitBB = exit(bbs);
  return len(res) == 0
