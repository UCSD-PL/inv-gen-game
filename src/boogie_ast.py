from boogie_grammar import *
import boogie_grammar;
import pyparsing

class AstNode:
    def __init__(s, *args):
        s._children = args;
        real_init = s.__init__.__code__
        assert (real_init.co_argcount - 1 == len(args) and\
                real_init.co_argcount == len(real_init.co_varnames))

        # Attribute names are based on the formal argument names of the
        # most specific class constructor.
        s._dict = {}
        for (n,v) in zip(real_init.co_varnames[1:], args):
            s._dict[n] = v;

    def __getattr__(s, n):
        return s._dict[n];
            
    def __repr__(s):
        try:
            return s.__str__();
        except:
            return s.__class__.__name__ + "[" + str(s._children) + "]"

    # Structural equality
    def __eq__(s, other):
        return isinstance(other, AstNode) and \
               s.__class__ == other.__class__ and \
               s._children == other._children

class AstProgram(AstNode):
    def __init__(s, decls): AstNode.__init__(s, decls)
    @staticmethod
    def __parse__(toks):    return AstProgram(toks)
    def __str__(s): return "\n".join(map(str, s.decls))

class AstImplementation(AstNode):
    def __init__(s, name, signature, body): AstNode.__init__(s, name, signature, body)
    def __str__(s): return "implementation " + s.name + str(s.signature) + str(s.body)
    @staticmethod
    def __parse__(toks):
        name = str(toks[2])
        sig = toks[3]
        # For now ignore anything other than the argument list
        assert len(sig) == 3 and len(sig[0]) == 0 and len(sig[2]) == 0
        signature = None; #sig[1]
        body = toks[4][0]
        return AstImplementation(name, signature, body)

class AstBinding(AstNode):
    def __init__(s, names, typ):  AstNode.__init__(s, names, typ)
    def __str__(s): return ",".join(s.names) + " : " + str(s.typ)
    @staticmethod
    def __parse__(toks):    return AstBinding(map(str, toks[:-1]), toks[-1])

class AstLabel(AstNode):
    def __init__(s, label, stmt):  AstNode.__init__(s, label, stmt)
    def __str__(s): return s.label + " : " + str(s.stmt)
    @staticmethod
    def __parse__(toks):    return AstLabel(str(toks[0]), toks[1])

class AstAssignment(AstNode):
    def __init__(s, lhs, rhs):  AstNode.__init__(s, lhs, rhs)
    def __str__(s): return s.lhs + " : " + str(s.rhs)
    @staticmethod
    def __parse__(toks):    return AstAssignment(s, str(toks[0]), toks[1])

class AstIntType(AstNode):
    def __init__(s):  AstNode.__init__(s)
    def __str__(s): return "int"
    @staticmethod
    def __parse__(toks):    return AstIntType()

class AstBody(AstNode):
    def __init__(s, bindings, stmts):   AstNode.__init__(s, bindings, stmts)
    def __str__(s):
        return "{\n" + "\n".join(["var " + str(x) + ";" for x in s.bindings]) + "\n" +\
                "\n".join([str(x) for x in s.stmts]) + "\n}"
    @staticmethod
    def __parse__(toks):
        assert len(toks) == 2
        return AstBody([x[1] for x in toks[0]], toks[1])


class AstStmt(AstNode): pass
class AstOneExprStmt(AstStmt):
    def __init__(s, expr):  AstNode.__init__(s, expr)

class AstAssert(AstOneExprStmt):
    def __str__(s): return "assert (" + str(s.expr) + ");";
    @staticmethod
    def __parse__(toks):
        assert (len(toks) == 2)
        return AstAssert(toks[1])

class AstAssume(AstOneExprStmt):
    def __str__(s): return "assume (" + str(s.expr) + ");";
    @staticmethod
    def __parse__(toks):
        assert (len(toks) == 2)
        return AstAssume(toks[1])

# Returns is for now without argument
class AstReturn(AstStmt):
    def __init__(s):  AstNode.__init__(s)
    def __str__(s): return "return"
    @staticmethod
    def __parse__(toks):    return AstReturn()

class AstGoto(AstStmt):
    def __init__(s, labels):  AstNode.__init__(s, labels)
    def __str__(s): return "goto " + ",".join(s.labels) + ";"
    @staticmethod
    def __parse__(toks):
        assert toks[0] == "goto";
        return AstGoto(map(str, toks[1:]))

class AstUnExpr(AstNode):
    def __init__(s, op, expr):  AstNode.__init__(s, op, expr)
    def __str__(s): return s.op + str(s.expr)
    @staticmethod
    def __parse__(toks):    return AstUnExpr(str(toks[0]), toks[1])

class AstFalse(AstNode): 
    def __init__(s):  AstNode.__init__(s)
    def __str__(s): return "false"
    @staticmethod
    def __parse__(toks):    return AstFalse()

class AstTrue(AstNode):
    def __init__(s):  AstNode.__init__(s)
    def __str__(s): return "true"
    @staticmethod
    def __parse__(toks):    return AstTrue()

class AstNumber(AstNode): 
    def __init__(s, num):   AstNode.__init__(s,num)
    def __str__(s): return str(s.num)
    @staticmethod
    def __parse__(toks):
        assert(len(toks) == 1)
        return AstNumber(int(toks[0]))

class AstId(AstNode): 
    def __init__(s, name):  AstNode.__init__(s, name)
    def __str__(s): return s.name
    @staticmethod
    def __parse__(toks):
        assert(len(toks) == 1)
        return AstId(str(toks[0]))

class AstBinExpr(AstNode):
    def __init__(s, lhs, op, rhs):  AstNode.__init__(s, lhs, op, rhs)
    def __str__(s): return "(" + str(s.lhs) + s.op + str(s.rhs) + ")"
    @staticmethod
    def __parse__(toks):    return AstBinExpr(toks[0], str(toks[1]), toks[2])

def parseAst(s):
    def act_wrap(cl):
        def act(s, loc, toks):
            return [ cl.__parse__(toks) ]
        return act;

    def expr_wrap(cl):
        def act(s, loc, toks):
            if (len(toks) > 1):
                return [ cl.__parse__(toks) ]
            else:
                return toks
        return act

    def assign_act(s, loc, toks):
        assert (len(toks) == 2)
        return [AstAssignment(lhs, rhs) for (lhs, rhs) in zip(toks[0], toks[1])]

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
