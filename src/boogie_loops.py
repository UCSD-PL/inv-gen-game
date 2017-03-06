from lib.boogie.paths import is_nd_bb_path_possible
from lib.boogie.ast import *;
from lib.boogie.z3_embed import *
from lib.boogie.bb import BB, get_bbs, entry
from lib.boogie.paths import get_path_vars, nd_bb_path_to_ssa, ssa_path_to_z3, wp_nd_ssa_path
from lib.boogie.ssa import *
from lib.boogie.eval import env_to_expr
from collections import namedtuple
from lib.common.util import *

Loop = namedtuple("Loop", ["header", "loop_paths", "exit_paths", "entry_cond"])


# TODO(dimo): This code is fragile - too many potentially limiting
# assumptions about code shape. Should be removed when we
# moved to on-demand level generation as loops are
# discovered during dynamic exploration of the program.

# There are several implicit assumption in the loop code
# (these seem to hold for the desugared boogie code)
#
# 1) Each loop is identified by a unique header node
# 2) Each loop has a single exit point
# 3) All the relevant postcondition asserts are in the
#    immediate loop exit code
#
# 3) is particularly risky.
def _loops(bbs, curpath, loop_m):
    if (curpath == []):
        curpath.append(entry(bbs))

    #TODO: Is the code resilient to random dead loops?
    #if (not is_nd_bb_path_possible(curpath, bbs)):
    #    return

    for s in bbs[curpath[-1]].successors:
        if (s in curpath):
            prefix = tuple(curpath[:curpath.index(s)])
            body = curpath[curpath.index(s):]

            if (prefix not in loop_m):
                loop_m[prefix] = []

            loop_m[prefix].append(body)
            continue

        curpath.append(s)
        _loops(bbs, curpath, loop_m)
        curpath.pop()
    return loop_m

def loop_path_entry_cond(p,bbs):
    # We are relying on boogie placing the entry condition in
    # the second bb for a given path as the first statement
    bb = bbs[p[1]]
    assert isinstance(bb.stmts[0], AstAssume)
    return bb.stmts[0].expr

def loops(bbs):
    loop_m = _loops(bbs, [], {})
    return [ Loop(k, v, [[ v[0][0], loop_exit_bb(v, bbs) ]],
                        ast_or([loop_path_entry_cond(p, bbs) for p in v])) \
        for (k,v) in loop_m.iteritems() ]

def loop_exit_bb(body_paths, bbs):
    loop_header_succ = set(bbs[body_paths[0][0]].successors)
    bbs_in_loop = set([p[1] for p in body_paths])
    assert (len(loop_header_succ) == len(bbs_in_loop) + 1) # Singular exit node
    # TODO: Check that no other paths exit the loop (sanity)
    return unique(loop_header_succ.difference(bbs_in_loop))

# Assumes single loop at the end of the path
def unroll_loop(loop, nunrolls, extra_pred_bb = None, exact = False):
    return list(loop.header) + ([extra_pred_bb] if extra_pred_bb else []) + \
      nunrolls * [ loop.loop_paths ] + ([ loop.exit_paths ] if exact else [])

def bad_envs_to_expr(bad_envs):
    s = "&&".join(["!(" + 
                        "&&".join([("(%s==%s)" %(k, str(v))) for (k,v) in bad_env.iteritems()]) + ")"
                        for bad_env in bad_envs])
    if (s == ""):
        return AstTrue()
    return parseExprAst(s)

# get_loop_header_values tries to unroll the given loop between min_unrolls and max_unrolls.
#
#   loop - loop to unroll (specified in the Loop named tuple format)
#   bbs - the basic block representation of the function
#   min_unrolls - minimum number of unrolls to try
#   max_unrolls - max number of unrolls to try
#   forbidden_envs - an optional list of 'bad' initial assignments for the live
#     loop variables at the start of iteration. tries to find values that avoid
#     those. Useful for driving the search away from previous examples.
#   starting_env - an optional precise initial assignment for the live loop
#     variables to start with. Useful when you want to continue unrolling a
#     partially unrolled loop
#   exact - if true, look for loop unrolling that exit the loop afterwards 
#
def get_loop_header_values(loop, bbs, min_unrolls = 0, max_unrolls = 5, \
  forbidden_envs = None, start_env = None, exact = False):
    # Try unrolling it up to to the limit times
    loop_header_bb = loop.loop_paths[0][0]
    nunrolls = min_unrolls;

    extra_bb = None
    if (forbidden_envs or start_env):
        assert not (forbidden_envs and start_env)
        extra_bb = "_tmp_header_pred_"
        if forbidden_envs:
            expr = bad_envs_to_expr(forbidden_envs)
        else:
            expr = env_to_expr(start_env)
        bbs[extra_bb] = BB([], [ AstAssume(expr) ], [])

    while is_nd_bb_path_possible(unroll_loop(loop, nunrolls+1, extra_bb, exact), bbs) and \
      nunrolls < max_unrolls:
        nunrolls += 1;

    if (not is_nd_bb_path_possible(unroll_loop(loop, nunrolls, extra_bb, exact), bbs)):
        return []

    unrolled_path = unroll_loop(loop, nunrolls, extra_bb, exact)
    path_vars = get_path_vars(unrolled_path, bbs)
    return [bb[1][0] for bb in path_vars if bb[0] == loop_header_bb]

def _unssa_z3_model(m, repl_m):
    updated = map(str, repl_m.keys())
    original = [ x for x in m.keys() if not is_ssa_str(x) and x not in updated ] 
    return { (unssa_str(x) if is_ssa_str(x) else x) : m.get(x, None) for x in
        original + map(str, repl_m.values()) }

def loop_vc_pre_ctrex(loop, inv, bbs):
    prefix_ssa, ssa_env = nd_bb_path_to_ssa(list(loop.header), bbs, SSAEnv(None, ""))

    z3_precondition = ssa_path_to_z3(prefix_ssa, bbs)
    z3_loop_entry_cond = expr_to_z3(replace(loop.entry_cond, ssa_env.replm()), AllIntTypeEnv())
    z3_inv = expr_to_z3(replace(inv, ssa_env.replm()), AllIntTypeEnv())

    q = Implies(z3_precondition, z3_inv)
    try:
      ctr = counterex(q)
    except Unknown:
      return { }

    return None if ctr == None else _unssa_z3_model(ctr, ssa_env.replm())

def loop_vc_post_ctrex(loop, inv, bbs):
    exit_path = unique(loop.exit_paths)
    exit_ssa, ssa_env = nd_bb_path_to_ssa(exit_path, bbs, SSAEnv(None, ""))

    z3_postcondition = wp_nd_ssa_path(exit_ssa, bbs, Bool(True), AllIntTypeEnv())
    z3_loop_entry_cond = expr_to_z3(loop.entry_cond, AllIntTypeEnv())
    z3_inv = expr_to_z3(inv, AllIntTypeEnv())

    #Note: We expect the negation of the z3_loop_entry_cond to be the first
    #assume in the exit block.
    #q = Implies(And(z3_inv, Not(z3_loop_entry_cond)), z3_postcondition)
    q = Implies(And(z3_inv), z3_postcondition)

    try:
      ctr = counterex(q)
    except Unknown:
      return { }

    return None if ctr == None else _unssa_z3_model(ctr, {})
