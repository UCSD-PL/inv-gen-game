from inv_grammar import *
from pyparsing import ParseResults, StringEnd

def _strip(arg):
    if isinstance(arg, ParseResults):
        return arg[0]
    else:
        return arg

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

    def __hash__(s):
        try:
          return hash((s.__class__,) + s._children)
        except:
          print "Can't hash: ", s
          raise

def replace(ast, m):
    if (not isinstance(ast, AstNode)):
        return ast;
    elif ast in m:
        return m[ast]
    else:
        return ast.__class__(*[replace(x,m) for x in ast._children])

class AstUnExpr(AstNode):
    def __init__(s, op, expr):  AstNode.__init__(s, op, expr)
    def __str__(s): return s.op + str(s.expr)
    @staticmethod
    def __parse__(toks):    return AstUnExpr(str(toks[0]), toks[1])

class AstIsPow2(AstNode):
    def __init__(s, expr):  AstNode.__init__(s, expr)
    def __str__(s): return "IsPow2(" + str(s.expr) + ")"
    @staticmethod
    def __parse__(toks):    return AstIsPow2(toks[0])

class AstIsOneOf(AstNode):
    def __init__(s, expr, options):  AstNode.__init__(s, expr, options)
    def __str__(s): return "IsOneOf(" + str(s.expr) + ",[" + ",".join(map(str, s.options)) + "])"
    @staticmethod
    def __parse__(toks):    return AstIsOneOf(toks[0], toks[1:])

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
    def __str__(s): return "(" + str(s.lhs) + " " + s.op + " " + str(s.rhs) + ")"
    @staticmethod
    def __parse__(toks):    return AstBinExpr(_strip(toks[0]), str(toks[1]), _strip(toks[2]))

def expr_read(ast):
    if isinstance(ast, AstId):
        return set([ast.name])
    elif isinstance(ast, AstNumber):
        return set()
    elif isinstance(ast, AstUnExpr):
        return expr_read(ast.expr)
    elif isinstance(ast, AstBinExpr):
        return expr_read(ast.lhs).union(expr_read(ast.rhs))
    elif isinstance(ast, AstTrue) or isinstance(ast, AstFalse):
        return set()
    else:
        raise Exception("Unknown expression type " + str(ast))

def stmt_read(ast):
    if isinstance(ast, AstLabel):
        ast = ast.stmt

    if isinstance(ast, AstAssume) or isinstance(ast, AstAssert):
        return expr_read(ast.expr)
    elif isinstance(ast, AstAssignment):
        return expr_read(ast.rhs)
    elif isinstance(ast, AstHavoc):
        return set()
    else:
        raise Exception("Unknown statement: " + str(ast))

def stmt_changed(ast):
    if isinstance(ast, AstLabel):
        ast = ast.stmt

    if isinstance(ast, AstAssignment):
        return expr_read(ast.lhs)
    elif isinstance(ast, AstHavoc):
        return set(ast.ids)
    elif isinstance(ast, AstAssume) or isinstance(ast, AstAssert):
        return set([])
    else:
        raise Exception("Unknown statement: " + str(ast))

def ast_group_bin(exprs, op, default):
    return reduce(lambda x,y:   AstBinExpr(x, op, y), exprs, default)

def ast_and(exprs): return ast_group_bin(exprs, "&&", AstTrue())
def ast_or(exprs): return ast_group_bin(exprs, "||", AstFalse()) 

def parseExprAst(s):
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

    def act_binary_exprs(s, loc, toks):
        if (len(toks) == 1):
            return toks
        else:
            ltoks = list(toks)
            while len(ltoks) > 2:
                ltoks[-3:] = [AstBinExpr.__parse__(ltoks[-3:])]

            return ltoks

    # A minimium set of rules neccessary for the "passive" desugared
    # boogie programs generated during verification  
    # Expressions 
    E7.setParseAction(expr_wrap(AstUnExpr))
    E65.setParseAction(expr_wrap(AstBinExpr))
    E6.setParseAction(expr_wrap(AstBinExpr))
    E5.setParseAction(expr_wrap(AstBinExpr))
    E3.setParseAction(expr_wrap(AstBinExpr))
    EAnds.setParseAction(act_binary_exprs)
    EOrs.setParseAction(act_binary_exprs)
    E2.setParseAction(expr_wrap(AstBinExpr))
    E1.setParseAction(expr_wrap(AstBinExpr))
    E0.setParseAction(expr_wrap(AstBinExpr))
    Number.setParseAction(act_wrap(AstNumber))
    Id.setParseAction(act_wrap(AstId))
    TRUE.setParseAction(act_wrap(AstTrue))
    FALSE.setParseAction(act_wrap(AstFalse))
    IsPow2.setParseAction(act_wrap(AstIsPow2))
    IsOneOf.setParseAction(act_wrap(AstIsOneOf))
    try:
      return (Inv + StringEnd()).parseString(s)
    except:
      print "Failed parsing: ", s
      raise
