from boogie_ast import *;
from boogie_z3 import *
from boogie_bb import *
from boogie_ssa import *
from collections import namedtuple
from z3 import *

def wp_stmt(stmt, pred, typeEnv):
    if (isinstance(stmt, AstLabel)):
        stmt = stmt.stmt

    if (isinstance(stmt, AstAssignment)):
        assignee = str(stmt.lhs)
        # Should already be SSA-ed
        assert(assignee not in expr_read(stmt.expr) and \
              (assignee not in map(str, ids(pred))))
        lhs = typeEnv[stmt.lhs](assignee)
        rhs = expr_to_z3(stmt.rhs, typeEnv)
        return substitute(pred, (lhs, rhs))
    elif (isinstance(stmt, AstAssert)):
        return And(pred, expr_to_z3(stmt.expr, typeEnv))
    elif (isinstance(stmt, AstAssume)):
        return Implies(expr_to_z3(stmt.expr, typeEnv), pred)
    else:
        raise Exception("Cannot handle Boogie Statement: " + str(stmt))

def wp_stmts(stmts, pred, typeEnv):
    for s in reversed(stmts):
        pred = wp_stmt(s, pred, typeEnv)
    return pred

def wp_bb(bb, pred, typeEnv):
    return wp_stmts(bb.stmts)

def sp_stmt(stmt, pred, typeEnv):
    if (isinstance(stmt, AstLabel)):
        stmt = stmt.stmt

    if (isinstance(stmt, AstAssignment)):
        assignee = str(stmt.lhs)
        # Should already be SSA-ed
        assert(assignee not in expr_read(stmt.rhs) and \
              (assignee not in map(str, ids(pred))))
        lhs = typeEnv[stmt.lhs](assignee)
        rhs = expr_to_z3(stmt.rhs, typeEnv)
        return And(lhs == rhs, pred)
    elif (isinstance(stmt, AstAssert)):
        return And(pred, expr_to_z3(stmt.expr, typeEnv))
    elif (isinstance(stmt, AstAssume)):
        return And(pred, expr_to_z3(stmt.expr, typeEnv))
    else:
        raise Exception("Cannot handle Boogie Statement: " + str(stmt))

def sp_stmts(stmts, pred, typeEnv):
    print stmts
    for s in stmts:
        pred = sp_stmt(s, pred, typeEnv)
    return pred

def sp_bb(bb, pred, typeEnv):
    return sp_stmts(bb.stmts, pred, typeEnv)

if __name__ == "__main__":
    bbs = get_bbs("desugared3.bpl")
    print sp_bb(bbs['anon0'], BoolVal(True), AllIntTypeEnv())
    print sp_stmts(path_to_ssa(bbpath_to_stmts(['anon0', 'anon3_LoopHead', 'anon3_LoopBody'], bbs)), BoolVal(True), AllIntTypeEnv())
