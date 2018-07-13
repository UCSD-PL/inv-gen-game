from pyboogie.ast import AstUnExpr, AstBinExpr, AstId, AstTrue, \
        AstFalse, AstNumber, normalize, parseType, AstExpr
from pyboogie.z3_embed import Int, And, Or, Not, Implies, BoolVal, IntVal, Z3TypeEnv
import z3
from lib.common.util import ccast
from pyboogie.bb import TypeEnv, Any, Optional, TypeEnv as BoogieTypeEnv

from typing import Optional, Dict, Any, Callable, cast

# TODO: When typings for esprima nodes are available, remove all 'Any' typings in this file.
binOpFactoryT = Callable[[z3.ExprRef, z3.ExprRef], z3.ExprRef]
EsprimaNode = Dict[str, Any]

def jsNumToZ3(strN: str) -> z3.IntNumRef:
  try:
    intV = int(strN)
    return IntVal(intV)
  except Exception:
    raise Exception("Dont' currently support floats");

def esprimaToZ3Expr(astn: EsprimaNode, typeEnv: Z3TypeEnv) -> z3.ExprRef:
  if (astn["type"] == "UnaryExpression"):
    arg = esprimaToZ3Expr(astn["argument"], typeEnv)
    try:
      if (astn["operator"] == "+"):
        return arg;
      return {
        '-': lambda x:  -x,
        '!': Not
      }[astn["operator"]](arg)
    except KeyError:
      raise Exception("Unknown unary expression " + str(astn))
  elif (astn["type"] == "BinaryExpression"):
    ln = esprimaToZ3Expr(astn["left"], typeEnv)
    rn = esprimaToZ3Expr(astn["right"], typeEnv)

    try:
      return {
        '==': lambda x,y: x == y,
        '!==': lambda x,y: x != y,
        '<': lambda x,y: x < y,
        '>': lambda x,y: x > y,
        '<=': lambda x,y: x <= y,
        '>=': lambda x,y: x >= y,
        '+': lambda x,y: x + y,
        '-': lambda x,y: x - y,
        '*': lambda x,y: x * y,
        '/': lambda x,y: x / y,
        '%': lambda x,y: x % y,
      }[astn["operator"]](ln, rn)
    except KeyError:
      raise Exception("Unkown binary expression " + str(astn))
  elif (astn["type"] == "LogicalExpression"):
    ln = esprimaToZ3Expr(astn["left"], typeEnv)
    rn = esprimaToZ3Expr(astn["right"], typeEnv)
    try:
      return {
        '&&': cast(binOpFactoryT, And),
        '||': cast(binOpFactoryT, Or),
        '->': Implies,
      }[astn["operator"]](ln, rn)
    except KeyError:
      raise Exception("Unkown logical expression " + str(astn))
  elif (astn["type"] == "Identifier"):
    return Int(astn["name"]);
  if (astn["type"] == "Literal"):
    if (astn["raw"] in ["true", "false"]):
      return BoolVal(True) if (astn["raw"] == "true") else BoolVal(False);
    else:
      return jsNumToZ3(astn["raw"])
  else:
    raise Exception("Don't know how to parse " + str(astn))

def _esprimaToBoogieExprAst(astn: EsprimaNode, typeEnv: BoogieTypeEnv) -> AstExpr:
  if (astn["type"] == "UnaryExpression"):
    arg = _esprimaToBoogieExprAst(astn["argument"], typeEnv)
    try:
      if (astn["operator"] == "+"):
        return arg;

      return AstUnExpr({
        '-': '-',
        '!': '!'
      }[astn['operator']], arg)
    except KeyError:
      raise Exception("Unknown unary expression " + str(astn))
  elif (astn["type"] == "BinaryExpression"):
    ln = _esprimaToBoogieExprAst(astn["left"], typeEnv)
    rn = _esprimaToBoogieExprAst(astn["right"], typeEnv)

    try:
      op = {
        '==': '==',
        '!=': '!=',
        '!==': '!=',
        '<': '<',
        '>': '>',
        '<=': '<=',
        '>=': '>=',
        '+': '+',
        '-': '-',
        '*': '*',
        '/': 'div',
        '%': 'mod',
      }
      return AstBinExpr(ln, op[astn['operator']], rn)
    except KeyError:
      raise Exception("Unkown binary expression " + str(astn))
  elif (astn["type"] == "LogicalExpression"):
    ln,rn = _esprimaToBoogieExprAst(astn["left"], typeEnv), \
            _esprimaToBoogieExprAst(astn["right"], typeEnv)

    try:
      op = {
        '&&': '&&',
        '||': '||',
        '->': '==>',
      }
      return AstBinExpr(ln, op[astn['operator']], rn)
    except KeyError:
      raise Exception("Unkown logical expression " + str(astn))
  elif (astn["type"] == "Identifier"):
    return AstId(astn["name"]);
  if (astn["type"] == "Literal"):
    if (astn["raw"] in ["true", "false"]):
      return AstTrue() if astn["raw"] == "true" else AstFalse()
    else:
      return AstNumber(int(astn["raw"]))
  else:
    raise Exception("Don't know how to parse " + str(astn))

