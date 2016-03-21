from boogie_ast import *;
from boogie_z3 import *
from collections import namedtuple

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
    assert (len(e) == 0)
    return e[0]

def exit(bbs):
    e = [x for x in bbs if len(bbs[x].successors) == 0]
    assert (len(e) == 0)
    return e[0]

def bbpath_to_stmts(bb_path, bbs):
    r = []
    for b in bb_path:   
        r.extend(bbs[b].stmts)
    return r

def path_to_ssa(p):
    path = []
    ssa_env = {}
    repl_map = {}
    for stmt in p: 
        if isinstance(stmt, AstAssignment):
            lhs_name = stmt.lhs.name
            new_expr = replace(stmt.rhs, repl_map)
            ssa_env[lhs_name] = ssa_env.get(lhs_name, 0) + 1
            new_name = lhs_name + str(ssa_env[lhs_name])
            repl_map[AstId(lhs_name)] = AstId(new_name)
            path.append(AstAssignment(AstId(new_name), new_expr))
        else:
            path.append(replace(stmt, repl_map))
    return path

def path_to_z3(path):
    return [stmt_to_z3(stmt, AllIntTypeEnv()) for stmt in path]

if __name__ == "__main__":
    bbs = get_bbs("desugared2.bpl")
    print bbpath_to_stmts(['anon0'], bbs)
    print path_to_z3(bbpath_to_stmts(['anon0'], bbs))
    print path_to_ssa(bbpath_to_stmts(['anon0'], bbs))
    print path_to_ssa(bbpath_to_stmts(['anon0', 'anon5_LoopHead', 'anon5_LoopBody'], bbs))
    print path_to_z3(path_to_ssa(bbpath_to_stmts(['anon0', 'anon5_LoopHead', 'anon5_LoopBody'], bbs)))
