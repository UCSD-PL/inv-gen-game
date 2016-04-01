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
