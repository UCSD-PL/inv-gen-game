from boogie_grammar import *
import boogie_grammar;
import pyparsing

class AstNode:
    def __init__(s, st, loc, children):
        s._children = children;
    def __repr__(s):
        try:
            return s.__str__();
        except:
            return s.__class__.__name__ + "[" + str(s._children) + "]"

class AstProgram(AstNode): pass
class AstImplementation(AstNode):    
    def __init__(s, st, loc, children):
        # Don't handle attributes yet
        assert len(children[1]) == 0
        s._name = children[2]
        sig = children[3]
        # For now ignore anything other than the argument list
        assert len(sig) == 3 and len(sig[0]) == 0 and len(sig[2]) == 0
        s._signature = sig[1]
        s._body = children[4][0]
        AstNode.__init__(s, st, loc, [])
    def __str__(s): return "implementation " + s._name + str(s._signature) + str(s._body)

class AstBinding(AstNode):
    def __init__(s, st, loc, children):
        s._names = children[:-1]
        s._type = children[-1]
        AstNode.__init__(s,st,loc,[])

    def __str__(s):
        return ",".join([str(x) for x in s._names]) + " : " + str(s._type)

class AstLabel(AstNode):
    def __init__(s, st, loc, children):
        s._label = children[0]
        s._stmt  = children[1]
        AstNode.__init__(s,st,loc,[])

    def __str__(s):
        return str(s._label) + " : " + str(s._stmt)

class AstAssignment(AstNode):
    def __init__(s, st, loc, children):
        assert (len(children) == 2)
        s._var = children[0]
        s._expr = children[1]
        AstNode.__init__(s,st,loc,[])

    def __str__(s):
        return s._var + " := " + str(s._expr)

class AstIntType(AstNode):  pass;
class AstBody(AstNode):
    def __init__(s, st, loc, children):
        assert len(children) == 2
        s._bindings = [x[1] for x in children[0]]
        s._stmts = children[1]
        AstNode.__init__(s,st,loc,[])

    def __str__(s):
        return "\n".join(["var " + str(x) + ";" for x in s._bindings]) + \
                "\n".join([str(x) for x in s._stmts]) 

class AstStmt(AstNode): pass
class AstOneExprStmt(AstStmt):
    def __init__(s, st, loc, children):
        assert (len(children) == 2)
        s._expr = children[1]
        AstNode.__init__(s,st,loc,[])

class AstReturn(AstStmt):   pass
class AstGoto(AstStmt):
    def __init__(s, st, loc, children):
        assert children[0] == "goto";
        s._labels = children[1:]
        AstNode.__init__(s,st,loc,[])

class AstAssert(AstOneExprStmt):
    def __str__(s): return "assert (" + str(s._expr) + ");";
class AstAssume(AstOneExprStmt):
    def __str__(s): return "assume (" + str(s._expr) + ");";
class AstUnExpr(AstNode):
    def __init__(s, st, loc, children):
        s._op = children[0]
        s._expr = children[1]
        AstNode.__init__(s,st,loc,[])
    def __str__(s): return "(" + str(s._op) + str(s._expr) + ")"
class AstFalse(AstNode):   pass
class AstTrue(AstNode):   pass
class AstNumber(AstNode): 
    def __init__(s, st, loc, children):
        assert(len(children) == 1)
        s._num = int(children[0])
        AstNode.__init__(s,st,loc,[])
    def __str__(s): return str(s._num)
class AstId(AstNode): 
    def __init__(s, st, loc, children):
        assert(len(children) == 1)
        s._name = children[0]
        AstNode.__init__(s,st,loc,[])
    def __str__(s): return s._name
class AstBinExpr(AstNode):
    def __init__(s, st, loc, children):
        s._lhs = children[0]
        s._rhs = children[2]
        s._op = children[1]
        AstNode.__init__(s,st,loc,[])
    def __str__(s): return "(" + str(s._lhs) + s._op + str(s._rhs) + ")"

def parseAst(s):
    def act_wrap(cl):
        def act(s, loc, toks):
            return [ cl(s, loc, toks) ]
        return act;

    def expr_wrap(cl):
        def act(s, loc, toks):
            if (len(toks) > 1):
                return [ cl(s, loc, toks) ]
            else:
                return toks
        return act

    def assign_act(s, loc, toks):
        assert (len(toks) == 2)
        return [AstAssignment(s, loc, t) for t in zip(toks[0], toks[1])]

    # A minimium set of rules neccessary for the "passive" desugared
    # boogie programs generated during verification  
    Program.setParseAction(act_wrap(AstProgram))
    ImplementationDecl.setParseAction(act_wrap(AstImplementation))
    IdsType.setParseAction(act_wrap(AstBinding))
    INT.setParseAction(act_wrap(AstIntType))
    Body.setParseAction(act_wrap(AstBody))
    LabeledStatement.setParseAction(act_wrap(AstLabel))
    AssertStmt.setParseAction(act_wrap(AstAssert))
    AssumeStmt.setParseAction(act_wrap(AstAssume))
    ReturnStmt.setParseAction(act_wrap(AstReturn))
    GotoStmt.setParseAction(act_wrap(AstGoto))
    AssignmentStmt.setParseAction(assign_act);
    # Expressions 
    E7.setParseAction(expr_wrap(AstUnExpr))
    E6.setParseAction(expr_wrap(AstBinExpr))
    E5.setParseAction(expr_wrap(AstBinExpr))
    E3.setParseAction(expr_wrap(AstBinExpr))
    E2.setParseAction(expr_wrap(AstBinExpr))
    E1.setParseAction(expr_wrap(AstBinExpr))
    E0.setParseAction(expr_wrap(AstBinExpr))
    Number.setParseAction(act_wrap(AstNumber))
    Id.setParseAction(act_wrap(AstId))
    TRUE.setParseAction(act_wrap(AstTrue))
    FALSE.setParseAction(act_wrap(AstFalse))
    return Program.parseString(s)

if __name__ == "__main__":
    a = parseAst(open("desugared.bpl").read())
    print "Decls: ", a[0]
    impl = a[0]._children[0]
    print "Impl: ", impl._name, impl._signature, impl._children
    print "Impl.Signature: ", impl._signature
    print "Body:", impl._body
    print "Expr:", Expr.parseString("1+2")
    print "Expr:", Expr.parseString("1*2")
    print "Expr:", Expr.parseString("(1+2)*3>0 && 4<2*3 ==> false ==> false ==> false")
