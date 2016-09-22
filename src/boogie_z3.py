import boogie_ast as ast
import z3;
from threading import local, current_thread, Lock
from z3 import substitute
from z3 import IntNumRef, BoolRef

_TL = local();

ctxPool = { }
ctxPoolLock = Lock();

shuttingDown = False;
class Die(Exception): pass

def shutdownZ3():
  global shuttingDown
  print "Shutting down Z3"
  shuttingDown = True;

  try:
      ctxPoolLock.acquire();
      for (ctx,thr) in ctxPool.iteritems():
        if (thr):
          print "Trying to interrupt z3 ctx for thread ", thr.name
          ctx.interrupt();

      z3.main_ctx().interrupt();
  finally:
      ctxPoolLock.release();

def checkShuttingDown():
  global shuttingDown

  if (shuttingDown):
    raise Die()


def get_ctx():
    if (not hasattr(_TL, "ctx")):
        # Allocate a context for this thread
        ct = current_thread()
        try:
            ctxPoolLock.acquire();
            # First GC any Ctx from the ctx pool whose threads are gone
            reclaim = [ (ctx, thr) for (ctx,thr) in ctxPool.iteritems()
                        if (thr !=None and not thr.is_alive()) ]
            for (ctx, thr) in reclaim:
                print "Reclaiming z3 ctx from dead thread " + thr.name
                ctxPool[ctx] = None;

            if (len(reclaim) > 0):
              print "Assigning existing ctx to thread " + ct.name
              newCtx = reclaim[0][0]
            else:
              print "Creating new ctx for thread " + ct.name
              newCtx = z3.Context();

            ctxPool[newCtx] = ct;
            print "ctxPool has ", len(ctxPool), "entries"
        finally:
            ctxPoolLock.release();

        _TL.ctx = newCtx

    return _TL.ctx

def getSolver():
    return z3.Solver(ctx=get_ctx())

def Int(n):
  return z3.Int(n, ctx=get_ctx());

def Bool(b):
  return z3.BoolVal(b, ctx=get_ctx());

def counterex(pred):
    s = getSolver()
    s.add(pred)
    res = s.check()
    checkShuttingDown();
    return None if z3.unsat == res else s.model()

def Or(*args):
    t = tuple(list(args) + [ get_ctx() ])
    return z3.Or(*t)

def And(*args):
    t = tuple(list(args) + [ get_ctx() ])
    return z3.And(*t)

def Not(pred):
    return z3.Not(pred, ctx=get_ctx())

def Implies(a,b):
    return z3.Implies(a,b, ctx=get_ctx())

def satisfiable(pred):
    s = getSolver()
    s.add(pred);
    res = s.check() == z3.sat
    checkShuttingDown();
    return res;

def unsatisfiable(pred):
    s = getSolver()
    s.add(pred);
    res = s.check() == z3.unsat
    checkShuttingDown();
    return res;

def model(pred):
    s = getSolver();
    s.add(pred);
    assert s.check() == z3.sat
    checkShuttingDown()
    return s.model();

def maybeModel(pred):
    s = getSolver();
    s.add(pred);
    res = s.check();
    checkShuttingDown()
    if res == z3.sat:
        return s.model();
    else:
        return None;

def simplify(pred, *args, **kwargs):
    # Simplify doesn't need get_ctx() as it gets its ctx from pred
    return z3.simplify(pred, *args, **kwargs)

def implies(inv1, inv2):
    return unsatisfiable(And(inv1, Not(inv2)))

def equivalent(inv1, inv2):
    return implies(inv1,inv2) and implies(inv2, inv1)

def tautology(inv):
    return unsatisfiable(Not(inv))

class AllIntTypeEnv:
    def __getitem__(s, i):  return Int

def expr_to_z3(expr, typeEnv):
    if isinstance(expr, ast.AstNumber):
        return expr.num
    elif isinstance(expr, ast.AstId):
        return typeEnv[expr.name](expr.name)
    elif isinstance(expr, ast.AstTrue):
        return True;
    elif isinstance(expr, ast.AstFalse):
        return False;
    elif isinstance(expr, ast.AstUnExpr):
        z3_inner = expr_to_z3(expr.expr, typeEnv)
        if expr.op == '-':
            return -z3_inner
        elif expr.op == '!':
            return Not(z3_inner)
        else:
            raise Exception("Unknown unary operator " + str(expr.op))
    elif isinstance(expr, ast.AstBinExpr):
        e1 = expr_to_z3(expr.lhs, typeEnv)
        e2 = expr_to_z3(expr.rhs, typeEnv)
        if expr.op == "<==>":
            return And(Implies(e1, e2), Implies(e2,e1))
        elif expr.op == "==>":
            return Implies(e1, e2)
        elif expr.op == "||":
            return Or(e1, e2)
        elif expr.op == "&&":
            return And(e1, e2)
        elif expr.op == "==":
            return e1 == e2
        elif expr.op == "!=":
            return e1 != e2
        elif expr.op == "<":
            return e1 < e2
        elif expr.op == ">":
            return e1 > e2
        elif expr.op == "<=":
            return e1 <= e2
        elif expr.op == ">=":
            return e1 >= e2
        elif expr.op == "+":
            return e1 + e2
        elif expr.op == "-":
            return e1 - e2
        elif expr.op == "*":
            return e1 * e2
        elif expr.op == "div":
            return e1 / e2
        elif expr.op == "mod":
            return e1 % e2
        else:
            raise Exception("Unknown binary operator " + str(expr.op))
    else:
        raise Exception("Unknown expression " + str(expr))

