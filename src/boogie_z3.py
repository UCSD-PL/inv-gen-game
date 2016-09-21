import boogie_ast as ast
import z3;

def Int(n):
  return z3.Int(n);

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
            return z3.Not(z3_inner)
        else:
            raise Exception("Unknown unary operator " + str(expr.op))
    elif isinstance(expr, ast.AstBinExpr):
        e1 = expr_to_z3(expr.lhs, typeEnv)
        e2 = expr_to_z3(expr.rhs, typeEnv)
        if expr.op == "<==>":
            return z3.And(Implies(e1, e2), Implies(e2,e1))
        elif expr.op == "==>":
            return z3.Implies(e1, e2)
        elif expr.op == "||":
            return z3.Or(e1, e2)
        elif expr.op == "&&":
            return z3.And(e1, e2)
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

def counterex(pred):
    s = z3.Solver()
    s.add(pred)
    res = s.check()
    return None if z3.unsat == res else s.model()

def Or(*args):
    return z3.Or(*args)

def And(*args):
    return z3.And(*args)

def Not(pred):
    return z3.Not(pred)

def Implies(a,b):
    return z3.Implies(a,b)

def satisfiable(pred):
    s = z3.Solver();
    s.add(pred);
    return s.check() == z3.sat

def model(pred):
    s = z3.Solver();
    s.add(pred);
    assert s.check() == z3.sat
    return s.model();

def simplify(pred, *args, **kwargs):
    return z3.simplify(pred, *args, **kwargs)

def implies(inv1, inv2):
    s = z3.Solver();
    s.add(inv1)
    s.add(z3.Not(inv2))
    return z3.unsat == s.check();

def equivalent(inv1, inv2):
    s = z3.Solver();
    s.push();
    s.add(inv1)
    s.add(z3.Not(inv2))
    impl = s.check();
    s.pop();

    if (impl != z3.unsat):
      return False;

    s.push();
    s.add(z3.Not(inv1))
    s.add(inv2)
    impl = s.check();
    s.pop();

    if (impl != z3.unsat):
      return False;

    return True

def tautology(inv):
    s = z3.Solver();
    s.add(z3.Not(inv))
    return (z3.unsat == s.check())

if (__name__ == "__main__"):
    a = z3_expr_to_boogie(z3.Int('a') + z3.Int("b"))
    print a
    a = z3_expr_to_boogie(z3.Int('a') * 2)
    print a
    a = z3_expr_to_boogie(z3.Or((z3.Bool('x'), z3.Bool('y'))))
    print a
    a = z3_expr_to_boogie(z3.And(z3.Or(z3.Bool('x'), True), ((z3.Int('a') - 1) >= z3.Int('b'))))
    print a
