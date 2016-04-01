from boogie_ast import *;
from boogie_z3 import *
from boogie_exec import *
from boogie_bb import *
from boogie_verify import *
from boogie_ssa import *
from collections import namedtuple
from z3 import *

def loops(bbs, curpath = []):
    if (curpath == []):
        curpath.append(entry(bbs))

    if (not is_bb_path_possible(curpath, bbs)):
        return

    for s in bbs[curpath[-1]].successors:
        if (s in curpath):
            yield curpath + [s]
            continue
        curpath.append(s)
        for t in loops(bbs, curpath):
            yield t
        curpath.pop()

def loop_exit_bb(loop, bbs):
    loop_succ = bbs[loop[-1]].successors
    assert (len(loop_succ) == 2)
    bb_in_loop = bbs[loop[loop.index(loop[-1]) + 1]]
    return loop_succ[0] if bbs[loop_succ[1]] == bb_in_loop else loop_succ[1]

# Assumes single loop at the end of the path
def unroll_loop(loop_path, nunrolls):
    return loop_path[:-1] + loop_path[loop_path.index(loop_path[-1]):-1] * (nunrolls - 1)

def loop_prefix(loop):
    return loop[:loop.index(loop[-1])]

def loop_body(loop):
    return loop[loop.index(loop[-1]):-1]

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

    unrolled_path = unroll_loop(loop, nunrolls)

    assert nPrefixStmts + nunrolls * nLoopStmts == len(bbpath_to_stmts(unrolled_path, bbs))
    path_vars = get_path_vars(unrolled_path, bbs)
    return [path_vars[nPrefixStmts + i * nLoopStmts] for i in xrange(0, nunrolls)]

def loop_vc_pre_ctrex(loop, inv, bbs):
    prefix = loop_prefix(loop)
    prefix_ssa, ssa_m = path_to_ssa(bbpath_to_stmts(prefix, bbs))
    q = Not(Implies(And(path_to_z3(prefix_ssa)), expr_to_z3(replace(inv, ssa_m), AllIntTypeEnv())))
    ctr = counterex(q)
    return None if not ctr else unssa_z3_model(ctr, ssa_m)

def loop_vc_post_ctrex(loop, inv, bbs):
    exit_path = [ loop_exit_bb(loop, bbs) ]
    exit_ssa, ssa_m = path_to_ssa(bbpath_to_stmts(exit_path, bbs))
    q = Not(Implies(expr_to_z3(inv, AllIntTypeEnv()), wp_stmts(exit_ssa, BoolVal(True), AllIntTypeEnv())))
    ctr = counterex(q)
    return None if not ctr else unssa_z3_model(ctr, {})

def loop_vc_ind_ctrex(loop, inv, bbs):
    body = loop_body(loop)
    body_ssa, ssa_m = path_to_ssa(bbpath_to_stmts(body, bbs))
    q = Not(Implies(And(expr_to_z3(inv, AllIntTypeEnv()), And(path_to_z3(body_ssa))),
                    expr_to_z3(replace(inv, ssa_m), AllIntTypeEnv())))
    ctr = counterex(q)
    return None if not ctr else (unssa_z3_model(ctr, {}), unssa_z3_model(ctr, ssa_m))
    
if __name__ == "__main__":
    bbs = get_bbs("desugared3_no_inv.bpl")

    print "Loops: "
    for loop in loops(bbs):
        print loop
        break

    print "Unrolling loop 3 times: "
    unrolled_p = unroll_loop(loop, 3)
    m = get_path_vars(unrolled_p, bbs)
    for (vrs, stmt) in zip(m, bbpath_to_stmts(unrolled_p, bbs)):
        print str(stmt), " // Live Vars: ", vrs
    print "=================="
    print "Values at loop header if we unroll 5 times: "
    print get_loop_header_values(loop, bbs, 5)
    def tryinv(inv):
        print "Pre counter example for " + inv, str(loop_vc_pre_ctrex(loop, parseExprAst(inv)[0], bbs))
        print "Post counter example for " + inv, str(loop_vc_post_ctrex(loop, parseExprAst(inv)[0], bbs))
        print "Ind counter example for " + inv, str(loop_vc_ind_ctrex(loop, parseExprAst(inv)[0], bbs))
    
    tryinv("j+k>=n")
    tryinv("n < 2")
    tryinv("k > 2*n")
    tryinv("j+k>=n && j <= n")
