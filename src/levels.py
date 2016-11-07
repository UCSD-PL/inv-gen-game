from boogie.ast import parseExprAst, ast_or, ast_and
from boogie.bb import get_bbs, ensureSingleExit, entry
from boogie_loops import loops, get_loop_header_values, loop_vc_pre_ctrex
from util import unique, powerset, average
from boogie.analysis import livevars
from boogie.eval import instantiateAndEval, evalPred, _to_dict, execute
from os import listdir
from os.path import dirname, join, abspath, realpath
from json import load, dumps
from random import randint

def _tryUnroll(loop, bbs, min_un, max_un, bad_envs, good_env):
    # Lets first try to find a terminating loop between min and max iterations
    term_vals = get_loop_header_values(loop, bbs, min_un, max_un, bad_envs, good_env, True)
    if (term_vals != []):
      return (term_vals, True)

    # Couldn't find a terminating loop between 0 and 6 iteration. Lets find
    # a loop that has at LEAST min iterations
    term_vals = get_loop_header_values(loop, bbs, min_un, max_un, bad_envs, good_env, False)
    return (term_vals, False)

def getEnsamble(loop, bbs, exec_limit, tryFind = 100, distr = lambda:  randint(0,5)):
    traceVs = list(livevars(bbs)[loop.loop_paths[0][0]])
    ensamble = []
    tried = set();
    #TODO: Not a smart way for generating random start values. Fix.
    s = 0
    while s < tryFind:
        print "Try ", s
        candidate = tuple([ distr() for x in traceVs ])
        if (candidate in tried):
            continue

        tried.add(candidate)

        candidate = { x : candidate[i] for (i,x) in enumerate(traceVs) }
        found = False
        for (_,_,_,_,vals) in execute(candidate, entry(bbs), bbs, exec_limit):
          print "FOUND!"
          ensamble.append(vals)
          found = True;
          s += 1
          if (s >= tryFind):
            break;

        if (not found): s += 1;

    return ensamble

def getInitialData(loop, bbs, nunrolls, invs, invVars = None, invConsts = ["a", "b", "c"]):
    trace_enasmble = getEnsamble(loop, bbs, nunrolls, 100);
    vals, terminates = _tryUnroll(loop, bbs, 0, nunrolls, None, None)
    if (vals):
        trace_enasmble.append(vals)
    
    traceVs = list(livevars(bbs)[loop.loop_paths[0][0]])
    trace_enasmble = [ [ { varName: env[varName] for varName in traceVs }
                       for env in tr ]
                     for tr in trace_enasmble ]

    if (invVars == None):
        invVars = traceVs

    hold_for_data = []
    invs_lst = [ reduce(lambda x,y: x+y, 
                        [ instantiateAndEval(inv, trace, invVars, invConsts) for inv in invs ], [])
                 for trace in trace_enasmble ]

    tmp_lst = [ (len(invs), invs, tr) for (invs, tr) in zip(invs_lst, trace_enasmble) ]

    tmp_lst.sort(key=lambda t:  t[0]);
    return (tmp_lst[0][2], False)


def findNegatingTrace(loop, bbs, nunrolls, invs, invVrs = None):
    vals, terminates = _tryUnroll(loop, bbs, 0, nunrolls, None, None)
    traceVs = list(livevars(bbs)[loop.loop_paths[0][0]])
    vals = [ { x : env[x] for x in traceVs } for env in vals ]
    hold_for_data = []

    if (invVrs == None):
        invVrs = traceVs

    def diversity(vals):
        lsts = [ [ vals[i][k] for i in xrange(len(vals)) ] for k in vals[0].keys() ]
        return average([len(set(lst)) for lst in lsts])
        #return average([len(set(lst)) / 1.0 * len(lst) for lst in lsts])

    for inv in invs:
        hold_for_data.extend(instantiateAndEval(inv, vals, invVrs, ["a", "b", "c"]))

    print "The following invariants hold for initial trace: ", hold_for_data
    hold_for_data = list(set(hold_for_data))
    print "The following remain after clearing duplicates: ", hold_for_data
    res = [ ]
    no_ctrex = set([])
    for s in powerset(hold_for_data):
        if (s.issubset(no_ctrex)):
            continue
        #print "Looking for ctrex for: ", s, " with no_ctrex: ", no_ctrex
        inv = ast_or(s)
        ctrex = loop_vc_pre_ctrex(loop, inv, bbs)
        if (ctrex):
            trace, terminates = _tryUnroll(loop, bbs, 0, nunrolls, None, ctrex)
            if (len(trace) > 0):
                print "Ctrexample for ", inv, " is ", trace
                res.append((diversity(trace), len(s), list(s), ctrex, (trace, terminates)))
        else:
            no_ctrex = no_ctrex.union(s)

    res.sort(key=lambda x:  x[0]);
    if (len(res) > 0):
        return res[-1][4]
    else:
        return (None, False)

