from slimit.parser import Parser
from slimit.visitors.nodevisitor import ASTVisitor
from slimit.visitors import nodevisitor
from slimit import ast
from z3 import *

def addAllIntEnv(inv, env = {}):
  p = Parser()
  t = p.parse(inv)

  for node in nodevisitor.visit(t):
    if isinstance(node, ast.Identifier):
      env[node.value] = Int

  return env

def invJSToZ3(inv, typeEnv):
  p = Parser()
  t = p.parse(inv)

  assert(isinstance(t, ast.Program))
  assert(len(t.children()) == 1)
  assert(isinstance(t.children()[0], ast.ExprStatement))
  return jsToZ3Expr(t.children()[0].expr, typeEnv)

def jsNumToZ3(strN):
  try:
    intV = int(strN)
    return intV
  except:
    return float(strN)

def jsToZ3Expr(astn, typeEnv):
  if (isinstance(astn, ast.BinOp)):
    ln,rn = [jsToZ3Expr(x, typeEnv) for x in astn.children()]

    try:
      return {
        '&&': And,
        '||': Or,
        '==': lambda x,y: x == y,
        '!=': lambda x,y: x != y,
        '<': lambda x,y: x < y,
        '>': lambda x,y: x > y,
        '<=': lambda x,y: x <= y,
        '>=': lambda x,y: x >= y,
        '+': lambda x,y: x + y,
        '-': lambda x,y: x - y,
        '*': lambda x,y: x * y,
        '/': lambda x,y: x / y,
      }[astn.op](ln, rn)
    except:
      raise Exception("Don't know how to parse " + astn.to_ecma())
  elif (isinstance(astn, ast.Identifier)):
    name = astn.value
    return typeEnv[name](name);
  if (isinstance(astn, ast.Number)):
    return jsNumToZ3(astn.value)
  else:
    raise Exception("Don't know how to parse " + astn.to_ecma())

def esprimaToZ3Expr(astn, typeEnv):
  if (astn["type"] == "UnaryExpression"):
    arg = esprimaToZ3Expr(astn["argument"], typeEnv)
    try:
      return {
        '-': lambda x:  -x,
        '!': lambda x:  Not(x)
      }[astn["operator"]](arg)
    except:
      raise Exception("Unknown unary expression " + str(astn))
  elif (astn["type"] == "BinaryExpression"):
    ln,rn = esprimaToZ3Expr(astn["left"], typeEnv), esprimaToZ3Expr(astn["right"], typeEnv)

    try:
      return {
        '&&': And,
        '||': Or,
        '==': lambda x,y: x == y,
        '!=': lambda x,y: x != y,
        '<': lambda x,y: x < y,
        '>': lambda x,y: x > y,
        '<=': lambda x,y: x <= y,
        '>=': lambda x,y: x >= y,
        '+': lambda x,y: x + y,
        '-': lambda x,y: x - y,
        '*': lambda x,y: x * y,
        '/': lambda x,y: x / y,
      }[astn["operator"]](ln, rn)
    except:
      raise Exception("Unkown binary expression " + str(astn))
  elif (astn["type"] == "Identifier"):
    return Int(astn["name"]);
  if (astn["type"] == "Literal"):
    return jsNumToZ3(astn["raw"])
  else:
    raise Exception("Don't know how to parse " + str(astn))

def esprimaToZ3(inv, typeEnv):
  if (inv["type"] != "Program" or "body" not in inv or \
    len(inv["body"]) != 1 or
    inv["body"][0]["type"] != "ExpressionStatement" or \
    "expression" not in inv["body"][0]):
    raise Exception("Bad struct")
  return esprimaToZ3Expr(inv["body"][0]["expression"], typeEnv)

if __name__ == "__main__":
  p = Parser()
  t = p.parse("  i == 4 && b == 44")
  print invJSToZ3("i == 4", { "i" : Int })
  print invJSToZ3("  i == 4 && b == 44", { "i" : Int, "b" : Int })
  print invJSToZ3("  i == 4.0 && b == 44", { "i" : lambda x:  FP(x, FPSort(8, 24)), "b" : Int })