def stmt_to_z3(stmt, typeEnv):
    if (isinstance(stmt, ast.AstLabel)):
        stmt = stmt.stmt

    if (isinstance(stmt, ast.AstAssignment)):
        return (typeEnv[stmt.lhs](str(stmt.lhs)) == expr_to_z3(stmt.rhs, typeEnv))
    elif (isinstance(stmt, ast.AstAssert)):
        return (expr_to_z3(stmt.expr, typeEnv))
    elif (isinstance(stmt, ast.AstAssume)):
        return (expr_to_z3(stmt.expr, typeEnv))
    else:
        raise Exception("Can't convert " + str(stmt))

def isnum(s):
    try:
        x = int(s)
        return True
    except:
        return False

def ids(z3expr):
    if len(z3expr.children()) == 0:
        return [z3expr] if not isnum(str(z3expr)) else []
    else:
        tmp = { str(x): x for x in reduce(lambda x,y: x+y, map(ids, z3expr.children()), []) }
        return list(tmp.keys())

def z3_expr_to_boogie(expr):
    d = expr.decl();
    if (d.arity() == 0):
        #Literals and Identifiers
        if (isinstance(expr.sort(), z3.BoolSortRef)):
            if (z3.is_true(expr)):
                return ast.AstTrue()
            elif (z3.is_false(expr)):
                return ast.AstFalse()
            else:
                return ast.AstId(d.name())
        else:
            assert isinstance(expr.sort(), z3.ArithSortRef), "For now only handle bools and ints"
            if (z3.is_int_value(expr)):
                return ast.AstNumber(int(str(expr)))
            else:
                return ast.AstId(d.name())
    elif (d.arity() == 1):
        # Unary operators 
        arg = z3_expr_to_boogie(expr.children()[0])
        boogie_op = {
            '-': '-',
            'not': '!',
        }[d.name()]
        return ast.AstUnExpr(boogie_op, arg);
    elif (d.arity() == 2):
        # Binary operators
        boogie_op, assoc = {
            "+": ("+","left"),
            "-": ("-","left"),
            "*": ("*","left"),
            "div": ("div","left"),
            "mod": ("mod","none"),
            "=": ("==","none"),
            "!=":("!=","none"),
            "<": ("<","none"),
            ">": (">","none"),
            "<=": ("<=","none"),
            ">=": (">=","none"),
            "and": ("&&","left"),
            "or": ("||","left"),
        }[d.name()]

        c = expr.children();
        while (len(c) > 2):
            if (assoc == "none"):
                raise Exception("Error: Expression " + str(expr) + " has " +\
                    len(c) + " children: " + c + " but root operator " + \
                    d.name() + " is non-associative.")
            
            if (assoc == "left"):
                lhs = z3_expr_to_boogie(c[0]) if (not isinstance(c[0], ast.AstNode)) else c[0]
                rhs = z3_expr_to_boogie(c[1])
                c[0:2] = [ ast.AstBinExpr(lhs, boogie_op, rhs) ]
            else:
                raise Exception("NYI")

        lhs = z3_expr_to_boogie(c[0]) if (not isinstance(c[0], ast.AstNode)) else c[0]
        rhs = z3_expr_to_boogie(c[1])
        return ast.AstBinExpr(lhs, boogie_op, rhs)
    else:
        raise Exception("Can't translate z3 expression " + str(expr) +
            " to boogie.") 

if (__name__ == "__main__"):
    a = z3_expr_to_boogie(Int('a') + Int("b"))
    print a
    a = z3_expr_to_boogie(Int('a') * 2)
    print a
    a = z3_expr_to_boogie(Or((Bool('x'), Bool('y'))))
    print a
    a = z3_expr_to_boogie(And(Or(Bool('x'), True), ((Int('a') - 1) >= Int('b'))))
    print a
