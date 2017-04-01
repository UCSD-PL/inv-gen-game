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

def reduce_nodes(node, cb):
    return cb(node, [ reduce_nodes(x, cb) for x in node._children if isinstance(x, AstNode) ])
