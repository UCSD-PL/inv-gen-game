from boogie_ast import *
from z3 import *

class AllIntTypeEnv:
    def __getitem__(s, i):  return Int

def expr_to_z3(expr, typeEnv):
    if isinstance(expr, AstNumber):
        return expr.num
    elif isinstance(expr, AstId):
        return typeEnv[expr.name](expr.name)
    elif isinstance(expr, AstTrue):
        return True;
    elif isinstance(expr, AstFalse):
        return False;
    elif isinstance(expr, AstUnExpr):
        z3_inner = expr_to_z3(expr.expr, typeEnv)
        if expr.op == '-':
            return -z3_inner
        elif expr.op == '!':
            return Not(z3_inner)
        else:
            raise Exception("Unknown unary operator " + str(expr.op))
    elif isinstance(expr, AstBinExpr):
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
    if (isinstance(stmt, AstLabel)):
        stmt = stmt.stmt

    if (isinstance(stmt, AstAssignment)):
        return (typeEnv[stmt.lhs](str(stmt.lhs)) == expr_to_z3(stmt.rhs, typeEnv))
    elif (isinstance(stmt, AstAssert)):
        return (expr_to_z3(stmt.expr, typeEnv))
    elif (isinstance(stmt, AstAssume)):
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
        if (isinstance(expr.sort(), BoolSortRef)):
            if (is_true(expr)):
                return AstTrue()
            elif (is_false(expr)):
                return AstFalse()
            else:
                return AstId(d.name())
        else:
            assert isinstance(expr.sort(), ArithSortRef), "For now only handle bools and ints"
            if (is_int_value(expr)):
                return AstNumber(int(str(expr)))
            else:
                return AstId(d.name())
    elif (d.arity() == 1):
        # Unary operators 
        arg = z3_expr_to_boogie(expr.children()[0])
        boogie_op = {
            '-': '-',
            'not': '!',
        }[d.name()]
        return AstUnExpr(boogie_op, arg);
    elif (d.arity() == 2):
        # Binary operators
        boogie_op, assoc = {
            "+": ("+","left"),
            "-": ("-","left"),
            "*": ("*","left"),
            "div": ("div","left"),
            "%": ("mod","none"),
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
                lhs = z3_expr_to_boogie(c[0]) if (not isinstance(c[0], AstNode)) else c[0]
                rhs = z3_expr_to_boogie(c[1])
                c[0:2] = [ AstBinExpr(lhs, boogie_op, rhs) ]
            else:
                raise Exception("NYI")

        lhs = z3_expr_to_boogie(c[0]) if (not isinstance(c[0], AstNode)) else c[0]
        rhs = z3_expr_to_boogie(c[1])
        return AstBinExpr(lhs, boogie_op, rhs)
    else:
        raise Exception("Can't translate z3 expression " + str(expr) +
            " to boogie.") 

def counterex(pred):
    s = Solver()
    s.add(pred)
    res = s.check()
    return None if unsat == res else s.model()

if (__name__ == "__main__"):
    a = z3_expr_to_boogie(Int('a') + Int("b"))
    print a
    a = z3_expr_to_boogie(Int('a') * 2)
    print a
    a = z3_expr_to_boogie(Or((Bool('x'), Bool('y'))))
    print a
    a = z3_expr_to_boogie(And(Or(Bool('x'), True), ((Int('a') - 1) >= Int('b'))))
    print a
