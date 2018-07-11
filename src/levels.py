from pyboogie.ast import parseExprAst, ast_and
from pyboogie.bb import Function, BB
from pyboogie.interp import Store, Trace, eval_quick
from pyboogie.analysis import livevars
from lib.common.util import unique, error
from pyboogie.eval import _to_dict
from collections import OrderedDict
from os import listdir
from os.path import dirname, join, abspath, realpath
from json import load, dumps

from typing import Dict, Any, List, Tuple

ValTrace=List[Store]

def readTrace(fname: str) -> Tuple[List[str], ValTrace]:
    trace = open(fname, "r").read()
    lines = [x for x in [x.strip() for x in trace.split('\n')] if len(x) != 0]
    vs = [x for x in lines[0].split(' ') if len(x) != 0]
    header_vals = [ ]
    for l in lines[1:]:
        if (l[0] == '#'):
            continue

        env : Store = { }
        for (var,val) in zip(vs, [x for x in l.split(' ') if len(x) != 0]):
            env[var] = int(val)
        header_vals.append(env)
    return (vs, header_vals)

def writeTrace(fname: str, header_vals: ValTrace) -> None:
    f = open(fname, "w")

    if (len(header_vals) != 0):
      vs = list(header_vals[0].keys())
      f.write(" ".join(vs) + "\n")
      for env in header_vals:
        f.write(" ".join([str(env[v]) for v in vs]) + "\n")

    f.close()

BoogieTraceLvl=Dict[str, Any]
def loadBoogieFile(fname: str) -> BoogieTraceLvl:
    """ Load a boogie file, asserting it contains a single function with a single loop.
    """
    fun: Function = unique(list(Function.load(fname)))
    hdr: BB = unique(fun.loopHeaders())

    # The variables to trace are all live variables at the loop header
    vs = list(livevars(fun)[(hdr, 0)])

    # Make sure variable names are different modulo case
    assert len(vs) == len(set([var.lower() for var in vs]))

    # See if there is a .trace or a .hint file
    hint = None
    header_vals = None
    terminates = False
    try:
        (vs, header_vals) = readTrace(fname[:-4] + '.trace')
        hint = load(open(fname[:-4] + '.hint'))
    except Exception: #TODO (Dimo) IOError here instead?
        pass

    assert (header_vals is not None)
    return { 'variables': vs,
             'data': [ [[ str(row[v]) for v in vs  ] for row in header_vals],
                       [],
                       [] ],
             'exploration_state' : [ ( [str(header_vals[0][v]) for v in vs],
                                       len(header_vals),
                                       terminates ) ],
             'hint': hint,
             'program' : fun,
             'loop' : hdr
    }

def loadBoogieLvlSet(lvlSetFile: str) -> Tuple[str, Dict[str, BoogieTraceLvl]]:
    # Small helper funct to make sure we didn't
    # accidentally give two levels the same name
    def assertUniqueKeys(kvs):
      keys = [x[0] for x in kvs]
      assert (len(set(keys)) == len(keys))
      return dict(kvs)

    lvlSet = load(open(lvlSetFile, "r"), object_pairs_hook=assertUniqueKeys)
    lvlSetDir = dirname(abspath(realpath(lvlSetFile)))
    error("Loading level set " + lvlSet["name"] + " from " + lvlSetFile)
    lvls: Dict[str, BoogieTraceLvl] = OrderedDict()
    for t in lvlSet["levels"]:
        lvlName = t[0]
        lvlPath = t[1]

        for i in range(len(lvlPath)):
          lvlPath[i] = join(lvlSetDir, lvlPath[i])
            
        error("Loading level: ", lvlPath[0])
        lvl = loadBoogieFile(lvlPath[0])
        lvl["path"] = lvlPath

        if (len(t) > 2):
          splitterPreds = [ parseExprAst(exp) for exp in t[2] ]
          splitterPred = ast_and(splitterPreds)
          remainderInv = parseExprAst(t[3])

          lvl['data'][0] = [row for row in lvl['data'][0] if eval_quick(splitterPred, { k: v for k,v in zip(lvl['variables'], row)})]

          if (len(lvl['data'][0]) == 0):
            error("SKIPPING : ", lvlName, " due to no filtered rows.")
            continue

          lvl['partialInv'] = remainderInv
          lvl['splitterPreds'] = splitterPreds

        lvls[lvlName] = lvl

    return (lvlSet["name"], lvls)