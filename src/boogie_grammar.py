from pyparsing import delimitedList,nums
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


csl = delimitedList

LT = L("<")
GT = L(">")
EQ = L("=")
# Braces/Brackets
LSQBR = S("[")
RSQBR = S("]")
LPARN = S("(")
RPARN = S(")")
LBRAC = S("{")
RBRAC = S("}")
# Various Delimiters
SEMI = S(";")
COLN = S(":")
ASSGN = S(":=")
STAR = S("*")

####### Keywords
INT = K("int")
BOOL = K("bool")
TYPE = K("type")
FINITE = K("finite")
CONST = K("const")
UNIQUE = K("unique")
RETURNS = K("returns")
FUNCTION = K("function")
FALSE = K("false")
TRUE = K("true")
OLD = K("old")
AXIOM = K("axiom")
FORALL = K("forall")
EXISTS = K("exists")
VAR = K("var")
PROCEDURE = K("procedure")
FREE = K("free")
RETURNS = K("returns")
REQUIRES = K("requires")
MODIFIES = K("modifies")
ENSURES = K("ensures")
ASSERT = K("assert")
COMPLETE = K("complete")
UNIQUE = K("unique")
IF = K("if")
ELSE = K("else")
FREE = K("free")
INVARIANT = K("invariant")
ASSUME = K("assume")
ASSERT = K("assert")
HAVOC = K("havoc")
CALL = K("call")
WHILE = K("while")
BREAK = K("break")
GOTO = K("goto")
RETURN = K("return")
IMPLEMENTATION = K("implementation")

Id = R("[a-zA-Z_][a-zA-Z0-9_#]*")
ParentEdge = O(UNIQUE) + Id
ParentInfo = S("<:") + csl(ParentEdge)
OrderSpec = O(ParentInfo) + O(COMPLETE)
StringLiteral = F(); # TODO
Trigger = F() # TODO

####### Attributes
Expr = F(); # TODO
AttrArg = Expr | StringLiteral
Attribute = LBRAC + COLN + Id + csl(AttrArg) + RBRAC
AttrList = ZoM(Attribute)

####### Types
Type = F();
BVType = R("bv[0-9][0-9]*")
TypeAtom = INT | BOOL | BVType | LPARN + Type + RPARN
TypeArgs = S(LT) + csl(Type) + S(GT)
MapType = O(TypeArgs) + LSQBR + csl(Type) + RSQBR + Type 

TypeCtorArgs = F()
TypeCtorArgs = TypeAtom + O(TypeCtorArgs) |\
               Id + O(TypeCtorArgs) |\
               MapType

Type << (TypeAtom | MapType | Id + O(TypeCtorArgs))
IdsType = csl(Id) + COLN + Type

####### Expressions
EquivOp = L("<==>")
ImplOp = L("==>")
OrOp = L("||")
AndOp = L("&&")
RelOp = (L("!=") | L ("<=") | L(">=") | L("<:")| L("==") |  L("<") | L(">") )
ConcatOp = L("++")
AddOp = (L("+") | L("-"))
MulOp = (L("*") | L("/") | L("%"))
UnOp = (L("!") | L("-"))
QOp = (FORALL | EXISTS)
QSep = L("::")

E0 = F();
E1 = F();
E4 = F();
E5 = F();
E6 = F();
E7 = F();

Number = W(nums)
BitVector = R("[0-9][0-9]*bv[0-9][0-9]*")
TrigAttr = Trigger | Attribute
FuncApplication = LPARN + csl(Expr) + RPARN

E9_Fun_App = Id + O(FuncApplication)
E9_Old = OLD + LPARN + Expr + RPARN
E9_Parns = LPARN + Expr + RPARN
E9_Primitive = FALSE | TRUE | Number | BitVector 
E9_Quantified = LPARN + QOp + O(TypeArgs) + csl(IdsType) + QSep + ZoM(TrigAttr) + Expr  +  RPARN 

E9 =  E9_Primitive \
    | E9_Fun_App \
    | E9_Old \
    | E9_Quantified \
    | E9_Parns
MapUpdate = ASSGN + Expr
MapOp = LSQBR + csl(Expr) + O(MapUpdate) + RSQBR | \
        LSQBR + Number + COLN + Number + RSQBR
E8 = E9 + ZoM(MapOp)
E7 = ZoM(UnOp) + E8
E6 << (E7 + ZoM(MulOp + E6))
E5 << (E6 + ZoM(AddOp + E5))
E4 << E5 + ZoM(ConcatOp + E4)
E3 = (E4 + RelOp + E4| E4 )
EOr = OrOp + E3
EAnd = AndOp + E3
E2 = (E3 + OoM(EOr) | E3 + OoM(EAnd) | E3)
E1 << (E2 + ZoM(ImplOp + E1))
E0 << (E1 + ZoM(EquivOp + E0))
Expr << E0

