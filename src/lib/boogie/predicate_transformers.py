from lib.boogie.ast import AstLabel, AstAssignment, AstAssert, AstAssume, \
        expr_read, AstStmt
from lib.boogie.z3_embed import expr_to_z3, And, Implies, ids, TypeEnv_T, _force_expr
from collections import namedtuple
import z3
from typing import Iterable, Reversible

def wp_stmt(stmt: AstStmt, pred: z3.ExprRef, typeEnv: TypeEnv_T) -> z3.ExprRef:
    if (isinstance(stmt, AstLabel)):
        stmt = stmt.stmt

    if (isinstance(stmt, AstAssignment)):
        assignee = str(stmt.lhs)
        # Should already be SSA-ed
        assert(assignee not in expr_read(stmt.rhs))
        lhs = typeEnv[stmt.lhs](assignee)
        rhs = expr_to_z3(stmt.rhs, typeEnv)
        return _force_expr(z3.substitute(pred, (lhs, rhs)))
    elif (isinstance(stmt, AstAssert)):
        return And(pred, expr_to_z3(stmt.expr, typeEnv))
    elif (isinstance(stmt, AstAssume)):
        return Implies(expr_to_z3(stmt.expr, typeEnv), pred)
    else:
        raise Exception("Cannot handle Boogie Statement: " + str(stmt))

def wp_stmts(stmts: Reversible[AstStmt], pred: z3.ExprRef, typeEnv: TypeEnv_T) -> z3.ExprRef:
    for s in reversed(stmts):
        #old_pred = pred
        pred = wp_stmt(s, pred, typeEnv)
        #print "WP of ", old_pred, " w.r.t. ", s, " is ", pred
    return pred

def sp_stmt(stmt: AstStmt, pred: z3.ExprRef, typeEnv: TypeEnv_T) -> z3.ExprRef:
    if (isinstance(stmt, AstLabel)):
        stmt = stmt.stmt

    if (isinstance(stmt, AstAssignment)):
        assignee = str(stmt.lhs)
        # Should already be SSA-ed
        assert(assignee not in expr_read(stmt.rhs) and \
              (assignee not in list(map(str, ids(pred)))))
        lhs = expr_to_z3(stmt.lhs, typeEnv)
        rhs = expr_to_z3(stmt.rhs, typeEnv)
        return And(lhs == rhs, pred)
    elif (isinstance(stmt, AstAssert)):
        return And(pred, expr_to_z3(stmt.expr, typeEnv))
    elif (isinstance(stmt, AstAssume)):
        return And(pred, expr_to_z3(stmt.expr, typeEnv))
    else:
        raise Exception("Cannot handle Boogie Statement: " + str(stmt))

def sp_stmts(stmts: Iterable[AstStmt], pred: z3.ExprRef, typeEnv: TypeEnv_T) -> z3.ExprRef:
    for s in stmts:
        pred = sp_stmt(s, pred, typeEnv)
    return pred
