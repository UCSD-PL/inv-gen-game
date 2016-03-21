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

"""
def path_to_ssa(bb_path, bbs):
    path = []
    ssa_env = {}
    repl_map = {}
    for curBB in bb_path:
        for stmt in bbs[curBB].stmts:
            if isinstance(stmt, AstAssignment):
                stmt._expr = ast_replace(stmt._expr, repl_map)
                var_old = stmt._var
                var_new = ssa_env.get(var_old, -1) + 1
                ssa_env[var_old] var_new;
                rename_map[Id(var_old)] =  
                stmt._var = var new;
            else:
    return z3_query
"""

def path_to_z3(bb_path, bbs):
    z3_query = []
    for curBB in bb_path:
        for stmt in bbs[curBB].stmts:
            z3_query.append(stmt_to_z3(stmt, AllIntTypeEnv()))
    return z3_query

if __name__ == "__main__":
    bbs = get_bbs("desugared2.bpl")
    print path_to_z3(['anon0'], bbs)