def esprimaToBoogieExprAst(n: EsprimaNode, typeEnv: BoogieTypeEnv) -> AstExpr:
  return ccast(normalize(_esprimaToBoogieExprAst(n, typeEnv)), AstExpr)

def esprimaToZ3(inv: EsprimaNode, typeEnv: Z3TypeEnv) -> z3.ExprRef:
  if (inv["type"] != "Program" or "body" not in inv or \
    len(inv["body"]) != 1 or
    inv["body"][0]["type"] != "ExpressionStatement" or \
    "expression" not in inv["body"][0]):
    raise Exception("Bad struct")
  return esprimaToZ3Expr(inv["body"][0]["expression"], typeEnv)

def esprimaToBoogie(inv: EsprimaNode, typeEnv: BoogieTypeEnv) -> AstExpr:
  if (inv["type"] != "Program" or "body" not in inv or \
    len(inv["body"]) != 1 or
    inv["body"][0]["type"] != "ExpressionStatement" or \
    "expression" not in inv["body"][0]):
    raise Exception("Bad struct")
  return esprimaToBoogieExprAst(inv["body"][0]["expression"], typeEnv)

def boogieToEsprimaExpr(expr: AstExpr) -> EsprimaNode:
    if isinstance(expr, AstNumber):
        return { "type": "Literal", "value": expr.num, "raw": str(expr.num) }
    elif isinstance(expr, AstId):
        return { "type": "Identifier", "name": expr.name }
    elif isinstance(expr, AstTrue):
        return { "type": "Literal", "value": True, "raw": "true" }
    elif isinstance(expr, AstFalse):
        return { "type": "Literal", "value": False, "raw": "false" }
    elif isinstance(expr, AstUnExpr):
        espr_op = {
            '-':    '-',
            '!':    '!',
        }[expr.op]
        return { "type": "UnaryExpression",
                 "operator": espr_op,
                 "argument": boogieToEsprimaExpr(expr.expr) }
    elif isinstance(expr, AstBinExpr):
        lhs = boogieToEsprimaExpr(expr.lhs)
        rhs = boogieToEsprimaExpr(expr.rhs)

        # Hack to desugar implication to disjunction for esprima.
        if (expr.op == "==>"):
          return {"type": "LogicalExpression",
                  "operator": "||",\
                  "left": { "type": "UnaryExpression",
                            "operator": "!",
                            "argument": lhs },
                  "right": rhs }

        espr_op, typ = {
            '+':    ('+', 'BinaryExpression'),
            '-':    ('-', 'BinaryExpression'),
            '*':    ('*', 'BinaryExpression'),
            'div':  ('/', 'BinaryExpression'),
            'mod':  ('%', 'BinaryExpression'),
            '<':    ('<', 'BinaryExpression'),
            '>':    ('>', 'BinaryExpression'),
            '<=':    ('<=', 'BinaryExpression'),
            '>=':    ('>=', 'BinaryExpression'),
            '==':    ('==', 'BinaryExpression'),
            '!=':    ('!==', 'BinaryExpression'),
            '&&':    ('&&', 'LogicalExpression'),
            '||':    ('||', 'LogicalExpression'),
        }[expr.op]
        return { "type": typ, "operator": espr_op, "left": lhs, "right": rhs }
    else:
        raise Exception("Unknown expression " + str(expr))

def boogieToEsprima(inv: AstExpr) -> EsprimaNode:
  return { "type":"Program",
           "sourceType": "script",
           "body": [ { "type": "ExpressionStatement",
                       "expression": boogieToEsprimaExpr(inv) } ] }
                       
JSONTypeEnv = Dict[str, str]
def jsonToTypeEnv(json: Any) -> TypeEnv:
  return { varName: parseType(typ) for (varName, typ) in json.items() }

def typeEnvToJson(typeEnv: TypeEnv) -> JSONTypeEnv:
  return { varName: str(typ) for (varName, typ) in typeEnv.items() }