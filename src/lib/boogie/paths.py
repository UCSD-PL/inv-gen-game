from lib.boogie.ast import stmt_changed, AstAssignment, AstId, AstHavoc, \
        AstAssert, AstTrue, replace, AstNode, AstExpr, AstStmt_T, AstStmt, _force_stmt
from lib.boogie.z3_embed import Or, And, Int, And, stmt_to_z3, satisfiable,\
    model, TypeEnv_T, get_typeenv
from lib.boogie.bb import BB, Label_T, Function
from lib.boogie.ssa import SSAEnv, is_ssa_str, ReplMap_T, get_ssa_tenv
from lib.boogie.predicate_transformers import wp_stmts, sp_stmts
from lib.common.util import flattenList
from lib.boogie.interp import Store

from typing import TYPE_CHECKING, List, Union, Any, Set, Tuple, Iterator,\
        Iterable, overload
import z3

#A (potentially) non-deterministic path is a sequnce of basic blocks or other non-deterministic paths.
#For example if we have the BB graph:
#           BB1
#          /   \
#         BB2  BB3
#           \  /
#            BB4
#
# The path: [BB1, [ [BB2], [BB3] ], BB4] expresses a flow that starts at BB1, non-deterministically
# chooses to go through BB2 or BB3, and then ends at BB4.
class NondetNode(object):
    def __init__(self, paths: List["NondetPath"]) -> None:
        self.paths = paths

    def __iter__(self) -> Iterator["NondetPath"]:
        return iter(self.paths)

NondetPathNode_T = Union[BB, NondetNode]
class NondetPath(List[NondetPathNode_T]):
    def ssa(self, ssa_env: SSAEnv, cur_p: str = "") -> Tuple["NondetSSAPath", SSAEnv]:
        pass

# TODO: Abstract the definition of NondetPath and NondetSSAPath to a single
# ListLike[BaseT], that acts as a list containing either BaseT or ListLike[BaseT]'s

#A (potentially) non-deterministic SSA path is the same as a non-deterministic path, but it additionally holds:
#   1. For every basic block in the path, a list of ReplMap_T's, one for each statement in the BB, that map the
#       variables in each BB into their SSA-ed versions
#
#   2. For each place in the path that a non-deterministic choice can be made, an additional choice_variable,
#      that is assigned a unique value for each of the possible choices at that junction.
#
#   These additional datastructures make it easier to encode the fact that control flow takes a given non-deterministic path 
#   as a Z3 query.
class NondetSSAPathNode:
    """ Base NondetSSAPathNode class """
    def to_z3(self, tenv: TypeEnv_T) -> z3.ExprRef:
        raise Exception("NYI")

    def wp(self, pred: z3.ExprRef, tenv: TypeEnv_T) -> z3.ExprRef:
        raise Exception("NYI")

    def sp(self, pred: z3.ExprRef, tenv: TypeEnv_T) -> z3.ExprRef:
        raise Exception("NYI")

class SSABBNode(NondetSSAPathNode):
    """ A NondetSSAPathNode representing a single basic block. Contains a list of ReplMap_T's mapping the
        variables in each AstStmt in the basic block to their SSA-ed values
    """
    def __init__(self, bb: BB, repl_m: List[ReplMap_T]) -> None:
        self.bb = bb
        self.repl_maps = list(repl_m)
        assert len(repl_m) <= len(self.bb) + 1

    def to_z3(self, tenv: TypeEnv_T) -> z3.ExprRef:
        return And([stmt_to_z3(stmt, tenv) 
            for stmt in _ssa_stmts(list(self.bb.stmts()), self.repl_maps)])

    def wp(self, pred: z3.ExprRef, tenv: TypeEnv_T) -> z3.ExprRef:
        return wp_stmts(_ssa_stmts(self.bb, self.repl_maps), pred, tenv)

    def sp(self, pred: z3.ExprRef, tenv: TypeEnv_T) -> z3.ExprRef:
        return sp_stmts(_ssa_stmts(self.bb, self.repl_maps), pred, tenv)

    def __str__(self) -> str:
        return str(self.bb)

    def __repr__(self) -> str:
        return str(self)

