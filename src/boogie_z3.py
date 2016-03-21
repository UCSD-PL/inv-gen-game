from boogie_ast import *
from z3 import *

class AllIntTypeEnv:
    def __getitem__(s, i):  return Int

def expr_to_z3(expr, typeEnv):
    if isinstance(expr, AstNumber):
        return Int(expr._num)
    elif isinstance(expr, AstId):
        return typeEnv[expr._name](expr._name)
    elif isinstance(expr, AstTrue):
        return True;
    elif isinstance(expr, AstTrue):
        return False;
    elif isinstance(expr, AstUnExpr):
        z3_inner = expr_to_z3(expr._expr, typeEnv)
        if expr._op == '-':
            return -z3_inner
        elif expr._op == '!':
            return Not(z3_inner)
        else:
            raise Exception("Unknown unary operator " + str(expr._op))
    elif isinstance(expr, AstBinExpr):
        e1 = expr_to_z3(expr._lhs, typeEnv)
        e2 = expr_to_z3(expr._rhs, typeEnv)
        if expr._op == "<==>":
            return And(Implies(e1, e2), Implies(e2,e1))
        elif expr._op == "==>":
            return Implies(e1, e2)
        elif expr._op == "||":
            return Or(e1, e2)
        elif expr._op == "&&":
            return And(e1, e2)
        elif expr._op == "==":
            return e1 == e2
        elif expr._op == "!=":
            return e1 != e2
        elif expr._op == "<":
            return e1 < e2
        elif expr._op == ">":
            return e1 > e2
        elif expr._op == "<=":
            return e1 <= e2
        elif expr._op == ">=":
            return e1 >= e2
        elif expr._op == "+":
            return e1 + e2
        elif expr._op == "-":
            return e1 - e2
        elif expr._op == "*":
            return e1 * e2
        elif expr._op == "/":
            return e1 / e2
        elif expr._op == "%":
            return e1 % e2
        else:
            raise Exception("Unknown binary operator " + str(expr._op))
    else:
        raise Exception("Unknown expression " + str(expr))

def stmt_to_z3(stmt, typeEnv):
    if (isinstance(stmt, AstLabel)):
        stmt = stmt._stmt

    if (isinstance(stmt, AstAssignment)):
        return (typeEnv[stmt._var](str(stmt._var)) == expr_to_z3(stmt._expr, typeEnv))
    elif (isinstance(stmt, AstAssert)):
        return (expr_to_z3(stmt._expr, typeEnv))
    elif (isinstance(stmt, AstAssume)):
        # TODO: WTF?
        return (expr_to_z3(stmt._expr, typeEnv))
    else:
        raise Exception("Can't convert " + str(stmt))
