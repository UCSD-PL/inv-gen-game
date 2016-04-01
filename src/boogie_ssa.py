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

    def contains(s, v):
        return v in s._cnt

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

def is_ssa_str(s):
    return "_ssa_" in s

def unssa_str(s):
    return s[:s.rfind("_ssa_")]

def unssa_z3_model(m, repl_m):
    updated = map(str, repl_m.keys())
    original = [ x for x in map(str, m.decls()) if not is_ssa_str(x) and x not in updated ] 
    return { (unssa_str(x) if is_ssa_str(x) else x) : m[Int(x)] for x in
        original + map(str, repl_m.values()) }
