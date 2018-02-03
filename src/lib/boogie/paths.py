from lib.boogie.ast import stmt_changed, AstAssignment, AstId, AstHavoc, \
        AstAssert, AstTrue, replace, AstNode, AstExpr, AstStmt_T, AstStmt, _force_stmt
from lib.boogie.z3_embed import Or, And, Int, And, stmt_to_z3, \
        AllIntTypeEnv, satisfiable, model, Env_T, TypeEnv_T
from lib.boogie.bb import BB, Label_T, BBs_T
from lib.boogie.ssa import SSAEnv, is_ssa_str, ReplMap_T
from lib.boogie.predicate_transformers import wp_stmts, sp_stmts

from typing import TYPE_CHECKING, List, Union, Any, Set, Tuple
import z3


BBPath_T= List[Label_T]
NondetBBPath_T = List[Any]
NondetSSABBPath_T = List[Any]
NondetPathEnvs_T = List[Any]

#BB_PATH = [ BB_LABEL ]
#NONDET_BB_PATH = [ (BB | [ NONDET_BB_PATH ] ) ]
#NONDET_SSA_BB_PATH = [ (BB, [ REPL_M ]) |
#                       ( CHOICE_VAR, [ NONDET_SSA_BB_PATH ] ) ]

def nd_bb_path_to_ssa(p: NondetBBPath_T, bbs: BBs_T, ssa_env: SSAEnv, cur_p: str = "") -> Tuple[NondetSSABBPath_T, SSAEnv]:
    path = [] # type: NondetSSABBPath_T 
    for ind, arg in enumerate(p):
        if isinstance(arg, str):
            repl_ms = [ ssa_env.replm() ]
            for stmt in bbs[arg].stmts:
                for name in stmt_changed(stmt):
                    ssa_env.update(name)
                    _ = ssa_env.lookup(name)
                repl_ms.append(ssa_env.replm())
            path.append((arg, repl_ms))
        else:
            tmp = [] # type: List[Tuple[NondetSSABBPath_T, SSAEnv]]
            choice_var = "_split_" + cur_p + "." + str(ind)

            # Build each SSA-ed subpath
            for nsplit, subp in enumerate(arg):
                suffix = cur_p + "." + str(ind) + "." + str(nsplit) + "."
                ssaed_subpath = \
                  nd_bb_path_to_ssa(subp, bbs, SSAEnv(ssa_env, suffix),
                                    cur_p + suffix)
                tmp.append(ssaed_subpath)

            # Compute the set of variables changed across ALL paths
            changed = set() #type: Set[str]
            for (dummy, sub_env) in tmp:
                changed.update(sub_env.changed())

            # Compute their ssa name BEFORE the paths
            old_varm = { s : ssa_env.lookup(s) for s in changed }
            # Make sure each of them is upded in the environment AFTER the paths
            for s in changed:
                ssa_env.update(s)

            # For each sub-path add a "union" block at the end
            # that makes sure the SSA-ed names of all changed variables
            # across all paths match up
            for (nsplit, (subp, sub_env)) in enumerate(tmp):
                bb_name = "_union_"  + cur_p + "." + str(ind) + "." + \
                          str(nsplit)
                bb_stmts = []
                bb_replmps = [ sub_env.replm() ]

                for s in changed:
                    if (s in sub_env.changed()):
                        old_var = sub_env.lookup(s)
                        sub_env.remove(s)
                    else:
                        old_var = old_varm[s]

                    bb_stmts.append(AstAssignment(AstId(ssa_env.lookup(s)),
                                                  AstId(old_var)))
                    bb_replmps.append(sub_env.replm())

                bb = BB(set(), bb_stmts, set())
                bbs[bb_name] = bb
                subp.append((bb_name, bb_replmps))
            path.append((choice_var, [x[0] for x in tmp]))

    return (path, ssa_env)

def ssa_stmt(stmt: AstStmt, prev_replm: ReplMap_T, cur_replm: ReplMap_T) -> AstStmt:
    # Havoc's turn into no-ops when SSA-ed.
    if isinstance(stmt, AstHavoc):
        return AstAssert(AstTrue());
    if isinstance(stmt, AstAssignment):
        lhs = replace(stmt.lhs, cur_replm)
        rhs = replace(stmt.rhs, prev_replm)
        assert isinstance(lhs, AstId)
        assert isinstance(rhs, AstExpr)
        return AstAssignment(lhs,rhs)
    else:
        return _force_stmt(replace(stmt, cur_replm))

