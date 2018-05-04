from lib.boogie.ast import parseExprAst, ast_or, ast_and
from boogie_loops import loops, get_loop_header_values
from lib.common.util import unique, powerset, average, error
from lib.boogie.analysis import livevars
from lib.boogie.eval import instantiateAndEval, evalPred, _to_dict, execute
from lib.boogie.interp import Store
from collections import OrderedDict
from os import listdir
from os.path import dirname, join, abspath, realpath
from infinite import product
from json import load, dumps
from random import randint
from functools import reduce

from lib.boogie.ast import parseExprAst, AstExpr
from lib.boogie.bb import Function, Label_T, BB
from lib.boogie.paths import NondetPath, Path
from lib.boogie.inv_networks import InvNetwork
from typing import Dict, List, Tuple, Iterable, Set, Any

def _tryUnroll(loop, bbs, min_un, max_un, bad_envs, good_env):
    # Lets first try to find a terminating loop between min and max iterations
    term_vals = get_loop_header_values(loop, bbs, min_un, max_un,
                                       bad_envs, good_env, True)
    if (term_vals != []):
      return (term_vals, True)

    # Couldn't find a terminating loop between 0 and 6 iteration. Lets find
    # a loop that has at LEAST min iterations
    term_vals = get_loop_header_values(loop, bbs, min_un, max_un,
                                       bad_envs, good_env, False)
    return (term_vals, False)

def varproduct(vargens):
  # Take var: gen and generate all var assignments (smallest first), i.e.
  # "A": count(), "B": count() yields
  #   (A, B) = (0, 0), (0, 1), (1, 0), (0, 2), (1, 1), (2, 0), ...
  if len(list(vargens.items())) == 0:
    yield {}
  else:
    vars_, gens = list(zip(*list(vargens.items())))
    for vals in product(*gens):
      yield dict(list(zip(vars_, vals)))

def getEnsamble(loop, bbs, exec_limit, tryFind=100, distr=lambda: randint(0,5),
        include_bbhit=False, vargens=None):
    loopHdr = loop.loop_paths[0][0]
    traceVs = list(livevars(bbs)[loopHdr])
    if vargens is None:
      def candidatef():
        while True:
          yield {v: distr() for v in traceVs}
      candidategen = candidatef()
    else:
      candidategen = varproduct(vargens)
    tried = set();
    #TODO: Not a smart way for generating random start values. Fix.
    s = 0
    print("Trying to find ", tryFind, " traces of length up to ", exec_limit)
    while s < tryFind:
        candidate = next(candidategen)
        hashable = tuple(candidate[v] for v in traceVs)
        if hashable in tried:
          continue
        tried.add(hashable)

        found = False
        trace = execute(candidate, bbEntry(bbs), bbs, exec_limit)
        for _, _, _, ssap, vals in trace:
          vals = [ envs[0] for (bb, envs) in vals if bb == loopHdr ]
          if include_bbhit:
            bbhit = set(bbname for bbname, _ in ssap)
            yield (vals, bbhit)
          else:
            yield vals
          found = True;
          s += 1
          if (s >= tryFind):
            break;

        if (not found):
            s += 1;

def getInitialData(loop, bbs, nunrolls, invs, invVars = None, invConsts = None):
    if (invConsts == None):
        invConsts = ["_sc_a", "_sc_b", "_sc_c"]
    trace_enasmble = list(getEnsamble(loop, bbs, nunrolls, 1))
    vals, _ = _tryUnroll(loop, bbs, 0, nunrolls, None, None)
    if (vals):
        trace_enasmble.append(vals)
    
    traceVs = list(livevars(bbs)[loop.loop_paths[0][0]])
    trace_enasmble = [ [ { varName: env[varName] for varName in traceVs }
                       for env in tr ]
                     for tr in trace_enasmble ]

    if (invVars == None):
        invVars = traceVs

    invs_lst = [ reduce(lambda x,y: x+y,
                        [ instantiateAndEval(inv, trace, invVars, invConsts)
                            for inv in invs ],
                        [])
                 for trace in trace_enasmble if len(trace) > 0 ]

    tmp_lst = [ (len(invs), invs, tr)
                for (invs, tr) in zip(invs_lst, trace_enasmble) ]

    tmp_lst.sort(key=lambda t:  t[0]);
    return (tmp_lst[0][2], False)


