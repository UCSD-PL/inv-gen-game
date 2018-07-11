from js import esprimaToZ3, EsprimaNode
from typing import List, TypeVar, Callable, Tuple, Any
from db_util import MturkIdT

T=TypeVar("T")

def pp_BoogieLvl(lvl):
  if (lvl != None):
    return "Boogie(" + str(lvl['data']) + ")"
  else:
    return str(lvl)

def pp_EsprimaInv(inv: EsprimaNode) -> str:
  return str(esprimaToZ3(inv, {}))

def pp_List(l: List[T], pp_el: Callable[[T], str]) -> str:
  return "[" + ",".join([pp_el(el) for el in l]) + "]"

def pp_Tuple(t: Tuple[Any,...], *pps: Callable[[Any], str]):
  return "(" + ",".join([pp(el) for (pp,el) in zip(pps, t)]) + ")"

def pp_EsprimaInvs(invs: List[EsprimaNode]) -> str:
  return pp_List(invs, pp_EsprimaInv)

def pp_EsprimaInvPairs(invPairs: List[Tuple[EsprimaNode, EsprimaNode]]) -> str:
  return pp_List(invPairs, lambda p:  pp_Tuple(p, pp_EsprimaInv, pp_EsprimaInv))

# TODO: Make more specific than Any
def pp_Ctrex(ctrx: Tuple[EsprimaNode, Any]) -> str:
  return pp_Tuple(ctrx, pp_EsprimaInv, str)

# TODO: Make more specific than Any
def pp_Ctrexs(ctrxs: List[Any]) -> str:
  return pp_List(ctrxs, pp_Ctrex);

# TODO: Make more specific than Any
def pp_CheckInvsRes(res: Any) -> str:
  return pp_Tuple(res, pp_Ctrexs, pp_Ctrexs, pp_EsprimaInvs)

def pp_tryAndVerifyRes(res: Any) -> str:
  return pp_Tuple(res, pp_Ctrexs, pp_Ctrexs, pp_EsprimaInvs, str, str)

def pp_mturkId(mId: MturkIdT) -> str:
  return pp_Tuple(mId, str, str, str)
