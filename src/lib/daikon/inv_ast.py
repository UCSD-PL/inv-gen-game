#pylint: disable=no-self-argument, unused-argument
from lib.daikon.inv_grammar import DaikonInvParser
from ..common.ast import AstNode as AstNode
from ..common.util import error
from functools import reduce
from pyparsing import ParserElement, ParseResults
from typing import List, Any

class AstExpr(AstNode): pass

class AstUnExpr(AstExpr):
    def __init__(s, op: str, expr: AstExpr) -> None:
         AstExpr.__init__(s, str(op), expr)
    def __str__(s) -> str:
        return s.op + str(s.expr)

class AstIsPow2(AstExpr):
    def __init__(s, expr: AstExpr) -> None:
         AstExpr.__init__(s, expr)
    def __str__(s) -> str:
        return "IsPow2(" + str(s.expr) + ")"

class AstIsOneOf(AstExpr):
    def __init__(s, expr: AstExpr, options: List[AstExpr]) -> None:
         AstExpr.__init__(s, expr, options)
    def __str__(s) -> str:
        return "IsOneOf(" + str(s.expr) + \
                ",[" + ",".join(map(str, s.options)) + "])"

class AstIsBoolean(AstExpr):
    def __init__(s, expr: AstExpr) -> None:
         AstExpr.__init__(s, expr)
    def __str__(s) -> str:
        return "IsBoolean(" + str(s.expr) + ")"

class AstIsEven(AstExpr):
    def __init__(s, expr: AstExpr) -> None:
         AstExpr.__init__(s, expr)
    def __str__(s) -> str:
        return "IsEven(" + str(s.expr) + ")"

class AstInRange(AstExpr):
    def __init__(s, lower: AstExpr, expr: AstExpr, upper: AstExpr) -> None:
         AstExpr.__init__(s, lower, expr, upper)
    def __str__(s) -> str:
        return str(s.expr) + " in [" + str(s.lower) +  "," + str(s.upper) +  "]"

class AstIsConstMod(AstExpr):
    def __init__(s, expr: AstExpr, remainder: AstExpr, modulo: AstExpr) -> None:
         AstExpr.__init__(s, expr, remainder, modulo)
    def __str__(s) -> str:
        return "IsConstMod(" + str(s.expr) + "," + str(s.remainder) + \
                "," + str(s.modulo) + ")"

class AstHasValues(AstExpr):
    def __init__(s, expr: AstExpr, values: List[AstExpr]) -> None:
         AstExpr.__init__(s, expr, values)
    def __str__(s) -> str:
        return "HasValues(" + str(s.expr) + "," + str(s.values) + ")"

class AstFalse(AstExpr):
    def __init__(s) -> None:
         AstExpr.__init__(s)
    def __str__(s) -> str:
        return "false"

class AstTrue(AstExpr):
    def __init__(s) -> None:
         AstExpr.__init__(s)
    def __str__(s) -> str:
        return "true"

class AstNumber(AstExpr):
    def __init__(s, num: int) -> None:
          AstExpr.__init__(s,int(num))
    def __str__(s) -> str:
        return str(s.num)

class AstId(AstExpr):
    def __init__(s, name: str) -> None:
         AstExpr.__init__(s, str(name))
    def __str__(s) -> str:
        return s.name

class AstBinExpr(AstExpr):
    def __init__(s, lhs: AstExpr, op: str, rhs: AstExpr) -> None:
         AstExpr.__init__(s, lhs, str(op), rhs)
    def __str__(s) -> str:
        return "(" + str(s.lhs) + " " + s.op + " " + str(s.rhs) + ")"

class AstBuilder(DaikonInvParser):
  def onAtom(s, prod: ParserElement, st: str, loc: int, toks: "ParseResults[Any]") -> List[AstExpr]:
    return [ s.atomM[prod](*toks) ]

  def onUnaryOp(s, prod: ParserElement, st: str, loc: int, toks: "ParseResults[Any]") -> List[AstExpr]:
    if (prod == s.IsPow2):
      return [ AstIsPow2(toks[0]) ]
    elif (prod == s.IsBoolean):
      return [ AstIsBoolean(toks[0]) ]
    elif (prod == s.IsEven):
      return [ AstIsEven(toks[0]) ]
    else:
      return [ AstUnExpr(*toks) ]

  def onLABinOp(s, prod: ParserElement, st: str, loc: int, toks: "ParseResults[Any]") -> List[AstExpr]:
    if (len(toks) == 3):
      return [ AstBinExpr(*toks) ]
    else:
      assert(len(toks) > 3);
      base = AstBinExpr(*toks[:3])
      rest = [ [toks[3+2*k], toks[3+2*k+1]] for k in range(int((len(toks)-3)/2)) ]
      return [ reduce(lambda acc,el:  AstBinExpr(acc, el[0], el[1]),
                      rest,
                      base) ]

  def onRABinOp(s, prod: ParserElement, st: str, loc: int, toks: "ParseResults[Any]") -> List[AstExpr]:
    if (len(toks) == 3):
      return [ AstBinExpr(*toks) ]
    else:
      assert(len(toks) > 3);
      revToks: List[Any] = list(reversed(toks))
      base = AstBinExpr(*revToks[:3])
      return [ reduce(lambda acc,el:  AstBinExpr(acc, el[0], el[1]),
                      revToks[3:],
                      base) ]

  def onNABinOp(s, prod: ParserElement, st: str, loc: int, toks: "ParseResults[Any]") -> List[AstExpr]:
    if (prod == s.IsInRange):
      return [ AstInRange(toks[0], toks[1], toks[2]) ]
    elif (prod == s.IsOneOf):
      return [ AstIsOneOf(toks[0], toks[1]) ]
    else:
      assert (len(toks) == 3);
      return [ AstBinExpr(*toks) ]

  def onTernaryOp(s, prod: ParserElement, st: str, loc: int, toks: "ParseResults[Any]") -> List[AstExpr]:
    if (prod == s.IsConstMod):
      assert(len(toks) == 3)
      return [ AstIsConstMod(toks[0], toks[1], toks[2]) ]
    else:
      raise Exception("Unknown ternary operator: ", prod);

  def onVariaryOp(s, prod: ParserElement, st: str, loc: int, toks: "ParseResults[Any]") -> List[AstExpr]:
    if (prod == s.HasValues):
      assert(len(toks) > 1)
      return [ AstHasValues(toks[0], toks[1:]) ]
    else:
      raise Exception("Unknown ternary operator: ", prod);


  def __init__(s):
    DaikonInvParser.__init__(s);
    s.atomM = {
      s.TRUE : AstTrue,
      s.FALSE : AstFalse,
      s.Id : AstId,
      s.Number : AstNumber
    }

astBuilder = AstBuilder();

def parseExprAst(s: str) -> AstExpr:
  try:
    return astBuilder.parse(s);
  except:
    error("Failed parsing");
    raise;
