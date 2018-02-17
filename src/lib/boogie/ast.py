#pylint: disable=no-self-argument,multiple-statements
from lib.boogie.grammar import BoogieParser
from pyparsing import ParseResults, Token, ParserElement
from ..common.ast import AstNode, replace, reduce_nodes, ReplMap_T
from functools import reduce
from typing import List, Iterable, Set, TYPE_CHECKING, Any, Union

# Types
class AstType(AstNode): pass
class AstIntType(AstType):
    def __init__(s) -> None:  AstNode.__init__(s)
    def __str__(s) -> str: return "int"

class AstBoolType(AstType):
    def __init__(s) -> None:  AstNode.__init__(s)
    def __str__(s) -> str: return "bool"

class AstMapType(AstType):
    def __init__(s, domainT: AstType, rangeT: AstType) -> None:  AstNode.__init__(s, domainT, rangeT)
    def __str__(s) -> str: return "[{}]{}".format(str(s.domainT, s.rangeT))

# Expressions
class AstExpr(AstNode): pass
class AstFalse(AstExpr):
    def __init__(s) -> None:  AstExpr.__init__(s)
    def __str__(s) -> str: return "false"

class AstTrue(AstExpr):
    def __init__(s) -> None:  AstExpr.__init__(s)
    def __str__(s) -> str: return "true"

class AstNumber(AstExpr):
    def __init__(s, num: int) -> None:   AstExpr.__init__(s,num)
    def __str__(s) -> str: return str(s.num)

class AstId(AstExpr):
    def __init__(s, name: str) -> None:  AstExpr.__init__(s, name)
    def __str__(s) -> str: return str(s.name)

class AstMapIndex(AstExpr):
    def __init__(s, map: AstExpr, index: AstExpr) -> None:  AstExpr.__init__(s, map, index)
    def __str__(s) -> str: return "{}[{}]".format(str(s.map), str(s.index))

class AstUnExpr(AstExpr):
    def __init__(s, op: str, expr: AstExpr) -> None:  AstExpr.__init__(s, op, expr)
    def __str__(s) -> str: return s.op + str(s.expr)

class AstBinExpr(AstExpr):
    def __init__(s, lhs: AstExpr, op: str, rhs: AstExpr) -> None:  AstExpr.__init__(s, lhs, op, rhs)
    def __str__(s) -> str:
        return "(" + str(s.lhs) + " " + str(s.op) + " " + str(s.rhs) + ")"

class AstBinding(AstNode):
    def __init__(s, names: Iterable[str], typ: AstType) -> None:  AstNode.__init__(s, tuple(names), typ)
    def __str__(s) -> str: return ",".join(map(str, s.names)) + " : " + str(s.typ)


class AstForallExpr(AstExpr):
    def __init__(s, bindings: List[AstBinding], expr: AstExpr) -> None:  AstExpr.__init__(s, tuple(bindings), expr)
    def __str__(s) -> str:
        return "(forall " + ",".join([str(x) for x in s.bindings]) + " :: " + \
               str(s.expr) + ")"

class AstFuncExpr(AstExpr):
    def __init__(s, funcName: AstId, *ops: AstExpr) -> None:  AstExpr.__init__(s, funcName, *ops)
    def __str__(s) -> str:
        return str(s.funcName) + "(" + ",".join(map(str, s.ops)) +  ")"

def _force_expr(s: AstNode) -> AstExpr:
    assert isinstance(s, AstExpr)
    return s

# Statements
class AstStmt(AstNode): pass

class AstLabel(AstNode):
    def __init__(s, label: str, stmt: AstStmt) -> None:  AstNode.__init__(s, label, stmt)
    def __str__(s) -> str: return str(s.label) + " : " + str(s.stmt)

AstStmt_T = Union[AstStmt, AstLabel]
def _force_stmt(s: AstNode) -> AstStmt:
    assert isinstance(s, AstStmt)
    return s

class AstOneExprStmt(AstStmt):
    def __init__(s, expr: AstExpr) -> None:  AstStmt.__init__(s, expr)

