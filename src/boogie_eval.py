from boogie_z3 import *
from boogie_ast import *
from boogie_paths import get_path_vars
from itertools import permutations
from z3 import *

def env_to_expr(env, suff = ""):
    s = "&&".join([("(%s%s==%s)" %(k, suff, str(v))) for (k,v) in env.iteritems()])
    if (s == ""):
        return AstTrue()
    return parseExprAst(s)[0]


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
def instantiateAndEval(inv, vals):
    def vars(expr): return [ x for x in expr_read(expr) if x in ["x", "y", "z"] ]
    def consts(expr): return [ x for x in expr_read(expr) if x in ["a", "b", "c"] ]

    res = []
    vs = vars(inv)
    cs = consts(inv)
    traceVs = vals[0].keys()
    prms = permutations(range(len(traceVs)), len(vs))

    typeEnv = { str(x) + str(i) : Int for x in vals[0].keys() for i in xrange(len(vals)) }
    typeEnv.update({ str(c) : Int for c in cs })

    for prm in prms:
        varM = { vs[i]: traceVs[prm[i]] for i in xrange(len(vs)) }
        inst_inv = replace(inv, { AstId(x) : AstId(varM[x]) for x in vs })
        p = [ AstAssume(env_to_expr(x, str(i))) for (i,x) in enumerate(vals) ]
        p += [ AstAssert(replace(inst_inv, { AstId(x) : AstId(x + str(i)) for x in varM.values() }))
               for i in xrange(len(vals)) ]

        s = Solver();
        s.add(And(map(lambda s: stmt_to_z3(s, typeEnv), p)))

        if (sat == s.check()):
            m = s.model()
            const_vals = { AstId(x) : AstNumber(m[Int(x)].as_long()) for x in cs }
            res.append(replace(inst_inv, const_vals))

    return res