def _ssa_stmts(stmts: List[AstStmt], envs: List[ReplMap_T]) -> List[AstStmt]:
    return [ssa_stmt(stmts[i], envs[i], envs[i+1])
                for i in range(0, len(stmts))]

def ssa_path_to_z3(ssa_path: NondetSSABBPath_T, bbs: BBs_T) -> z3.ExprRef:
    def f(arg: Any) -> z3.ExprRef:
        if (arg[0].startswith("_split_")):
            split_var = arg[0]
            return Or([And((Int(split_var) == ind), ssa_path_to_z3(x, bbs))
                for ind, x in enumerate(arg[1])])
        else:
            return And([stmt_to_z3(stmt, AllIntTypeEnv())
                for stmt in _ssa_stmts(bbs[arg[0]].stmts, arg[1])])
    return And(list(map(f, ssa_path)))

def is_nd_bb_path_possible(bbpath: NondetBBPath_T, bbs: BBs_T) -> bool:
    nd_ssa_p, _ = nd_bb_path_to_ssa(bbpath, bbs, SSAEnv(None, ""))
    return satisfiable(ssa_path_to_z3(nd_ssa_p, bbs))

def extract_ssa_path_vars(ssa_p: NondetSSABBPath_T, m: Env_T) -> NondetPathEnvs_T:
    argsS = set([str(x) for x in m
        if (not is_ssa_str(str(x)) and '_split_' not in str(x))])

    def _helper(ssa_p: Any) -> List[Any]:
        concrete_ssa_path = [] # type: List[Any] 
        for (_, arg) in enumerate(ssa_p):
            if (arg[0].startswith("_split_")):
                choice_var, nd_paths = arg
                taken_ssa_path = nd_paths[m[choice_var]]
                concrete_ssa_path.extend(_helper(taken_ssa_path))
            else:
                (bb, repl_ms) = arg
                envs = []
                for repl_m in repl_ms:
                    vs = set(map(str, iter(repl_m.keys()))).union(argsS)
                    new_env = { orig_name : m.get(ssa_name, None)
                                    for (orig_name, ssa_name) in
                                        [(x, str(repl_m.get(AstId(x), x)))
                                            for x in vs
                                        ]
                              }
                    envs.append(new_env);

                concrete_ssa_path.append((bb,envs))
        return concrete_ssa_path

    return [x for x in _helper(ssa_p) if '_union_' not in x[0]]


def get_path_vars(bbpath: BBPath_T, bbs: BBs_T) -> NondetPathEnvs_T:
    ssa_p, _ = nd_bb_path_to_ssa(bbpath, bbs, SSAEnv(None, ""))
    m = model(ssa_path_to_z3(ssa_p, bbs))
    return extract_ssa_path_vars(ssa_p, m);

def wp_nd_ssa_path(ssa_p: NondetSSABBPath_T, bbs: BBs_T, pred: z3.ExprRef, typeEnv: TypeEnv_T) -> z3.ExprRef:
    for arg in reversed(ssa_p):
        if (arg[0].startswith("_split_")):
            pred = Or([wp_nd_ssa_path(subp, bbs, pred, typeEnv)
                        for subp in arg[1]])
        else:
            pred = wp_stmts(_ssa_stmts(bbs[arg[0]].stmts, arg[1]),
                            pred,
                            typeEnv)
    return pred

def sp_nd_ssa_path(ssa_p: NondetSSABBPath_T, bbs: BBs_T, pred: z3.ExprRef, typeEnv: TypeEnv_T) -> z3.ExprRef:
    for arg in ssa_p:
        if (arg[0].startswith("_split_")):
            pred = Or([sp_nd_ssa_path(subp, bbs, pred, typeEnv)
                        for subp in arg[1]])
        else:
            pred = sp_stmts(_ssa_stmts(bbs[arg[0]].stmts, arg[1]),
                            pred,
                            typeEnv)
    return pred
