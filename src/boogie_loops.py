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

def _loops(bbs, curpath = [], loop_m = {}):
    if (curpath == []):
        curpath.append(entry(bbs))

    if (not is_nd_bb_path_possible(curpath, bbs)):
        return

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
    loop_m = _loops(bbs)
    return [ Loop(k, v, [[ v[0][0], loop_exit_bb(v, bbs) ]]) \
        for (k,v) in loop_m.iteritems() ]

def loop_exit_bb(body_paths, bbs):
    loop_header_succ = set(bbs[body_paths[0][0]].successors)
    bbs_in_loop = set([p[1] for p in body_paths])
    assert (len(loop_header_succ) == len(bbs_in_loop) + 1) # Singular exit node
    # TODO: Check that no other paths exit the loop (sanity)
    return unique(loop_header_succ.difference(bbs_in_loop))

# Assumes single loop at the end of the path
def unroll_loop(loop, nunrolls):
    return list(loop.header) + nunrolls * [ loop.loop_paths ]

# Assumes single loop at the end of the path
def get_loop_header_values(loop, bbs, unrollLimit = 5):
    # Prefix Path
    prefix_bbs = loop_prefix(loop)
    loop_bbs = loop_body(loop)
    nPrefixStmts = len(bbpath_to_stmts(prefix_bbs, bbs))
    nLoopStmts =  len(bbpath_to_stmts(loop_bbs, bbs))

    # Try unrolling it up to 5 times
    nunrolls = 1;

    while is_bb_path_possible(unroll_loop(loop, nunrolls), bbs) and nunrolls <= unrollLimit:
        nunrolls += 1;

    #TODO: Fix unroll_loop to support newer version loops
    unrolled_path = unroll_loop(loop, nunrolls)

    assert nPrefixStmts + nunrolls * nLoopStmts == len(bbpath_to_stmts(unrolled_path, bbs))
    path_vars = get_path_vars(unrolled_path, bbs)
    return [path_vars[nPrefixStmts + i * nLoopStmts] for i in xrange(0, nunrolls)]

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
    #print "Values at loop header if we unroll 5 times: "
    #print get_loop_header_values(loop, bbs, 5)
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
