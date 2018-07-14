from random import randint, choice
from lib.common.util import unique
from infinite import product
from pyboogie.bb import Function, LabelT, BB
from pyboogie.analysis import livevars
from pyboogie.eval import execute
from pyboogie.interp import Store, trace_n_from_start, RandF, ChoiceF, BoogieVal
from typing import Dict, Any, Iterator, Callable, List, Set, Tuple, Optional

def varproduct(vargens: Dict[Any, Any]) -> Iterator[Dict[Any, Any]]:
  # Take var: gen and generate all var assignments (smallest first), i.e.
  # "A": count(), "B": count() yields
  #   (A, B) = (0, 0), (0, 1), (1, 0), (0, 2), (1, 1), (2, 0), ...
  if len(list(vargens.items())) == 0:
    yield {}
  else:
    vars_, gens = list(zip(*list(vargens.items())))
    for vals in product(*gens):
      yield dict(list(zip(vars_, vals)))

def getEnsamble(fun: Function, exec_limit: int, tryFind: int=100, vargens: Optional[Iterator[Store]] = None) -> Iterator[Tuple[List[Store], Set[str]]]:
    loopHdr: BB = unique(fun.loopHeaders())
    traceVs: List[str] = list(livevars(fun)[(loopHdr, 0)])
    # TODO: Actually check the types
    randF: RandF = lambda state, varName:    randint(0, 100)
    choiceF: ChoiceF = lambda states:   [choice(states)]

    if vargens is None:
      def candidatef() -> Iterator[Store]:
        # TODO: Make this typesafe w.r.t. Function type env
        while True:
          yield {v: randint(0, 30) for v in traceVs}
      vargens = candidatef()

    tried: Set[Tuple[int,...]] = set()
    #TODO: Not a smart way for generating random start values. Fix.
    s = 0
    print("Trying to find ", tryFind, " traces of length up to ", exec_limit)
    while s < tryFind:
        candidate = next(vargens)
        hashable = tuple(candidate[v] for v in traceVs)
        if hashable in tried:
          continue
        tried.add(hashable)

        found = False
        (active_traces, done_traces) = trace_n_from_start(fun, candidate, exec_limit, randF, choiceF)
        for trace in active_traces + done_traces:
            vals: List[Store] = [ store for ((bb, idx), store, status) in trace if bb == loopHdr and idx == 0 ]
            bbhit: Set[str] = set(bb.label for ((bb, idx), _, _) in trace)
            yield (vals, bbhit)
            found = True
            s += 1
            if (s >= tryFind):
                break

        if (not found):
            s += 1