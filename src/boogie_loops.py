from boogie_paths import is_nd_bb_path_possible
from boogie_ast import *;
from boogie_z3 import *
from boogie_bb import BB, get_bbs, entry
from boogie_paths import get_path_vars, nd_bb_path_to_ssa, ssa_path_to_z3, wp_nd_ssa_path
from boogie_ssa import *
from collections import namedtuple
from util import *
from z3 import *

Loop = namedtuple("Loop", ["header", "loop_paths", "exit_paths"])

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

def loops(bbs):
    loop_m = _loops(bbs, [], {})
    return [ Loop(k, v, [[ v[0][0], loop_exit_bb(v, bbs) ]]) \
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
    return parseExprAst(s)[0]

def good_env_to_expr(good_env):
    s = "&&".join([("(%s==%s)" %(k, str(v))) for (k,v) in good_env.iteritems()])
    if (s == ""):
        return AstTrue()
    return parseExprAst(s)[0]
  
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
            expr = good_env_to_expr(start_env)
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
    original = [ x for x in map(str, m.decls()) if not is_ssa_str(x) and x not in updated ] 
    return { (unssa_str(x) if is_ssa_str(x) else x) : m[Int(x)] for x in
        original + map(str, repl_m.values()) }

def loop_vc_pre_ctrex(loop, inv, bbs):
    prefix_ssa, ssa_env = nd_bb_path_to_ssa(list(loop.header), bbs, SSAEnv(None, ""))
    q = Not(Implies(And(ssa_path_to_z3(prefix_ssa, bbs)),
                        expr_to_z3(replace(inv, ssa_env.replm()), AllIntTypeEnv())))
    ctr = counterex(q)
    return None if not ctr else _unssa_z3_model(ctr, ssa_env.replm())

def loop_vc_post_ctrex(loop, inv, bbs):
    exit_path = unique(loop.exit_paths)
    exit_ssa, ssa_env = nd_bb_path_to_ssa(exit_path, bbs, SSAEnv(None, ""))
    q = Not(Implies(expr_to_z3(inv, AllIntTypeEnv()), wp_nd_ssa_path(exit_ssa, bbs, BoolVal(True), AllIntTypeEnv())))
    ctr = counterex(q)
    return None if not ctr else _unssa_z3_model(ctr, {})

def loop_vc_ind_ctrex(loop, inv, bbs):
    body_ssa, ssa_env = nd_bb_path_to_ssa([loop.loop_paths], bbs, SSAEnv(None, ""))
    q = Not(Implies(And(expr_to_z3(inv, AllIntTypeEnv()), ssa_path_to_z3(body_ssa, bbs)),
                    expr_to_z3(replace(inv, ssa_env.replm()), AllIntTypeEnv())))
    ctr = counterex(q)
    return None if not ctr else (_unssa_z3_model(ctr, {}), _unssa_z3_model(ctr, ssa_env.replm()))
    
######################################### TESTING #################################
if __name__ == "__main__":
    bbs = get_bbs("desugared3_no_inv.bpl")

    print "Loops: "
    for loop in loops(bbs):
        print loop
        break

    print "Unrolling loop 3 times: "
    unrolled_p = unroll_loop(loop, 3)
    unrolled_p = unrolled_p + loop.exit_paths[0]
    print "Loop unrolled 3 times: ", unrolled_p
    s = get_path_vars(unrolled_p, bbs)
    for (bb, envs) in s:
        for (stmt, vrs) in zip(bbs[bb].stmts, envs):
            print str(stmt), " // Live Vars: ", vrs
    print "=================="
    print "Values at loop header if we unroll 5 times: "
    print get_loop_header_values(loop, bbs, 0, 5)
    print get_loop_header_values(loop, bbs, 0, 5, [{ 'k': 6, 'j':0, 'n':5 }, { 'k': 7, 'j': 0, 'n': 6 }])
    """
    def tryinv(inv,loop,  bbs):
        print "Pre counter example for " + inv, str(loop_vc_pre_ctrex(loop, parseExprAst(inv)[0], bbs))
        print "Post counter example for " + inv, str(loop_vc_post_ctrex(loop, parseExprAst(inv)[0], bbs))
        print "Ind counter example for " + inv, str(loop_vc_ind_ctrex(loop, parseExprAst(inv)[0], bbs))
    
    tryinv("j+k>=n", loop, bbs)
    tryinv("n < 2", loop, bbs)
    tryinv("k > 2*n", loop, bbs)
    tryinv("j+k>=n && j <= n", loop, bbs)

    bbs = get_bbs("desugared_cegar1_noinv.bpl")
    loop = list(loops(bbs))[0]
    tryinv("x-y <= 2 && x-y >= -2", loop, bbs)
    tryinv("x-y != 4", loop, bbs)
    tryinv("!(x == 4 && y == 0)", loop, bbs)
    """