def readTrace(fname):
    trace = open(fname, "r").read();
    lines = filter(lambda (x): len(x) != 0, map(lambda x:   x.strip(), trace.split('\n')))
    vs = filter(lambda x:   len(x) != 0, lines[0].split(' '))
    header_vals = [ ]
    for l in lines[1:]:
        if (l[0] == '#'):    continue;

        env = { }
        for (var,val) in zip(vs, filter(lambda x:   len(x) != 0, l.split(' '))):
            env[var] = val
        header_vals.append(env);
    return (vs, header_vals)

def writeTrace(fname, header_vals):
    f = open(fname, "w");

    if (len(header_vals) != 0):
      vs = header_vals[0].keys();
      f.write(" ".join(vs) + "\n");
      for env in header_vals:
        f.write(" ".join([str(env[v]) for v in vs]) + "\n")

    f.close();

#TODO: Remove multiround. Its crud.
def loadBoogieFile(fname, multiround):
    bbs = get_bbs(fname)
    ensureSingleExit(bbs);
    loop = unique(loops(bbs), "Cannot handle program with multiple loops:" + fname)

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
        hint = open(fname[:-4] + '.hint').read()
    except: 
        pass

    if (not header_vals):
        header_vals, terminates = _tryUnroll(loop, bbs, 0, 4, None, None)
        # Assume we have no tests with dead loops
        assert(header_vals != [])

        new_header_vals, new_terminates = getInitialData(loop, bbs, 4,
          [ parseExprAst(inv)[0] for inv in ["x<y", "x<=y", "x==c", "x==y", "x==0", "x<0"] ],
          [ "x", "y" ])

        if (new_header_vals != None):
            header_vals = new_header_vals
            terminates = new_terminates
            writeTrace(fname[:-4] + ".trace", new_header_vals);

    return { 'variables': vs,
             'data': [[[ str(row[v]) for v in vs  ]  for row in header_vals], [], []],
             'exploration_state' : [ ([ str(header_vals[0][v]) for v in vs  ], len(header_vals), terminates) ],
             'hint': hint,
             'goal' : { "verify" : True },
             'support_pos_ex' : True,
             'support_neg_ex' : True,
             'support_ind_ex' : True,
             'multiround'     : multiround,
             'program' : bbs,
             'loop' : loop
    }

def loadBoogies(dirN, multiround = False):
    return { name[:-4] : loadBoogieFile(dirN + '/' + name, multiround) for name in listdir(dirN)
                if name.endswith('.bpl') }

def readTraceOnlyLvl(fname):
    rows = []
    first = True
    for l in open(fname):
        l = l.strip();
        if (l == ''):   continue
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
    except: pass

    return { 'variables': vs,
             'data': [[[ row.get(n, None) for n in vs  ]  for row in rows ], [], []],
             'hint': hint,
             'goal' : goal,
             'support_pos_ex' : False,
             'support_neg_ex' : False,
             'support_ind_ex' : False,
             'multiround'     : False,
    }

def loadTraces(dirN):
    return { name[:-4] : readTraceOnlyLvl(dirN + '/' + name) for name in listdir(dirN)
                if name.endswith('.out') }

def loadBoogieLvlSet(lvlSetFile):
    lvlSet = load(open(lvlSetFile, "r"))
    lvlSetDir = dirname(abspath(realpath(lvlSetFile)))
    print "Loading level set " + lvlSet["name"] + " from " + lvlSetFile;
    lvls = {}
    for t in lvlSet["levels"]:
        lvlName = t[0]
        lvlPath = t[1]

        if lvlPath[0] != '/':
          lvlPath = join(lvlSetDir, lvlPath)
        print "Loading level: ", lvlPath
        lvl = loadBoogieFile(lvlPath, False)
        lvl["path"] = lvlPath

        if (len(t) > 2):
          splitterPreds = [ parseExprAst(exp)[0] for exp in t[2] ]
          splitterPred = ast_and(splitterPreds)
          remainderInv = parseExprAst(t[3])[0]

          lvl['data'][0] = filter(
            lambda row: evalPred(splitterPred, _to_dict(lvl['variables'], row)),
            lvl['data'][0]);

          lvl['partialInv'] = remainderInv
          lvl['splitterPreds'] = splitterPreds

        lvls[lvlName] = lvl;

    return (lvlSet["name"], lvls)