def findNegatingTrace(loop, bbs, nunrolls, invs, invVrs = None):
    from vc_check import loopInvOverfittedCtrex
    vals, terminates = _tryUnroll(loop, bbs, 0, nunrolls, None, None)
    traceVs = list(livevars(bbs)[loop.loop_paths[0][0]])
    vals = [ { x : env[x] for x in traceVs } for env in vals ]
    hold_for_data = []

    if (invVrs == None):
        invVrs = traceVs

    def diversity(vals):
        lsts = [ [ vals[i][k] for i in range(len(vals)) ]
                 for k in vals[0].keys() ]
        return average([len(set(lst)) for lst in lsts])
        #return average([len(set(lst)) / 1.0 * len(lst) for lst in lsts])

    for inv in invs:
        hold_for_data.extend(instantiateAndEval(inv, vals, invVrs,
                                                ["_sc_a", "_sc_b", "_sc_c"]))

    print("The following invariants hold for initial trace: ", hold_for_data)
    hold_for_data = list(set(hold_for_data))
    print("The following remain after clearing duplicates: ", hold_for_data)
    res = [ ]
    no_ctrex = set([])
    for s in powerset(hold_for_data):
        if (s.issubset(no_ctrex)):
            continue
        #print "Looking for ctrex for: ", s, " with no_ctrex: ", no_ctrex
        inv = ast_or(s)
        ctrexs = loopInvOverfittedCtrex(loop, inv, bbs)
        if (len(ctrexs) > 0):
            for ctrex in ctrexs:
              trace, terminates = \
                      _tryUnroll(loop, bbs, 0, nunrolls, None, ctrex)
              if (len(trace) > 0):
                  print("Ctrexample for ", inv, " is ", trace)
                  res.append((diversity(trace), len(s), list(s),
                              ctrex, (trace, terminates)))
        else:
            no_ctrex = no_ctrex.union(s)

    res.sort(key=lambda x:  x[0]);
    if (len(res) > 0):
        return res[-1][4]
    else:
        return (None, False)

def readTrace(fname: str) -> Tuple[List[str], List[Store]]:
    trace = open(fname, "r").read();
    lines = [x for x in [x.strip() for x in trace.split('\n')] if len(x) != 0] # type: List[str]
    vs = [x for x in lines[0].split(' ') if len(x) != 0] # type: List[str]
    header_vals = [ ] # type: List[Store]
    for l in lines[1:]:
        if (l[0] == '#'):
            continue;

        env = { } # type: Store
        for (var,val) in zip(vs, [x for x in l.split(' ') if len(x) != 0]):
            env[var] = int(val)  # TODO: Support traces involving non-integer values
        header_vals.append(env);
    return (vs, header_vals)

def writeTrace(fname: str, header_vals: List[Store]) -> None:
    f = open(fname, "w");

    if (len(header_vals) != 0):
      vs = list(header_vals[0].keys());
      f.write(" ".join(vs) + "\n");
      for env in header_vals:
        f.write(" ".join([str(env[v]) for v in vs]) + "\n")

    f.close();


Loops_T = Dict[Label_T, Set[Path]]

class BoogieLevel(object):
    @staticmethod
    def load(fname: str) -> "BoogieLevel":
        fun = [f.split_asserts()[0] for f in Function.load(fname)]
        # TODO: Support multiple functions
        loops = BoogieLevel._discover_loops(unique(fun))
        traces = [] # type: List[List[Store]]
        vars = [] # type: List[str]
        try:
            (vars, trace) = readTrace(fname[:-4] + ".trace");
            traces = [trace];
        except: pass
        return BoogieLevel(fname, fun, loops, traces, vars, "")

    @staticmethod
    def load_answer(fname: str) -> InvNetwork:
        json = load(open(fname, 'r'))
        assert isinstance(json, dict)
        res = {} # type: InvNetwork
        for (k, v) in json.items():
            assert isinstance(k, Label_T)
            if isinstance(v, str):
                invs = [v]
            else:
                assert isinstance(v, list)
                invs = v
            res[k] = set([parseExprAst(x) for x in invs])
        return res

    def __init__(self, fname: str, funs: Iterable[Function], loops: Loops_T, traces: List[List[Store]], vars: List[str], hint: str) -> None:
        self._fname = fname
        # TODO: Support multiple functions
        self._fun = unique(funs)
        self._loops = loops
        self._vars = vars # type: List[str]
        self._traces = traces # type: List[List[Store]]
        self._hint = hint

    @staticmethod
    def _discover_loops(f: Function) -> Loops_T:
        """ This code assumes that the function static control flow is well structured. Specifically:
            1. Each loop has a unique loop header BB.
            2. Each loop has a unique loop exit BB. All paths out of the loop go through E
            3. Each branch is only 2 way
            4. Each branch has a single unique join. 

            For our purposes, a loop is just a list of simple paths, starting
            and ending at the same header node. A loop is uniquely identified
            by its header node label.
        """
        loops = {} # type: Loops_T
        def _dfs(bb: BB, path: List[BB]) -> None:
            #print ("_dfs({}, {})".format(bb, path))
            if bb in path:
                loop_path = path[path.index(bb):] + [bb]
                prefix = path[:path.index(bb)]
                if bb.label not in loops:
                    loops[bb.label] = set([Path(loop_path)])
                else:
                    loops[bb.label].add(Path(loop_path))
                return

            for next_bb in bb.successors():
                _dfs(next_bb, path + [bb])

        _dfs(f.entry(), [])
        return loops

    def to_json(self) -> Any:
        return [
            self._fname,
            self._fun.to_json(),
            {lbl: [[bb.label for bb in path] for path in paths] for (lbl, paths) in self._loops.items()},
            self._vars,
            self._traces
        ]