class SSANondetNode(NondetSSAPathNode):
    """ A NondetSSAPathNode representing a non-deterministic choice between 
        several possible paths. Contains a list of the possible paths, as well as
        a SSA choice_var that is assigned a unique value in each of the paths. (useful for
        expressing the fact that the non-deterministic choice takes only ONE path).
    """
    def __init__(self, choice_var: str, paths: List["NondetSSAPath"]) -> None:
        self.choice_var = choice_var
        self.paths = paths

    def __iter__(self) -> Iterator["NondetSSAPath"]:
        return iter(self.paths)

    def to_z3(self, tenv: TypeEnv_T) -> z3.ExprRef:
        return Or([And((Int(self.choice_var) == ind), path.to_z3(tenv))
            for ind, path in enumerate(self.paths)])

    def wp(self, pred: z3.ExprRef, tenv: TypeEnv_T) -> z3.ExprRef:
        return Or([subpath.wp(pred, tenv) for subpath in self.paths])

    def sp(self, pred: z3.ExprRef, tenv: TypeEnv_T) -> z3.ExprRef:
        return Or([subpath.sp(pred, tenv) for subpath in self.paths])

    def __str__(self) -> str:
        return "{[" + ";".join(str(x) for x in self.paths) + "]}"

class NondetSSAPath(List[NondetSSAPathNode]):
    def exits(self) -> Iterable[SSABBNode]:
        last = self[-1]
        if isinstance(last, SSABBNode):
            return [last]
        else:
            assert isinstance(last, SSANondetNode)
            return flattenList([list(subp.exits()) for subp in last.paths])

    def to_z3(self, tenv: TypeEnv_T) -> z3.ExprRef:
        return And([node.to_z3(tenv) for node in self])

    def wp(self, pred: z3.ExprRef, tenv: TypeEnv_T) -> z3.ExprRef:
        for node in reversed(self):
            pred = node.wp(pred, tenv)
        return pred

    def sp(self, pred: z3.ExprRef, tenv: TypeEnv_T) -> z3.ExprRef:
        for node in self:
            pred = node.sp(pred, tenv)
        return pred

    def __str__(self) -> str:
        return "P(" + super().__str__() + ")"

# TODO: Make this type more accurate similarly to the way  NondetSSAPath is implemented
NondetPathEnvs_T = List[Any]

def nd_bb_path_to_ssa(p: NondetPath, ssa_env: SSAEnv, cur_p: str = "") -> Tuple[NondetSSAPath, SSAEnv]:
    path = NondetSSAPath([]) # type: NondetSSAPath 
    for ind, arg in enumerate(p):
        if isinstance(arg, BB):
            repl_ms = [ ssa_env.replm() ] # type: List[ReplMap_T]
            for stmt in arg:
                for name in stmt_changed(stmt):
                    ssa_env.update(name)
                    _ = ssa_env.lookup(name)
                repl_ms.append(ssa_env.replm())
            path.append(SSABBNode(arg, repl_ms))
        else:
            assert isinstance(arg, NondetNode)
            tmp = [] # type: List[Tuple[NondetSSAPath, SSAEnv]]
            choice_var = "_split_" + cur_p + "." + str(ind)

            # Build each SSA-ed subpath
            for nsplit, subp in enumerate(arg.paths):
                suffix = cur_p + "." + str(ind) + "." + str(nsplit) + "."
                ssaed_subpath = \
                  nd_bb_path_to_ssa(subp, SSAEnv(ssa_env, suffix),
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
            for (nsplit, (ssa_subp, sub_env)) in enumerate(tmp):
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

                bb = BB(bb_name, [], bb_stmts, set(), True)
                ssa_subp.append(SSABBNode(bb, bb_replmps))
            path.append(SSANondetNode(choice_var, [x[0] for x in tmp]))

    return (path, ssa_env)

def ssa_stmt(stmt: AstStmt, prev_replm: ReplMap_T, cur_replm: ReplMap_T) -> AstStmt:
    # Havoc's turn into no-ops when SSA-ed.
    if isinstance(stmt, AstHavoc):
        return AstAssert(AstTrue())
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

def is_nd_bb_path_possible(bbpath: NondetPath, f: Function) -> bool:
    nd_ssa_p, _ = nd_bb_path_to_ssa(bbpath, SSAEnv(None, ""))
    tenv = get_ssa_tenv(get_typeenv(f))
    return satisfiable(nd_ssa_p.to_z3(tenv))

def extract_ssa_path_vars(ssa_p: NondetSSAPath, m: Store) -> NondetPathEnvs_T:
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
                    envs.append(new_env)

                concrete_ssa_path.append((bb,envs))
        return concrete_ssa_path

    return [x for x in _helper(ssa_p) if '_union_' not in x[0]]

def get_path_vars(bbpath: NondetPath, f: Function) -> NondetPathEnvs_T:
    ssa_p, _ = nd_bb_path_to_ssa(bbpath, SSAEnv(None, ""))
    tenv = get_ssa_tenv(get_typeenv(f))
    m = model(ssa_p.to_z3(tenv))
    return extract_ssa_path_vars(ssa_p, m)