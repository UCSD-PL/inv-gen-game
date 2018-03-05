from typing import List, Union, Pattern, Any, Callable, Optional as Opt, \
  overload, Iterator, TypeVar, Generic, Iterable

T = TypeVar("T")
ParseAction = Callable[[str, int, ParseResults[Any]], Iterable[T]]

# TODO: More accurate modelling of ParseErrors
class ParseResults(Generic[T]):
  def __getitem__(self, x:  Union[int, slice]) -> T:  ...
  def __len__(self) -> int: ...
  def __iter__(self) -> Iterator[T]:  ...
  def __reversed__(self) -> Iterator[T]:  ...

class ParserElement(Generic[T]):
  @staticmethod
  def enablePackrat() -> None:  ...
  def setParseAction(self, action:  ParseAction[T]) -> None:  ...
  def __add__(self: ParserElement[T], other: ParserElement[T]) -> ParserElement[T]: ...
  def __or__(self: ParserElement[T], other: ParserElement[T]) -> ParserElement[T]: ...
  def __xor__(self: ParserElement[T], other: ParserElement[T]) -> ParserElement[T]: ...
  def parseString(self, s: str) -> ParseResults[T]: ...

class Token(ParserElement): ...

class Word(Token):
  def __init__(self: Word, initChars: str) -> None: ...

class Keyword(Token):
    def __init__(self: Keyword, matchString: str) -> None: ...

class Literal(Token):
    def __init__(self: Literal, matchString: str) -> None: ...

class StringEnd(Token):
  def __init__(self: StringEnd) -> None: ...

class Regex(Token):
  def __init__(self: Regex, pattern: Union[str, Pattern]) -> None: ...

class ParseElementEnhance(ParserElement):
    def __init__(self: ParseElementEnhance, expr:Union[str, ParserElement]) -> None: ... 

class _MultipleMatch(ParseElementEnhance):  ...

class ZeroOrMore(_MultipleMatch):  ...
class OneOrMore(_MultipleMatch): ...

class TokenConverter(ParseElementEnhance):  ...

class Suppress(TokenConverter): ...
class Optional(ParseElementEnhance):  ...
class Forward(ParseElementEnhance):
    def __init__(self: Forward) -> None:  ...
    def __lshift__(self, other: ParserElement) -> ParserElement: ...

class Group(TokenConverter):  ...

@overload
def delimitedList(expr: ParserElement) -> ParserElement: ...
@overload
def delimitedList(expr: ParserElement, delim: str) -> ParserElement: ...
@overload
def delimitedList(expr: ParserElement, delim: str, combine: bool) -> ParserElement: ...
nums: str = ...

@overload
def operatorPrecedence(baseExpr:  ParserElement, opList: List[Any]) -> ParserElement:  ...
@overload
def operatorPrecedence(
  baseExpr:  ParserElement,
  opList: List[Any],
  lpar: ParserElement,
  rpar: ParserElement) -> ParserElement:  ...


class _Constants(object):
  LEFT: object = ...
  RIGHT: object = ...

opAssoc = _Constants