def loadNewBoogieLvlSet(lvlSetFile):
    # Small helper funct to make sure we didn't
    # accidentally give two levels the same name
    def assertUniqueKeys(kvs):
      keys = [x[0] for x in kvs]
      assert (len(set(keys)) == len(keys))
      return dict(kvs)

    lvlSet = load(open(lvlSetFile, "r"), object_pairs_hook=assertUniqueKeys)
    lvlSetDir = dirname(abspath(realpath(lvlSetFile)))
    error("Loading level set " + lvlSet["name"] + " from " + lvlSetFile);
    lvls = OrderedDict()
    for t in lvlSet["levels"]:
        lvlName = t[0]
        lvlPath = t[1]

        for i in range(len(lvlPath)):
          lvlPath[i] = join(lvlSetDir, lvlPath[i])

        error("Loading level: ", lvlPath[0])
        lvl = BoogieLevel.load(lvlPath[0])
        assert lvl._fun.is_gcl();
        lvls[lvlName] = lvl

    return (lvlSet["name"], lvls)



def loadBoogieFile(fname: str):
    bbs = get_bbs(fname)
    ensureSingleExit(bbs);
    loop = unique(loops(bbs),
                  "Cannot handle program with multiple loops:" + fname)

    # The variables to trace are all live variables at the loop header
    vs = list(livevars(bbs)[loop.loop_paths[0][0]])

    # Make sure variable names are different modulo case
    assert len(vs) == len(set([var.lower() for var in vs]))

    # See if there is a .trace or a .hint file
    hint = None
    header_vals = None;
    terminates = False;
    try:
        (vs, header_vals) = readTrace(fname[:-4] + '.trace')
        hint = load(open(fname[:-4] + '.hint'))
    except Exception: #TODO (Dimo) IOError here instead?
        pass

    if (not header_vals):
        header_vals, terminates = [], False
        writeTrace(fname[:-4] + ".trace", new_header_vals);

    return { 'variables': vs,
             'data': [ [[ str(row[v]) for v in vs  ] for row in header_vals],
                       [],
                       [] ],
             'exploration_state' : [ ( [str(header_vals[0][v]) for v in vs],
                                       len(header_vals),
                                       terminates ) ],
             'hint': hint,
             'goal' : { "verify" : True },
             'support_pos_ex' : True,
             'support_neg_ex' : True,
             'support_ind_ex' : True,
             'program' : bbs,
             'loop' : loop
    }

def loadBoogieLvlSet(lvlSetFile):
    # Small helper funct to make sure we didn't
    # accidentally give two levels the same name
    def assertUniqueKeys(kvs):
      keys = [x[0] for x in kvs]
      assert (len(set(keys)) == len(keys))
      return dict(kvs)

    lvlSet = load(open(lvlSetFile, "r"), object_pairs_hook=assertUniqueKeys)
    lvlSetDir = dirname(abspath(realpath(lvlSetFile)))
    error("Loading level set " + lvlSet["name"] + " from " + lvlSetFile);
    lvls = OrderedDict()
    for t in lvlSet["levels"]:
        lvlName = t[0]
        lvlPath = t[1]

        for i in range(len(lvlPath)):
          lvlPath[i] = join(lvlSetDir, lvlPath[i])
            
        error("Loading level: ", lvlPath[0])
        lvl = loadBoogieFile(lvlPath[0], False)
        lvl["path"] = lvlPath

        if (len(t) > 2):
          splitterPreds = [ parseExprAst(exp) for exp in t[2] ]
          splitterPred = ast_and(splitterPreds)
          remainderInv = parseExprAst(t[3])

          lvl['data'][0] = [row for row in lvl['data'][0] if evalPred(splitterPred, _to_dict(lvl['variables'], row))];

          if (len(lvl['data'][0]) == 0):
            error("SKIPPING : ", lvlName, " due to no filtered rows.")
            continue

          lvl['partialInv'] = remainderInv
          lvl['splitterPreds'] = splitterPreds

        lvls[lvlName] = lvl;

    return (lvlSet["name"], lvls)
