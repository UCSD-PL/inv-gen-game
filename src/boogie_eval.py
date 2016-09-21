from boogie_z3 import *
from boogie_ast import *
from boogie_paths import get_path_vars
from itertools import permutations

def val_to_boogie(v):
    if (isinstance(v, IntNumRef)):
        return AstNumber(v.as_long())
    elif (isinstance(v, BoolRef)):
        return AstTrue() if is_true(v) else AstFalse()
    elif (v == "true"):
        return AstTrue()
    elif (v == "false"):
        return AstFalse()
    else:
        return AstNumber(int(v))

def env_to_expr(env, suff = ""):
    return ast_and([ AstBinExpr(AstId(k + suff), "==", val_to_boogie(v))
        for (k,v) in env.iteritems() ])

def evalPred(boogie_expr, env, consts = []):
    s = Solver()
    typeEnv = { x : Int for x in env }
    typeEnv["__result__"] = Bool
    q = And(map(lambda stmt:    stmt_to_z3(stmt, typeEnv),
        [AstAssume(env_to_expr(env)),
         AstAssert(AstBinExpr(AstId("__result__"), "<==>", boogie_expr))]))
    s.append(q)
    assert(sat == s.check())
    m = s.model()
    return (m[Bool("__result__")], [m[Int(c)] for c in consts])

# Given an invariant template as a boogie expression where [x,y,z] are
# variables and [a,b,c] constants And a series of environments, find all
# instantiations of the template that holds for all elements of the series.
def instantiateAndEval(inv, vals, var_names = ["x", "y", "z"], const_names = ["a", "b", "c"] ):
    def vars(expr): return [ x for x in expr_read(expr) if x in var_names ]
    def consts(expr): return [ x for x in expr_read(expr) if x in const_names ]

    res = []
    symVs = vars(inv)
    symConsts = consts(inv)
    nonSymVs = set(expr_read(inv)).difference(set(symVs)).difference(set(symConsts))
    traceVs = vals[0].keys()
    prms = permutations(range(len(traceVs)), len(symVs))

    typeEnv = { str(x) + str(i) : Int for x in vals[0].keys() for i in xrange(len(vals)) }
    typeEnv.update({ str(c) : Int for c in symConsts })

    for prm in prms:
        varM = { symVs[i]: traceVs[prm[i]] for i in xrange(len(symVs)) }
        varM.update({ nonSymV: nonSymV for nonSymV in nonSymVs })

        inst_inv = replace(inv, { AstId(x) : AstId(varM[x]) for x in symVs })
        p = [ AstAssume(env_to_expr(x, str(i))) for (i,x) in enumerate(vals) ]
        p += [ AstAssert(replace(inst_inv, { AstId(x) : AstId(x + str(i)) for x in varM.values() }))
               for i in xrange(len(vals)) ]

        s = Solver();
        s.add(And(map(lambda s: stmt_to_z3(s, typeEnv), p)))

        if (sat == s.check()):
            m = s.model()
            const_vals = { AstId(x) : AstNumber(m[Int(x)].as_long()) for x in symConsts }
            res.append(replace(inst_inv, const_vals))

    return res