class AstAssert(AstOneExprStmt):
    def __str__(s) -> str: return "assert (" + str(s.expr) + ");";

class AstAssume(AstOneExprStmt):
    def __str__(s) -> str: return "assume (" + str(s.expr) + ");";

class AstAssignment(AstStmt):
    def __init__(s, lhs: AstId, rhs: AstExpr) -> None:  AstNode.__init__(s, lhs, rhs)
    def __str__(s) -> str: return str(s.lhs) + " := " + str(s.rhs) + ";"

class AstHavoc(AstStmt):
    #TODO: Should be more precise here: Iterable[AstId]
    def __init__(s, ids: Iterable[AstNode]) -> None:  AstStmt.__init__(s, ids)
    def __str__(s) -> str: return "havoc " + ",".join(map(str, s.ids)) + ";"

# Returns is for now without argument
class AstReturn(AstStmt):
    def __init__(s) -> None:  AstStmt.__init__(s)
    def __str__(s) -> str: return "return ;"

class AstGoto(AstStmt):
    #TODO: Should be more precise here: Iterable[AstId]
    def __init__(s, labels: Iterable[AstNode]) -> None:  AstStmt.__init__(s, labels)
    def __str__(s) -> str: return "goto " + ",".join(map(str, s.labels)) + ";"

# Functions
class AstBody(AstNode):
    def __init__(s, bindings: Iterable[AstBinding], stmts: Iterable[AstStmt_T]) -> None:   AstNode.__init__(s, bindings, stmts)
    def __str__(s) -> str:
        return "{\n" + "\n".join(["var " + str(x) + ";" for x in s.bindings]) +\
                "\n" +\
                "\n".join([str(x) for x in s.stmts]) + \
                "\n}"

class AstImplementation(AstNode):
    def __init__(s, name: str, signature: Any, body: List[AstNode]) -> None:
        AstNode.__init__(s, name, signature, body)
    def __str__(s) -> str:
        return "implementation " + s.name + " " + str(s.signature) + str(s.body)

AstDecl_T = AstImplementation

# Programs
class AstProgram(AstNode):
    def __init__(s, decls: Iterable[AstDecl_T]) -> None: AstNode.__init__(s, decls)
    def __str__(s) -> str: return "\n".join(map(str, s.decls))


if TYPE_CHECKING:
  PE=ParserElement[AstNode]
  PR=ParseResults[AstNode]
else:
  PE=None
  PR=None

def _mkBinExp(lhs: Any, op: Any, rhs: Any) -> AstBinExpr:
  assert isinstance(lhs, AstExpr) and isinstance(rhs, AstExpr) and \
         isinstance(op, str)
  return AstBinExpr(lhs, op, rhs)


