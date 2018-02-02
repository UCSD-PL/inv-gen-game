#pylint: disable=unused-argument, no-self-argument
from typing import Generic, TypeVar, Iterable
from pyparsing import ParserElement, ParseResults

T = TypeVar("T")

class Parser:
    pass

class InfixExprParser(Parser, Generic[T]):
  def onAtom(s, prod: "ParserElement[T]", st: str, loc: int, toks: "ParseResults[T]") -> "Iterable[T]":
      raise Exception("NYI")
  def onUnaryOp(s, prod: "ParserElement[T]", st: str, loc: int, toks: "ParseResults[T]") -> "Iterable[T]":
      raise Exception("NYI")
  def onLABinOp(s, prod: "ParserElement[T]", st: str, loc: int, toks: "ParseResults[T]") -> "Iterable[T]":
      raise Exception("NYI")
  def onRABinOp(s, prod: "ParserElement[T]", st: str, loc: int, toks: "ParseResults[T]") -> "Iterable[T]":
      raise Exception("NYI")
  def onNABinOp(s, prod: "ParserElement[T]", st: str, loc: int, toks: "ParseResults[T]") -> "Iterable[T]":
      raise Exception("NYI")

