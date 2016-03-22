from boogie_ast import *;
from boogie_z3 import *
from collections import namedtuple
from z3 import *

BB = namedtuple("BB", ["predecessors", "stmts", "successors"])

def get_bbs(filename):
    ast = parseAst(open(filename).read())
    fun = ast[0]._children[0][0]
    assert (isinstance(fun, AstImplementation))
    # Step 1: Break statements into basic blocks
    bbs = {}
    curLbl = None
    for stmt in fun.body.stmts:
        # A BB starts with a labeled statment
        if (isinstance(stmt, AstLabel)):
            curLbl = str(stmt.label);
            bbs[curLbl] = BB([], [], [])
            stmt = stmt.stmt;

        if (isinstance(stmt, AstAssert) or
            isinstance(stmt, AstAssume) or
            isinstance(stmt, AstAssignment)):
            bbs[curLbl].stmts.append(stmt)
        elif (isinstance(stmt, AstGoto)):
            bbs[curLbl].successors.extend(map(str, stmt.labels))
            curLbl = None;
        elif (isinstance(stmt, AstReturn)):
            curLbl = None;
        else:
            raise Exception("Unknown statement : " + str(stmt))

    for bb in bbs:
        for succ in bbs[bb].successors:
            bbs[succ].predecessors.append(bb)

    return bbs

def entry(bbs):
    e = [x for x in bbs if len(bbs[x].predecessors) == 0]
    assert (len(e) == 1)
    return e[0]

def exit(bbs):
    e = [x for x in bbs if len(bbs[x].successors) == 0]
    assert (len(e) == 1)
    return e[0]

def bbpath_to_stmts(bb_path, bbs):
    r = []
    for b in bb_path:   
        r.extend(bbs[b].stmts)
    return r

class SSAEnv:
    def __init__(s):
        s._cnt = {}

    def lookup(s, v):
        if v in s._cnt:
            return v + "_ssa_" + str(s._cnt[v])
        else:
            return v

    def update(s, v):
        s._cnt[v] = s._cnt.get(v, 0) + 1

def path_to_ssa(p):
    path = []
    ssa_env = SSAEnv()
    repl_map = {}
    for stmt in p: 
        if isinstance(stmt, AstAssignment):
            lhs_name = stmt.lhs.name
            new_expr = replace(stmt.rhs, repl_map)
            ssa_env.update(lhs_name)
            new_name = ssa_env.lookup(lhs_name)
            repl_map[AstId(lhs_name)] = AstId(new_name)
            path.append(AstAssignment(AstId(new_name), new_expr))
        else:
            path.append(replace(stmt, repl_map))
    return path

def path_to_z3(path):
    return [stmt_to_z3(stmt, AllIntTypeEnv()) for stmt in path]

def is_path_possible(bbpath, bbs):
    q = path_to_z3(path_to_ssa(bbpath_to_stmts(bbpath, bbs)))
    print path_to_ssa(bbpath_to_stmts(bbpath, bbs))
    s = Solver()
    for x in q:
        s.append(x)

    return sat == s.check();

def get_path_vars(bbpath, bbs):
    p = bbpath_to_stmts(bbpath, bbs)
    q = path_to_z3(path_to_ssa(p))
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

    if (not is_path_possible(curpath, bbs)):
        return

    for s in bbs[curpath[-1]].successors:
        if (s in curpath):
            yield curpath + [s]
            continue
        curpath.append(s)
        for t in loops(bbs, curpath):
            yield t
        curpath.pop()


# Assumes single loop at the end of the path
def unroll_loop(loop_path, nunrolls):
    return loop_path[:-1] + loop_path[loop_path.index(loop_path[-1]):-1] * (nunrolls - 1)

# Assumes single loop at the end of the path
def get_loop_header_values(loop, bbs):
    # Prefix Path
    prefix_bbs = loop[:loop.index(loop[-1])]
    loop_bbs = loop[loop.index(loop[-1]):-1]
    print "Prefix: ", prefix_bbs
    print "Loop: ", loop_bbs
    nPrefixStmts = len(bbpath_to_stmts(prefix_bbs, bbs))
    nLoopStmts =  len(bbpath_to_stmts(loop_bbs, bbs))

    # Try unrolling it up to 5 times
    nunrolls = 1;

    while is_path_possible(unroll_loop(loop, nunrolls), bbs) and nunrolls <= 5:
        nunrolls += 1;

    unrolled_path = unroll_loop(loop, nunrolls)

    assert nPrefixStmts + nunrolls * nLoopStmts == len(bbpath_to_stmts(unrolled_path, bbs))
    path_vars = get_path_vars(unrolled_path, bbs)
    return [path_vars[nPrefixStmts + i * nLoopStmts] for i in xrange(0, nunrolls)]

if __name__ == "__main__":
    bbs = get_bbs("desugared3.bpl")

    print "LOOPS:"
    for loop in loops(bbs):
        print loop
        print unroll_loop(loop, 2)
        print unroll_loop(loop, 3)
        print unroll_loop(loop, 5)

    unrolled_p = unroll_loop(loop, 3)
    m = get_path_vars(unrolled_p, bbs)
    print zip(m, bbpath_to_stmts(unrolled_p, bbs))
    print get_loop_header_values(loop, bbs)