class AstBuilder(BoogieParser[AstNode]):
  def onAtom(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert len(toks) == 1
    if prod == s.TRUE:
      return [ AstTrue() ]
    elif prod == s.FALSE:
      return [ AstFalse() ]
    elif prod == s.Number:
      return [ AstNumber(int(toks[0])) ]
    else:
      return [ AstId(str(toks[0])) ]

  def onUnaryOp(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    op = str(toks[0])
    expr = toks[1]
    assert isinstance(expr, AstExpr)
    return [ AstUnExpr(op, expr) ]

  def onLABinOp(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    if (len(toks) == 3):
      return [ _mkBinExp(*toks) ]
    else:
      assert(len(toks) > 3);
      base = _mkBinExp(*toks[:3])
      rest = [ [toks[3+2*k], toks[3+2*k+1]] for k in range(int((len(toks)-3)/2)) ]
      return [ reduce(lambda acc,el:  _mkBinExp(acc, el[0], el[1]), \
                      rest, base)
             ]

  def onRABinOp(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    raise Exception("NYI")

  def onNABinOp(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert (len(toks) == 3);
    return [ _mkBinExp(*toks) ]

  def onBinding(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert isinstance(toks[-1], AstType)
    return [ AstBinding(list(map(str, toks[:-1])), toks[-1]) ]

  # Statements
  def onAssert(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert (len(toks) == 1 and isinstance(toks[0], AstExpr))
    return [ AstAssert(toks[0]) ]
  def onAssume(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert (len(toks) == 1 and isinstance(toks[0], AstExpr))
    return [ AstAssume(toks[0]) ]
  def onReturn(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert (len(toks) == 0)
    return [ AstReturn() ]
  def onGoto(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert(len(toks) > 0)
    return [ AstGoto(toks) ]
  def onAssignment(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert (len(toks) == 2)
    assert (len(toks[0]) == 1)
    assert (len(toks[1]) == 1)
    return [ AstAssignment(toks[0][0], toks[1][0]) ]
  def onHavoc(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert (len(toks) > 0)
    return [ AstHavoc(toks) ]
  def onProgram(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    decls = [] # type: List[AstDecl_T] 
    for d in toks:
        assert isinstance(d, AstDecl_T)
        decls.append(d)
    return [ AstProgram(decls) ]
  def onLocalVarDecl(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert len(toks) == 1 and isinstance(toks[0], AstBinding)
    return toks
  def onTypeAtom(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    # Currently only handle ints
    assert len(toks) == 1
    if toks[0] == 'int':
      return [ AstIntType() ];
    elif toks[0] == 'bool':
      return [ AstIntType() ];
    else:
      raise Exception("NYI type: {}".format(toks[0]))
  def onMapType(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    # Currently only handle ints
    assert len(toks) == 2
    domainT = toks[0]
    rangeT = toks[1]
    assert isinstance(domainT, AstType) and isinstance(rangeT, AstType)
    return [ AstMapType(domainT, rangeT) ]
  def onType(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert len(toks) == 1 and isinstance(toks[0], AstType)
    return [ toks[0] ];
  def onBody(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert len(toks) == 2;
    return [ AstBody(toks[0], toks[1]) ]
  def onImplementationDecl(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    attrs = toks[0]
    assert(len(attrs) == 0)
    name = str(toks[1])
    signature = toks[2]
    assert len(signature) == 3
    type_args, parameters, returns = signature
    # For now ignore anything other than the argument list
    assert len(type_args) == 0, "NYI: Imeplementation type args: {}".format(type_args)
    body = toks[3][0]
    return [ AstImplementation(name, (parameters, returns), body) ]
  def onLabeledStatement(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    label = str(toks[0])
    stmt = toks[1]
    assert isinstance(stmt, AstStmt) or isinstance(stmt, AstLabel), "Unexpected {}".format(stmt)
    # TODO: Mypy can't figure out that stmt is of the right type due to above assert
    return [AstLabel(label, stmt)]  #type: ignore
  def onMapIndex(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    mapE = toks[0]
    indexE = toks[1]
    assert isinstance(mapE, AstExpr) and isinstance(indexE, AstExpr)
    return [AstMapIndex(mapE, indexE)]
  def onQuantified(s, prod: PE, st: str, loc: int, toks: PR) -> Iterable[AstNode]:
    assert len(toks) == 3, "NYI TypeArgs on quantified expressions"
    quantifier = str(toks[0])
    bindings = []  # type: List[AstBinding]
    for node in toks[1]:
        assert isinstance(node, AstBinding)
        bindings.append(node)
    expr = toks[2]
    assert quantifier == "forall", "Existential quantification NYI"
    assert isinstance(expr, AstExpr)
    return [AstForallExpr(bindings, expr)]

astBuilder = AstBuilder();

def parseExprAst(s: str) -> AstExpr:
  try:
    r = astBuilder.parseExpr(s);
    assert isinstance(r, AstExpr)
    return r
  except:
    print("Failed parsing");
    raise;

def parseAst(s: str) -> AstProgram:
  try:
    r = astBuilder.parseProgram(s);
    assert isinstance(r, AstProgram)
    return r
  except:
    print("Failed parsing");
    raise;

def expr_read(ast: AstNode) -> Set[str]:
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
    elif isinstance(ast, AstForallExpr):
        quantified_ids = set(name for binding in ast.bindings for name in binding.names) # type: Set[str]
        return expr_read(ast.expr).difference(quantified_ids)
    elif isinstance(ast, AstMapIndex):
        return expr_read(ast.map).union(expr_read(ast.index))
    else:
        raise Exception("Unknown expression type " + str(ast))

def stmt_read(ast: AstStmt_T) -> Set[str]:
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

def stmt_changed(ast: AstStmt_T) -> Set[str]:
    if isinstance(ast, AstLabel):
        ast = ast.stmt

    if isinstance(ast, AstAssignment):
        return expr_read(ast.lhs)
    elif isinstance(ast, AstHavoc):
        return set([x.name for x in ast.ids])
    elif isinstance(ast, AstAssume) or isinstance(ast, AstAssert):
        return set([])
    else:
        raise Exception("Unknown statement: " + str(ast))

def ast_group_bin(exprs: List[AstExpr], op: str, default: AstExpr) -> AstExpr:
    if (len(exprs) == 0):
      return default
    if (len(exprs) == 1):
      return exprs[0]

    return reduce(lambda x,y:   AstBinExpr(x, op, y), exprs[1:], exprs[0])

def ast_and(exprs: Iterable[AstExpr]) -> AstExpr: return ast_group_bin(list(exprs), "&&", AstTrue())
def ast_or(exprs: Iterable[AstExpr]) -> AstExpr: return ast_group_bin(list(exprs), "||", AstFalse())

def normalize(ast: AstNode) -> AstNode:
  # There are 2 ways to encode "-1" - as an AstUnExpr or an AstNumber. We pick
  # the AstUnExpr to be the canonical one for compatibility with the grammar
  # TODO: What happens when we parse -0?
  if (isinstance(ast, AstNumber) and ast.num < 0):
    return AstUnExpr("-", AstNumber(abs(ast.num)))
  # There are 2 ways to encode implication - as a ==> b or (!a) || b. The later
  # usually comes from the frontend, since JS lacks an explicit ==> operator.
  # We pick a ==> b to be canonical

  if (isinstance(ast, AstBinExpr) and ast.op == "||" and \
      isinstance(ast.lhs, AstUnExpr) and ast.lhs.op == "!"):
    return AstBinExpr(ast.lhs.expr, "==>", ast.rhs)

  if (isinstance(ast, AstNode)):
    return ast.__class__(*tuple(map(normalize, ast._children)))
  else:
    return ast;

def ast_constants(n: AstNode) -> Set[int]:
  def cb(node: AstNode, children: Iterable[Set[int]]) -> Set[int]:
    if isinstance(node, AstNumber):
      return set([node.num])
    else:
      return reduce(lambda x,y: x.union(y), children, set())
  return reduce_nodes(n, cb);


def ast_boolean_exprs(n: AstNode) -> Set[AstExpr]:
  def cb(node: AstNode, children: Iterable[Set[AstExpr]]) -> Set[AstExpr]:
    relOps = [ "<", ">", "<=", ">=", "==",  "!=" ]
    boolOps = [ "||", "&&", "==>", "<==>" ]
    isBoolean = (isinstance(node, AstUnExpr) and node.op == "!") or \
                (isinstance(node, AstBinExpr) and node.op in (relOps + boolOps))
    base = set([]) # type: Set[AstExpr]
    boolSubexp = reduce(lambda x,y: x.union(y), children, base)
    if (isBoolean):
      assert isinstance(node, AstExpr)
      boolSubexp.add(node)
    return boolSubexp

  return reduce_nodes(n, cb)

def ast_primitive_boolean_exprs(n: AstNode) -> Set[AstExpr]:
  def cb(node: AstNode, children: Iterable[Set[AstExpr]]) -> Set[AstExpr]:
    relOps = [ "<", ">", "<=", ">=", "==",  "!=" ]
    isBoolean = (isinstance(node, AstBinExpr) and node.op in relOps)
    base = set([]) # type: Set[AstExpr]
    boolSubexp = reduce(lambda x,y: x.union(y), children, base)
    if (isBoolean):
      assert isinstance(node, AstExpr)
      boolSubexp.add(node)
    return boolSubexp

  return reduce_nodes(n, cb)
