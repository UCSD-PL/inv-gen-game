from pyparsing import delimitedList,nums, ParserElement
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

LT = L("<")
GT = L(">")
EQ = L("=")
LPARN = S("(")
RPARN = S(")")
LBRAC = S("{")
RBRAC = S("}")
FALSE = K("false")
TRUE = K("true")

EquivOp = L("<==>")
ImplOp = L("==>")
OrOp = L("||")
AndOp = L("&&")
RelOp = (L("!=") | L ("<=") | L(">=") | L("<:")| L("==") |  L("<") | L(">") )
AddOp = (L("+") | L("-"))
MulOp = (L("*") | L("/") | L("%"))
PowOp = L("**")
UnOp = (L("!") | L("-"))

Expr = F();
E0 = F();
E1 = F();
E5 = F();
E6 = F();

Id = R("[a-zA-Z_][a-zA-Z0-9_#]*")
Number = W(nums)

E9_Parns = LPARN + Expr + RPARN
E9_Primitive = FALSE | TRUE | Number | Id

E9 =  E9_Primitive \
    | E9_Parns

E7 = ZoM(UnOp) + E9
E65 = E7 + PowOp + E7 | E7
E6 << (E65 + ZoM(MulOp + E6))
E5 << (E6 + ZoM(AddOp + E5))
E3 = (E5 + RelOp + E5| E5 )
EOr = OrOp + E3
EAnd = AndOp + E3
EOrs = OoM(EOr)
EAnds = OoM(EAnd)
E2 = (E3 + EOrs | E3 + EAnds | E3)
E1 << (E2 + ZoM(ImplOp + E1))
E0 << (E1 + ZoM(EquivOp + E0)) 
Expr << E0

IsPow2 = Id + S("is a power of 2")
IsOneOf = Id + S("one of") + LBRAC + csl(E7) + RBRAC
IsInRange = Number + S(L("<=")) + Id + S(L("<=")) + Number
IsBoolean = Id + S(L("is boolean"))

JustInv = IsPow2 | IsOneOf | IsInRange | IsBoolean | Expr


Inv = S(R("warning: too few samples for [a-zA-Z\._]* invariant:")) + JustInv | JustInv 


