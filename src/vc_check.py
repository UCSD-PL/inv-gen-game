from boogie.ast import ast_and, replace
from boogie_loops import loop_vc_pre_ctrex
from util import split
from boogie.z3_embed import expr_to_z3, AllIntTypeEnv, Unknown, counterex, Implies, And
from boogie.paths import nd_bb_path_to_ssa, ssa_path_to_z3
from boogie.ssa import SSAEnv

def _from_dict(vs, vals):
    if type(vals) == tuple:
        return ( _from_dict(vs, vals[0]), _from_dict(vs, vals[1]) )
    else:
        return [ vals[vs[i]].as_long() if vs[i] in vals else None for i in xrange(0, len(vs)) ]

def tryAndVerify_impl(bbs, loop, old_sound_invs, invs, timeout=None):
    # 0. First get the overfitted invariants out of the way. We can check overfitted-ness
    #    individually for each invariant.
    pre_ctrexs = map(lambda inv:    (inv, loop_vc_pre_ctrex(loop, inv, bbs)), invs)
    overfitted, rest = split(lambda ((inv, ctrex)): ctrex != None, pre_ctrexs)
    rest = map(lambda x:    x[0], rest)

    print len(rest), " left after overfitted removed"

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
          ctr = "unknown"

        if (ctr == None):
          rest.append(inv);
        else:
          nonind_ctrex[inv] = ctr;

    new_sound = set(rest)

    # 6. Label remainder as non-inductive
    nonind_invs = [ ]
    overfitted_set = set([ x[0] for x in overfitted ])

    for inv in invs:
        if inv not in overfitted_set and inv not in new_sound:
            nonind_invs.append((inv, nonind_ctrex[inv]))

    return overfitted, nonind_invs, list(new_sound)
