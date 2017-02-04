from inv_grammar import *

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
    def __init__(s, op, expr):  AstNode.__init__(s, str(op), expr)
    def __str__(s): return s.op + str(s.expr)

class AstIsPow2(AstNode):
    def __init__(s, expr):  AstNode.__init__(s, expr)
    def __str__(s): return "IsPow2(" + str(s.expr) + ")"

class AstIsOneOf(AstNode):
    def __init__(s, expr, options):  AstNode.__init__(s, expr, options)
    def __str__(s): return "IsOneOf(" + str(s.expr) + ",[" + ",".join(map(str, s.options)) + "])"

class AstIsBoolean(AstNode):
    def __init__(s, expr):  AstNode.__init__(s, expr)
    def __str__(s): return "IsBoolean(" + str(s.expr) + ")"

class AstInRange(AstNode):
    def __init__(s, lower, expr, upper):  AstNode.__init__(s, lower, expr, upper)
    def __str__(s): return str(s.expr) + " in [" + str(s.lower) +  "," + str(s.upper) +  "]"

class AstFalse(AstNode): 
    def __init__(s):  AstNode.__init__(s)
    def __str__(s): return "false"

class AstTrue(AstNode):
    def __init__(s):  AstNode.__init__(s)
    def __str__(s): return "true"

class AstNumber(AstNode): 
    def __init__(s, num):   AstNode.__init__(s,int(num))
    def __str__(s): return str(s.num)

class AstId(AstNode): 
    def __init__(s, name):  AstNode.__init__(s, str(name))
    def __str__(s): return s.name

class AstBinExpr(AstNode):
    def __init__(s, lhs, op, rhs):  AstNode.__init__(s, lhs, str(op), rhs)
    def __str__(s): return "(" + str(s.lhs) + " " + s.op + " " + str(s.rhs) + ")"

class AstBuilder(DaikonInvParser):
  def onAtom(s, prod, st, loc, toks):
    return [ s.atomM[prod](*toks) ]

  def onUnaryOp(s, prod, st, loc, toks):
    if (prod == s.IsPow2):
      return [ AstIsPow2(toks[0]) ]
    elif (prod == s.IsBoolean):
      return [ AstIsBoolean(toks[0]) ]
    else:
      return [ AstUnExpr(*toks) ]

  def onLABinOp(s, prod, st, loc, toks):
    if (len(toks) == 3):
      return [ AstBinExpr(*toks) ]
    else:
      assert(len(toks) > 3);
      base = AstBinExpr(*toks[:3])
      rest = [ [toks[3+2*k], toks[3+2*k+1]] for k in xrange((len(toks)-3)/2) ]
      return [ reduce(lambda acc,el:  AstBinExpr(acc, el[0], el[1]), rest, base) ]

  def onRABinOp(s, prod, st, loc, toks):
    if (len(toks) == 3):
      return [ AstBinExpr(*toks) ]
    else:
      assert(len(toks) > 3);
      toks = reversed(toks)
      base = AstBinExpr(*toks[:3])
      rest = [ [toks[3+2*k], toks[3+2*k+1]] for k in xrange((len(toks)-3)/2) ]
      return [ reduce(lambda acc,el:  AstBinExpr(acc, el[0], el[1]), toks[3:], base) ]

  def onNABinOp(s, prod, st, loc, toks):
    if (prod == s.IsInRange):
      return [ AstInRange(toks[0], toks[1], toks[2]) ]
    elif (prod == s.IsOneOf):
      return [ AstIsOneOf(toks[0], toks[1]) ]
    else:
      assert (len(toks) == 3);
      return [ AstBinExpr(*toks) ]

  def __init__(s):
    DaikonInvParser.__init__(s);
    s.atomM = {
      s.TRUE : AstTrue,
      s.FALSE : AstFalse,
      s.Id : AstId,
      s.Number : AstNumber
    }

astBuilder = AstBuilder();

def parseExprAst(s):
  try:
    return astBuilder.parse(s);
  except:
    print "Failed parsing";
    raise;
