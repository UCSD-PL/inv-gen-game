from boogie_ast import *;
from boogie_z3 import *
from boogie_bb import *
from boogie_verify import *
from boogie_ssa import *
from collections import namedtuple
from z3 import *

def path_to_z3(path):
    return [stmt_to_z3(stmt, AllIntTypeEnv()) for stmt in path]

def is_stmt_path_possible(path):
    ssa_p, _ = path_to_ssa(path)
    q = path_to_z3(ssa_p)
    s = Solver()
    for x in q:
        s.append(x)

    return sat == s.check();

def is_bb_path_possible(bbpath, bbs):
    return is_stmt_path_possible(bbpath_to_stmts(bbpath, bbs))

def get_path_vars(bbpath, bbs):
    p = bbpath_to_stmts(bbpath, bbs)
    ssa_p, _ = path_to_ssa(p)
    q = path_to_z3(ssa_p)
    s = Solver()
    for x in q:
        s.append(x)
    assert(sat == s.check())

    m = s.model()
    ssa_env = SSAEnv()
    envs = []
    defined = set()
    for stmt in p: 
        defined = defined.union(stmt_read(stmt))
        envs.append({ x : m[Int(ssa_env.lookup(x))] for x in defined })

        for v in stmt_changed(stmt):
            ssa_env.update(v)
            defined.add(v)

    return envs;

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
    print bb_in_loop, loop_succ
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

if __name__ == "__main__":
    bbs = get_bbs("desugared3.bpl")

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
