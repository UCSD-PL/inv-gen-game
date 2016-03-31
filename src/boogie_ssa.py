from boogie_ast import *;
from boogie_z3 import *
from boogie_bb import *
from collections import namedtuple
from z3 import *

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
    return (path, repl_map)

def unssa_z3_pred(p):
    return substitute(p, *[(x, Const(str(x)[:str(x).rfind("_ssa_")], x.sort()))
        for x in ids(p) if str(x).rfind("_ssa_") > 0])

