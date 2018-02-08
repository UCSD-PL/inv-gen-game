from lib.boogie.z3_embed import And, stmt_to_z3, env_to_expr, satisfiable, Int,\
    maybeModel, expr_to_z3, AllIntTypeEnv, simplify, model, Env_T, TypeEnv_T,\
    _force_expr as _z3_force_expr
from lib.boogie.ast import expr_read, AstAssume, AstAssert, replace, AstId,\
        AstNumber, AstExpr, _force_expr, AstStmt, ReplMap_T
from lib.boogie.paths import get_path_vars, nd_bb_path_to_ssa, \
        extract_ssa_path_vars, NondetPath, NondetSSAPath, NondetPathEnvs_T
from lib.boogie.predicate_transformers import sp_stmts
from lib.boogie.ssa import SSAEnv
from lib.boogie.bb import Function, Label_T, BB
from itertools import permutations
from copy import deepcopy
from typing import TypeVar, List, Dict, Iterator, Tuple, Any
import z3

T=TypeVar("T")
U=TypeVar("U")

#
# TODO: This whole file should be deprecated in favor of interp.py. Please
# don't use any of these
#

def _to_dict(vs: List[T], vals: List[U]) -> Dict[T,U]:
    return { vs[i]: vals[i] for i in range(0, len(vs)) }

def evalPred(boogie_expr: AstExpr, env: Env_T) -> bool:
    typeEnv = { x : Int for x in env } # type: TypeEnv_T
    q = And([stmt_to_z3(stmt, typeEnv) for stmt in [AstAssume(env_to_expr(env)),
         AstAssert(boogie_expr)]])
    res = satisfiable(q)
    return res

# Given an invariant template as a boogie expression where [x,y,z] are
# variables and [a,b,c] constants And a series of environments, find all
# instantiations of the template that holds for all elements of the series.
def instantiateAndEval(inv: AstExpr,
        vals: List[Env_T],
        var_names : List[str] = None,
        const_names : List[str] = None) -> List[AstExpr]:

    if (var_names == None):
        var_names = ["_sv_x", "_sv_y", "_sv_z"]

    if (const_names == None):
        const_names = ["_sc_a", "_sc_b", "_sc_c"]

    res = [] # type: List[AstExpr]
    symVs = [ x for x in expr_read(inv) if x in var_names ]
    symConsts = [ x for x in expr_read(inv) if x in const_names ]

    nonSymVs = set(expr_read(inv)).difference(set(symVs))\
            .difference(set(symConsts))
    traceVs = list(vals[0].keys())
    prms = permutations(list(range(len(traceVs))), len(symVs))

    typeEnv = { str(x) + str(i) : Int
                    for x in vals[0].keys()
                    for i in range(len(vals)) } # type: TypeEnv_T
    typeEnv.update({ str(c) : Int for c in symConsts })

    for prm in prms:
        varM = { symVs[i]: traceVs[prm[i]] for i in range(len(symVs)) }
        varM.update({ nonSymV: nonSymV for nonSymV in nonSymVs })

        inst_inv = replace(inv, { AstId(x) : AstId(varM[x]) for x in symVs })
        p = [ AstAssume(env_to_expr(x, str(i))) for (i,x) in enumerate(vals) ] # type: List[AstStmt]
        p += [ AstAssert(_force_expr(replace(inst_inv,
                                 { AstId(x) : AstId(x + str(i))
                                     for x in varM.values() })))
               for i in range(len(vals)) ]

        m = maybeModel(And([stmt_to_z3(s, typeEnv) for s in p]))

        if (m):
            const_vals = { AstId(x) : AstNumber(m[x]) for x in symConsts } # type: ReplMap_T
            res.append(_force_expr(replace(inst_inv, const_vals)))

    return res

def execute(env: Env_T, bb: BB, fun: Function, limit: int) -> Iterator[Tuple[z3.ExprRef, SSAEnv, NondetPath, NondetSSAPath, NondetPathEnvs_T]]:
    q = [ (expr_to_z3(env_to_expr(env), AllIntTypeEnv()),
           bb ,
           SSAEnv(None, ""),
           NondetPath([ ]),
           NondetSSAPath([ ])) ] # type: List[Tuple[z3.ExprRef, BB, SSAEnv, NondetPath, NondetSSAPath]]

    def bb_sp(bb: BB, initial_ssa_env: SSAEnv, precond: z3.ExprRef) -> Tuple[z3.ExprRef, SSAEnv, NondetSSAPath]:
      nd_path, final_env = nd_bb_path_to_ssa(NondetPath([bb]), initial_ssa_env)
      sp = nd_path.sp(precond, AllIntTypeEnv())
      return _z3_force_expr(simplify(sp)), final_env, nd_path

    while len(q) > 0:
      precond, bb, ssa_env, curp, cur_ssap = q.pop()
      #print "Running ", bb, " with pre: ", precond, "env:", ssa_env.replm()
      postcond, after_env, ssaed_bb = bb_sp(bb, ssa_env, precond)

      if (not satisfiable(postcond)):
        continue

      newp = NondetPath(curp + [ bb ])
      new_ssap = NondetSSAPath(cur_ssap + ssaed_bb)

      if (len(bb.successors()) == 0 or len(curp) + 1 >= limit):
        yield postcond, after_env, newp, new_ssap, \
              extract_ssa_path_vars(new_ssap, model(postcond))
        continue

      for s in bb.successors():
        q.append((postcond, s, deepcopy(after_env), newp, new_ssap))
