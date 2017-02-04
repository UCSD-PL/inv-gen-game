from pyparsing import delimitedList,nums, ParserElement, operatorPrecedence, opAssoc
from pyparsing import ZeroOrMore as ZoM,\
    OneOrMore as OoM,\
    Keyword as K,\
    Suppress as S,\
    Literal as L,\
    Forward as F,\
    Optional as O,\
    Regex as R,\
    Word as W,\
    Group as G

ParserElement.enablePackrat()
csl = delimitedList

class Parser:
  def parse(s, st): raise Exception("NYI");

class InfixExprParser(Parser):
  def onAtom(s, prod, st, loc, toks): raise Exception("NYI")
  def onUnaryOp(s, prod, st, loc, toks):  raise Exception("NYI")
  def onLABinOp(s, prod, st, loc, toks):  raise Exception("NYI")
  def onRABinOp(s, prod, st, loc, toks):  raise Exception("NYI")
  def onNABinOp(s, prod, st, loc, toks):  raise Exception("NYI")
  def onTernaryOp(s, prod, st, loc, toks):  raise Exception("NYI")


class DaikonInvParser(InfixExprParser):
  def __init__(s):
    s.LT = L("<")
    s.GT = L(">")
    s.EQ = L("=")
    s.LPARN = S("(")
    s.RPARN = S(")")
    s.LBRAC = S("{")
    s.RBRAC = S("}")

    s.EquivOp = L("<==>")
    s.ImplOp = L("==>")
    s.OrOp = L("||")
    s.AndOp = L("&&")
    s.RelOp = (L("!=") | L ("<=") | L(">=") | L("<:")| L("==") |  L("<") | L(">") )
    s.AddOp = (L("+") | L("-"))
    s.MulOp = (L("*") | L("/") | L("%"))
    s.PowOp = L("**")
    s.UnOp = (L("!") | L("-"))

    s.FALSE = K("false")
    s.FALSE.setParseAction(lambda st,loc,toks:  s.onAtom(s.FALSE, st, loc, toks));
    s.TRUE = K("true")
    s.TRUE.setParseAction(lambda st,loc,toks:  s.onAtom(s.TRUE, st, loc, toks));
    s.Id = R("[a-zA-Z_][a-zA-Z0-9_#]*")
    s.Id.setParseAction(lambda st,loc,toks:  s.onAtom(s.Id, st, loc, toks));
    s.Number = W(nums)
    s.Number.setParseAction(lambda st,loc,toks:  s.onAtom(s.Number, st, loc, toks));

    s.Atom = s.FALSE | s.TRUE | s.Number | s.Id
    s.AndOrOp = s.AndOp | s.OrOp

    s.ArithExpr = operatorPrecedence(s.Atom, [
      (s.PowOp, 2, opAssoc.RIGHT, lambda st, loc, toks: s.onRABinOp(s.PowOp, st, loc, toks)),
      (s.UnOp, 1, opAssoc.RIGHT, lambda st, loc, toks: s.onUnaryOp(s.UnOp, st, loc, toks)),
      (s.MulOp, 2, opAssoc.LEFT, lambda st, loc, toks: s.onLABinOp(s.MulOp, st, loc, toks)),
      (s.AddOp, 2, opAssoc.LEFT, lambda st, loc, toks: s.onLABinOp(s.MulOp, st, loc, toks)),
    ])

    s.RelExpr = s.ArithExpr + s.RelOp + s.ArithExpr
    s.RelExpr.setParseAction(lambda st, loc, toks: s.onNABinOp(s.RelOp, st, loc, toks))

    s.BoolExpr = operatorPrecedence(s.RelExpr, [
      (s.EquivOp, 2, opAssoc.LEFT, lambda st, loc, toks:  s.onLABinOp(s.EquivOp, st, loc, toks)),
      (s.ImplOp, 2, opAssoc.LEFT, lambda st, loc, toks:  s.onLABinOp(s.ImplOp, st, loc, toks)),
      (s.AndOrOp, 2, opAssoc.LEFT, lambda st, loc, toks:  s.onLABinOp(s.AndOrOp, st, loc, toks)),
    ])

    s.Expr = s.BoolExpr | s.RelExpr | s.ArithExpr

    s.IsPow2 = s.Id + S("is a power of 2")
    s.IsPow2.setParseAction(lambda st, loc, toks:  s.onUnaryOp(s.IsPow2, st, loc, toks))
    s.IsOneOf = s.Id + S("one of") + s.LBRAC + csl(s.Expr) + s.RBRAC
    s.IsOneOf.setParseAction(lambda st, loc, toks:  s.onNABinOp(s.IsOneOf, st, loc, toks))
    s.IsInRange = s.Number + S(L("<=")) + s.Id + S(L("<=")) + s.Number
    s.IsInRange.setParseAction(lambda st, loc, toks:  s.onTernaryOp(s.IsInRange, st, loc, toks))
    s.IsBoolean = s.Id + S(L("is boolean"))
    s.IsBoolean.setParseAction(lambda st, loc, toks:  s.onUnaryOp(s.IsBoolean, st, loc, toks))

    s.JustInv = s.IsPow2 | s.IsOneOf | s.IsInRange | s.IsBoolean | s.Expr

    s.Inv = S(R("warning: too few samples for [a-zA-Z\._]* invariant:")) + s.JustInv | s.JustInv 

  def parse(s, st):
    return s.Inv.parseString(st)[0]
