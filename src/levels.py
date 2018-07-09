from pyboogie.ast import parseExprAst, ast_or, ast_and
from pyboogie.bb import get_bbs, ensureSingleExit, bbEntry
from boogie_loops import loops, get_loop_header_values
from lib.common.util import unique, powerset, average, error
from pyboogie.analysis import livevars
from pyboogie.eval import instantiateAndEval, evalPred, _to_dict
from collections import OrderedDict
from os import listdir
from os.path import dirname, join, abspath, realpath
from json import load, dumps
from vc_check import loopInvOverfittedCtrex
from functools import reduce

def readTrace(fname):
    trace = open(fname, "r").read();
    lines = [x for x in [x.strip() for x in trace.split('\n')] if len(x) != 0]
    vs = [x for x in lines[0].split(' ') if len(x) != 0]
    header_vals = [ ]
    for l in lines[1:]:
        if (l[0] == '#'):
            continue;

        env = { }
        for (var,val) in zip(vs, [x for x in l.split(' ') if len(x) != 0]):
            env[var] = val
        header_vals.append(env);
    return (vs, header_vals)

def writeTrace(fname, header_vals):
    f = open(fname, "w");

    if (len(header_vals) != 0):
      vs = list(header_vals[0].keys());
      f.write(" ".join(vs) + "\n");
      for env in header_vals:
        f.write(" ".join([str(env[v]) for v in vs]) + "\n")

    f.close();

#TODO: Remove multiround. Its crud.
def loadBoogieFile(fname, multiround):
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

    assert (header_vals is not None)
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
             'multiround'     : multiround,
             'program' : bbs,
             'loop' : loop
    }

def readTraceOnlyLvl(fname):
    rows = []
    first = True
    for l in open(fname):
        l = l.strip();
        if (l == ''):
            continue
        row = {}
        for (n,v) in [x.split('=') for x in l.split(' ')]:
            row[n] = v

        if (first):
          vs = [x.split('=')[0] for x in l.split(' ')]
          first = False;
        rows.append(row)

    hint = None
    goal = None
    try:
        goal = load(open(fname[:-4] + '.goal'))
        hint = open(fname[:-4] + '.hint').read()
    except Exception:
        pass

    return { 'variables': vs,
             'data': [[[ row.get(n, None) for n in vs  ]  for row in rows ],
                      [],
                      []],
             'hint': hint,
             'goal' : goal,
             'support_pos_ex' : False,
             'support_neg_ex' : False,
             'support_ind_ex' : False,
             'multiround'     : False,
    }

def loadTraces(dirN):
    return { name[:-4] : readTraceOnlyLvl(dirN + '/' + name)
             for name in listdir(dirN) if name.endswith('.out') }

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
