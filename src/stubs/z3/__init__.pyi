from typing import overload, Tuple, Any, List, Iterable, Iterator, Optional
from .z3types import Ast, ContextObj

class Context:
  ...

class Z3PPObject:
  ...

class AstRef(Z3PPObject):
  @overload
  def __init__(self, ast: Ast, ctx: Context) -> None:
    self.ast: Ast = ...
    self.ctx: Context= ...

  @overload
  def __init__(self, ast: Ast) -> None:
    self.ast: Ast = ...
    self.ctx: Context= ...
  def ctx_ref(self) -> ContextObj:  ...
  def as_ast(self) -> Ast:  ...
  def children(self) -> List[AstRef]: ...

class SortRef(AstRef):
  ...

class FuncDeclRef(AstRef):
  def arity(self) -> int: ...
  def name(self) -> str:  ...
  def __call__(self, *args: ExprRef) -> ExprRef:  ...

class ExprRef(AstRef):
  def eq(self, other: ExprRef) -> ExprRef:  ...
  def sort(self) -> SortRef:  ...
  def decl(self) -> FuncDeclRef:  ...

class BoolSortRef(SortRef):
  ...

class BoolRef(ExprRef):
  ...


def is_true(a: BoolRef) -> bool:  ...
def is_false(a: BoolRef) -> bool:  ...
def is_int_value(a: AstRef) -> bool:  ...
def substitute(a: AstRef, *m: Tuple[AstRef, AstRef]) -> AstRef: ...
def simplify(a: AstRef, *args: Any, **kwargs: Any) -> AstRef: ...


class ArithSortRef(SortRef):
  ...

class ArithRef(ExprRef):
  def __neg__(self) -> ExprRef: ...
  def __le__(self, other: ArithRef) -> ArithRef:  ...
  def __lt__(self, other: ArithRef) -> ArithRef:  ...
  def __ge__(self, other: ArithRef) -> ArithRef:  ...
  def __gt__(self, other: ArithRef) -> ArithRef:  ...
  def __add__(self, other: ArithRef) -> ArithRef:  ...
  def __sub__(self, other: ArithRef) -> ArithRef:  ...
  def __mul__(self, other: ArithRef) -> ArithRef:  ...
  def __div__(self, other: ArithRef) -> ArithRef:  ...
  def __mod__(self, other: ArithRef) -> ArithRef:  ...

class IntNumRef(ArithRef):
  def as_long(self) -> int: ...

class CheckSatResult: ...

class ModelRef(Z3PPObject):
  def __getitem__(self, k:  FuncDeclRef) -> IntNumRef:  ...
  def decls(self) -> Iterable[FuncDeclRef]: ...
  def __iter__(self) -> Iterator[FuncDeclRef]:  ...

class Solver(Z3PPObject):
  @overload
  def __init__(self) -> None:
    self.ctx: Context = ...
  @overload
  def __init__(self, ctx:Context) -> None:
    self.ctx: Context = ...

  def add(self, e:ExprRef) -> None: ...
  def to_smt2(self) -> str: ...
  def check(self) -> CheckSatResult: ...
  def push(self) -> None:  ...
  def pop(self) -> None:  ...
  def model(self) -> ModelRef:  ...

sat: CheckSatResult = ...
unsat: CheckSatResult = ...

@overload
def Int(name: str) -> ArithRef: ...
@overload
def Int(name: str, ctx: Context) -> ArithRef: ...

@overload
def Bool(name: str) -> BoolRef: ...
@overload
def Bool(name: str, ctx: Context) -> BoolRef: ...

@overload
def parse_smt2_string(s: str) -> ExprRef: ...
@overload
def parse_smt2_string(s: str, ctx: Context) -> ExprRef: ...

# Can't give more precise types here since func signature is
# a vararg list of ExprRef optionally followed by a Context
def Or(*args: Any) -> ExprRef: ...
def And(*args: Any) -> ExprRef: ...
def Not(p: ExprRef, ctx: Context) -> ExprRef: ...
def Implies(a: ExprRef, b: ExprRef, ctx:Context) -> ExprRef: ...

def Function(name: str, *sig: SortRef) -> FuncDeclRef:  ...

def IntVal(val: int, ctx: Context) -> IntNumRef:  ...
def BoolVal(val: bool, ctx: Context) -> BoolRef:  ...

def IntSort(ctx: Optional[Context]) -> ArithSortRef:  ...