####### Type Declarations
TypeConstructor = TYPE + AttrList + O(FINITE) + OoM(Id) + SEMI
TypeSynonym = TYPE + AttrList + OoM(Id) + EQ + Type + SEMI 
TypeDecl = TypeConstructor | TypeSynonym;

####### Constant Declarations
ConstantDecl = CONST + O(Attribute) + O(UNIQUE) + IdsType + OrderSpec;

####### Function Declarations
FArgName = Id + COLN
FArg = FArgName + Type
FSig = O(TypeArgs) + LPARN + csl(FArg) + RPARN + RETURNS + LPARN + FArg + RPARN
FunctionDecl = FUNCTION + ZoM(Attribute) + Id + FSig + SEMI |\
               FUNCTION + ZoM(Attribute) + Id + FSig + SEMI + LBRAC + Expr + RBRAC

####### Axiom Declarations
AxiomDecl = AXIOM + ZoM(Attribute) + Expr;

WhereClause = F() # TODO

IdsTypeWhere = IdsType + O(WhereClause)
VarDecl = VAR + ZoM(Attribute) + IdsTypeWhere;

####### Procedure Declarations
Spec =  O(FREE) + REQUIRES + Expr + SEMI \
      | O(FREE) + MODIFIES + csl(Id) + SEMI \
      | O(FREE) + ENSURES + Expr + SEMI

OutParameters = RETURNS + LPARN + csl(IdsTypeWhere) + RPARN
PSig = O(TypeArgs) + LPARN + csl(IdsTypeWhere) + RPARN + O(OutParameters)


LocalVarDecl = VAR + ZoM(Attribute) + csl(IdsTypeWhere) + SEMI;

StmtList = F()
WildcardExpr = Expr | STAR

BlockStmt = LBRAC + StmtList + RBRAC

LoopInv = O(FREE) + INVARIANT + Expr + SEMI

IfStmt = F()
Else = ELSE + BlockStmt | ELSE + IfStmt
IfStmt = IF + LBRAC + WildcardExpr + RBRAC + BlockStmt + O(Else)

CallLhs = csl(Id) + ASSGN
MapSelect = LSQBR + csl(Expr) + RSQBR
Lhs = Id + ZoM(MapSelect)
Label = Id | Number

AssertStmt = ASSERT + Expr + SEMI
AssumeStmt = ASSUME + O(S("{:partition}")) + Expr + SEMI 
ReturnStmt = RETURN + SEMI 
GotoStmt = GOTO + csl(Label) + SEMI
AssignmentStmt = G(csl(Lhs)) + ASSGN + G(csl(Expr)) + SEMI 
Stmt =  AssertStmt \
      | AssumeStmt \
      | HAVOC + csl(Id) + SEMI \
      | AssignmentStmt \
      | CALL + CallLhs + Id + LPARN + csl(Expr) + RPARN + SEMI \
      | CALL + FORALL + Id + LPARN + csl(WildcardExpr) + RPARN + SEMI \
      | IfStmt \
      | WHILE + LPARN + WildcardExpr + RPARN + ZoM(LoopInv) + BlockStmt\
      | BREAK + O(Id) + SEMI \
      | ReturnStmt \
      | GotoStmt

LStmt = F();
LabeledStatement = Label + COLN + LStmt
LStmt << (Stmt | LabeledStatement)
LEmpty = F();
LEmpty <<(Id + COLN + O(LEmpty))
StmtList << (ZoM(LStmt) + O(LEmpty))


Body = LBRAC + G(ZoM(G(LocalVarDecl))) + G(StmtList) + RBRAC
ProcedureDecl = PROCEDURE + ZoM(Attribute) + Id + PSig + SEMI + ZoM(Spec) |\
                PROCEDURE + ZoM(Attribute) + Id + PSig + ZoM(Spec) + Body

IOutParameters = RETURNS + LPARN + csl(IdsType) + RPARN
ISig = G(O(TypeArgs)) + LPARN + G(csl(IdsType)) + RPARN + G(O(IOutParameters))
ImplementationDecl = IMPLEMENTATION + G(ZoM(Attribute)) + Id + G(ISig) + G(ZoM(Body))

Decl = TypeDecl | ConstantDecl | FunctionDecl | AxiomDecl | VarDecl | \
    ProcedureDecl | ImplementationDecl

Program = ZoM(Decl);

if __name__ == "__main__":
    print Expr.parseString("z#AT#0 == 1 - 0")
    print Body.parseString(open('desugared.bpl').read())
    pass
