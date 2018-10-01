from pyboogie.ast import parseExprAst, ast_and
from pyboogie.bb import Function, BB, TypeEnv
from pyboogie.interp import Store, Trace, eval_quick
from pyboogie.analysis import livevars
from lib.common.util import unique, error
from lib.invgame_server.levels import readTrace, writeTrace
from collections import OrderedDict
from os import listdir
from os.path import dirname, join, abspath, realpath
from json import load, dumps
from lib.invgame_server.js import typeEnvToJson

from typing import Dict, Any, List, Tuple, Optional

class FlowgameLevel:
    def __init__(self, id: str, fun: Function, trace: Optional[Trace], bplPath: str) -> None:
        self._id = id
        self._fun = fun
        self._trace = trace
        self._bplPath = bplPath 

    @staticmethod
    def load(fname: str, lvlId: str) -> "FlowgameLevel":
        fun: Function = unique(list(Function.load(fname)))
        try:
            (vs, header_vals) = readTrace(fname[:-4] + '.trace', fun.getTypeEnv())
        except:
            (vs, header_vals) = (None, None)

        if (header_vals is not None):
            assert len(fun.loopHeaders()) == 1, "TODO: Not implemented trace format for multi-loop functions"

        return FlowgameLevel(lvlId, fun, header_vals, fname)

    def to_json(self) -> Any:
        return {
            "id":   self._id,
            "fun":  self._fun.to_json(),
            "data": self._trace,
            "typeEnv":  typeEnvToJson(self._fun.getTypeEnv())
        }


def loadLvlSet(lvlSetFile: str) -> Tuple[str, Dict[str, FlowgameLevel]]:
    # Small helper funct to make sure we didn't
    # accidentally give two levels the same name
    def assertUniqueKeys(kvs):
      keys = [x[0] for x in kvs]
      assert (len(set(keys)) == len(keys))
      return dict(kvs)

    lvlSet = load(open(lvlSetFile, "r"), object_pairs_hook=assertUniqueKeys)
    lvlSetDir = dirname(abspath(realpath(lvlSetFile)))
    error("Loading level set " + lvlSet["name"] + " from " + lvlSetFile)
    lvls: Dict[str, FlowgameLevel] = OrderedDict()
    for t in lvlSet["levels"]:
        lvlName = t[0]
        lvlPath = t[1]

        for i in range(len(lvlPath)):
          lvlPath[i] = join(lvlSetDir, lvlPath[i])
            
        error("Loading level: ", lvlPath[0])
        fun = FlowgameLevel.load(lvlPath[0], lvlName)
        lvls[lvlName] = fun

    return (lvlSet["name"], lvls)