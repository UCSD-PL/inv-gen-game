from flask import Flask
from flask import request
from flask_jsonrpc import JSONRPC as rpc
from os.path import *
from os import listdir
from json import load, dumps 
from z3 import *
from js import invJSToZ3, addAllIntEnv, esprimaToZ3, esprimaToBoogie, boogieToEsprima
from boogie_ast import parseAst, AstBinExpr, AstTrue, AstUnExpr, parseExprAst,\
    ast_and, ast_or, replace, expr_read
from boogie_bb import get_bbs
from boogie_loops import loops, get_loop_header_values, \
  loop_vc_pre_ctrex, loop_vc_post_ctrex, loop_vc_ind_ctrex
from util import unique, pp_exc, powerset, average, split
from boogie_analysis import livevars
from boogie_eval import instantiateAndEval
from boogie_z3 import expr_to_z3, AllIntTypeEnv, ids, z3_expr_to_boogie
from boogie_paths import sp_nd_ssa_path, nd_bb_path_to_ssa, wp_nd_ssa_path
from boogie_ssa import SSAEnv
from graph import strongly_connected_components, collapse_scc, topo_sort
from logic import implies, equivalent, tautology
from sys import exc_info

import argparse
import traceback
import time
from copy import copy

p = argparse.ArgumentParser(description="invariant gen game server")
p.add_argument('--log', type=str, help='an optional log file to store all user actions. Entries are stored in JSON format.')

args = p.parse_args();

logF = None;
if args.log:
    logF = open(args.log,'w')

def log(action):
    action['time'] = time.time()
    action['ip'] = request.remote_addr;
    if (logF):
        logF.write(dumps(action) + '\n')
    else:
        print dumps(action) + '\n'

def log_d(f):
    def decorated(*args, **kwargs):
        try:
            res = f(*args, **kwargs)
            log({ "method": f.__name__, "args": args, "kwargs": kwargs, "res": res })
            return res;
        except Exception,e:
            log({ "method": f.__name__, "args": args, "kwargs": kwargs,
                  "exception": ''.join(traceback.format_exception(*exc_info()))})
            raise
    return decorated


MYDIR=dirname(abspath(realpath(__file__)))
z3s = Solver()

def _tryUnroll(loop, bbs, min_un, max_un, bad_envs, good_env):
    # Lets first try to find a terminating loop between min and max iterations
    term_vals = get_loop_header_values(loop, bbs, min_un, max_un, bad_envs, good_env, True)
    if (term_vals != []):
      return (term_vals, True)

    # Couldn't find a terminating loop between 0 and 6 iteration. Lets find
    # a loop that has at LEAST min iterations
    term_vals = get_loop_header_values(loop, bbs, min_un, max_un, bad_envs, good_env, False)
    return (term_vals, False)

def findNegatingTrace(loop, bbs, nunrolls, invs):
    vals, terminates = _tryUnroll(loop, bbs, 0, nunrolls, None, None)
    traceVs = list(livevars(bbs)[loop.loop_paths[0][0]])
    vals = [ { x : env[x] for x in traceVs } for env in vals ]
    hold_for_data = []

    def diversity(vals):
        lsts = [ [ vals[i][k] for i in xrange(len(vals)) ] for k in vals[0].keys() ]
        return average([len(set(lst)) for lst in lsts])
        #return average([len(set(lst)) / 1.0 * len(lst) for lst in lsts])

    for inv in invs:
        hold_for_data.extend(instantiateAndEval(inv, vals, traceVs, ["a", "b", "c"]))

    print "The following invariants hold for initial trace: ", hold_for_data
    res = [ ]
    for s in powerset(hold_for_data):
        inv = ast_or(s)
        ctrex = loop_vc_pre_ctrex(loop, inv, bbs)
        trace, terminates = _tryUnroll(loop, bbs, 0, nunrolls, None, ctrex)
        if (ctrex and len(trace) > 0):
            print "Ctrexample for ", inv, " is ", trace
            res.append((diversity(trace), len(s), list(s), ctrex, (trace, terminates)))

    res.sort(key=lambda x:  x[0]);
    if (len(res) > 0):
        return res[-1][4]
    else:
        return (None, False)

def loadBoogieFile(fname, multiround):
    bbs = get_bbs(fname)
    loop = unique(loops(bbs), "Cannot handle program with multiple loops:" + fname)
    header_vals, terminates = _tryUnroll(loop, bbs, 0, 4, None, None)
    # Assume we have no tests with dead loops
    assert(header_vals != [])
    #header_vals, terminates = findNegatingTrace(loop, bbs, 4,
    #  [ parseExprAst(inv)[0] for inv in ["x<y", "x<=y", "x==c", "x==y", "x==0"] ])

    # See if there is a .hint files
    hint = None
    try:
        hint = open(fname[:-4] + '.hint').read()
    except: pass

    # The variables to trace are all live variables at the loop header
    vs = list(livevars(bbs)[loop.loop_paths[0][0]])

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

def readTrace(fname):
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
    return { name[:-4] : readTrace(dirN + '/' + name) for name in listdir(dirN)
                if name.endswith('.out') }

introTraces = loadTraces(MYDIR + '/../intro-benchmarks')
testTraces = loadTraces(MYDIR + '/../test-benchmarks')
prunedIntroTraces = loadTraces(MYDIR + '/../intro-benchmarks-pruned')

traces = {
    "intro-benchmarks": introTraces,
    "test-benchmarks": testTraces,
    "pruned-intro-benchmarks": prunedIntroTraces,
    "desugared-boogie-benchmarks" : loadBoogies(MYDIR + '/../desugared-boogie-benchmarks', False),
    "old-dilig-traces": {
      '15-c': {
          'variables': ['n', 'k', 'j'],
          'data': [
              [7, 9, 0],
              [7, 8, 1],
              [7, 7, 2],
              [7, 6, 3],
              [7, 5, 4],
              [7, 4, 5],
              [7, 3, 6],
              [7, 2, 7]
          ]
      },

      '19-c': {
          'variables': ['n', 'm', 'x', 'y'],
          'data': [
              [7, 3, 0, 3],
              [7, 3, 1, 3],
              [7, 3, 2, 3],
              [7, 3, 3, 3],
              [7, 3, 4, 4],
              [7, 3, 5, 5],
              [7, 3, 6, 6],
          ]
      },

      '25-c outer loop': {
          'variables': ['x', 'y', 'i', 'j'],
          'data': [
              [0, 0, 0, 0],
              [1, 1, 4, 0],
              [2, 2, 8, 0],
              [3, 3, 12, 0],
          ]
      },

      '25-c inner loop': {
          'variables': ['x', 'y', 'i', 'j'],
          'data': [
              [0, 0, 0, 0],
              [0, 0, 1, 0],
              [0, 0, 2, 0],
              [0, 0, 3, 0],
              [1, 1, 4, 0],
              [1, 1, 5, 0],
              [1, 1, 6, 0],
              [1, 1, 7, 0],
              [2, 2, 8, 0],
              [2, 2, 9, 0],
              [2, 2, 10, 0],
              [2, 2, 11, 0],
              [3, 3, 12, 0],
              [3, 3, 13, 0],
              [3, 3, 14, 0],
              [3, 3, 15, 0],
          ]
      },
  }
}

class Server(Flask):
    def get_send_file_max_age(self, name):
        if (name in [ 'jquery-1.12.0.min.js', 'jquery-migrate-1.2.1.min.js', 'jquery.jsonrpcclient.js']):
            return 100000

        return 0

app = Server(__name__, static_folder='static/', static_url_path='')
api = rpc(app, '/api')

@api.method("App.listData")
@pp_exc
@log_d
def listData(levelSet):
    res = traces[levelSet].keys();
    res.sort()
    return res

@api.method("App.loadLvl")
@pp_exc
@log_d
def loadLvl(levelSet, traceId):
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + levelSet)

    if (traceId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + traceId + " in levels " + levelSet)

    lvl = traces[levelSet][traceId]
    if ('program' in lvl):
      # This is a boogie level - don't return the program/loop and other book keeping
      lvl = {
             'variables': lvl['variables'],
             'data': lvl['data'],
             'exploration_state': lvl['exploration_state'],
             'hint': lvl['hint'],
             'goal' : lvl['goal'],
             'support_pos_ex' : lvl['support_pos_ex'],
             'support_neg_ex' : lvl['support_neg_ex'],
             'support_ind_ex' : lvl['support_ind_ex'],
             'multiround'     : lvl['multiround'],
      }
  
    return lvl

def _to_dict(vs, vals):
    return { vs[i]: vals[i] for i in xrange(0, len(vs)) }

def _from_dict(vs, vals):
    if type(vals) == tuple:
        return ( _from_dict(vs, vals[0]), _from_dict(vs, vals[1]) )
    else:
        return [ vals[vs[i]].as_long() if vs[i] in vals else None for i in xrange(0, len(vs)) ]

@api.method("App.instantiate")
@pp_exc
def instantiate(invs, traceVars, trace):
    res = []
    z3Invs = []
    boogieInvs = [ (x[1], esprimaToBoogie(x[0], {})) for x in invs]
    vals = map(lambda x:    _to_dict(traceVars, x), trace)

    for (constVars, bInv) in boogieInvs:
        for instInv in instantiateAndEval(bInv, vals, traceVars, constVars):
            instZ3Inv = expr_to_z3(instInv, AllIntTypeEnv())
            implied = False
            z3Inv = None

            for z3Inv in z3Invs:
                if implies(z3Inv, instZ3Inv):
                    implied = True;
                    break

            if (implied):   continue
            res.append(instInv)
            z3Invs.append(instZ3Inv)

    return map(lambda x: boogieToEsprima(x), res)
    
@api.method("App.getPositiveExamples")
@pp_exc
@log_d
def getPositiveExamples(levelSet, levelId, cur_expl_state, overfittedInvs, num):
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + str(levelSet))

    if (levelId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + str(levelId) + " in levels " + str(levelSet))

    lvl = traces[levelSet][levelId]

    if ('program' not in lvl):
      # Not a boogie level - error
      raise Exception("Level " + str(levelId) + " " + str(levelSet) + " not a dynamic boogie level.")

    bbs = lvl['program']
    loop = lvl["loop"]
    found = []
    need = num
    heads = set([tuple(x[0]) for x in cur_expl_state])
    overfitBoogieInvs = [esprimaToBoogie(x, {}) for x in overfittedInvs]
    negatedVals, terminates = findNegatingTrace(loop, bbs, num, overfitBoogieInvs)
    print "Negated vals: ", negatedVals

    if (negatedVals):
        cur_expl_state.insert(0, (_from_dict(lvl['variables'], negatedVals[0]), 0, False))

    print cur_expl_state

    for (ind, (loop_head, nunrolls, is_finished)) in enumerate(cur_expl_state):
        if is_finished: continue
        if need <= 0:   break

        print "Getting values from ", ind

        good_env = _to_dict(lvl['variables'], loop_head)
        # Lets first try to find terminating executions:
        new_vals, terminating = _tryUnroll(loop, bbs, nunrolls+1, nunrolls+1+need, None, good_env)
        new_vals = new_vals[nunrolls+1:]
        cur_expl_state[ind] = (loop_head, nunrolls + len(new_vals), terminating)
    
        found.extend(new_vals)
        need -= len(new_vals)

    while need > 0:
        bad_envs = [ _to_dict(lvl['variables'], row) for (row,_,_) in cur_expl_state ]
        new_vals, terminating = _tryUnroll(loop, bbs, 0, need, bad_envs, None)
        found.extend(new_vals)
        need -= len(new_vals)
        cur_expl_state.append((_from_dict(lvl['variables'], new_vals[0]), len(new_vals)-1, terminating))

    # De-z3-ify the numbers
    js_found = [ _from_dict(lvl["variables"], env) for env in found]
    return (copy(cur_expl_state), js_found)

@api.method("App.equivalentPairs")
@pp_exc
@log_d
def equivalentPairs(invL1, invL2):
    z3InvL1 = [esprimaToZ3(x, {}) for x in invL1]
    z3InvL2 = [esprimaToZ3(x, {}) for x in invL2]

    res = [(x,y) for x in z3InvL1 for y in z3InvL2 if equivalent(x, y)]
    res = [(boogieToEsprima(z3_expr_to_boogie(x)),
            boogieToEsprima(z3_expr_to_boogie(y))) for (x,y) in res]
    return res

@api.method("App.impliedPairs")
@pp_exc
@log_d
def impliedPairs(invL1, invL2):
    z3InvL1 = [esprimaToZ3(x, {}) for x in invL1]
    z3InvL2 = [esprimaToZ3(x, {}) for x in invL2]

    res = [(x,y) for x in z3InvL1 for y in z3InvL2 if implies(x, y)]
    res = [(boogieToEsprima(z3_expr_to_boogie(x)),
            boogieToEsprima(z3_expr_to_boogie(y))) for (x,y) in res]
    return res

@api.method("App.isTautology")
@pp_exc
@log_d
def isTautology(inv):
    res = (tautology(esprimaToZ3(inv, {})))
    return res

@api.method("App.verifyInvariants")
@pp_exc
@log_d
def verifyInvariants(levelSet, levelId, invs):
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + str(levelSet))

    if (levelId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + str(levelId) + " in levels " + str(levelSet))

    if (len(invs) == 0):
        raise Exception("No invariants given")

    lvl = traces[levelSet][levelId]

    if ('program' not in lvl):
      # Not a boogie level - error
      raise Exception("Level " + str(levelId) + " " + str(levelSet) + " not a dynamic boogie level.")

    boogie_invs = [ esprimaToBoogie(x, {}) for x in invs ]
    bbs = lvl['program']
    loop = lvl['loop']

    # Lets use checkInvs_impl to determine which invariants are sound/overfitted/inductive
    print boogie_invs
    overfitted, nonind, sound = checkInvs_impl(bbs, loop, boogie_invs)

    # Finally see if the sound invariants imply the postcondition. Don't forget to
    # convert any counterexamples from {x:1, y:2} to [1,2]
    fix = lambda x: _from_dict(lvl['variables'], x)
    boogie_inv = ast_and(sound)
    post_ctrex = map(fix, filter(lambda x:    x, [ loop_vc_post_ctrex(loop, boogie_inv, bbs) ]))
    
    # Convert all invariants from Boogie to esprima expressions, and counterexamples to arrays
    # from dictionaries
    overfitted = [ (boogieToEsprima(inv), fix(ctrex)) for (inv, ctrex) in overfitted ]
    nonind = [ (boogieToEsprima(inv), map(fix, ctrex)) for (inv, ctrex) in nonind ]
    sound = [ boogieToEsprima(inv) for inv in sound ]
    res = (overfitted, nonind, sound, post_ctrex)
    return res

def getInfluenceGraph(invs, loop, bbs):
    body_ssa, ssa_env = nd_bb_path_to_ssa([ loop.loop_paths ], bbs, SSAEnv(None, ""))
    inv_wps = [ wp_nd_ssa_path(body_ssa, bbs,
                              expr_to_z3(replace(x, ssa_env.replm()), AllIntTypeEnv()),
                              AllIntTypeEnv())
                for x in invs ]
    infl_vars = [ set(ids(x)) for x in inv_wps ]
    expr_vars = [ expr_read(x) for x in invs ]
    influences = { i : set() for i in xrange(len(invs)) }

    for i in xrange(len(invs)):
        for j in xrange(len(invs)):
            if (i == j):    continue
            if len(infl_vars[i].intersection(expr_vars[j])) > 0:
                # Expression j influences the outcome of expression i
                influences[i].add(j)

    return influences;

# TODO: Make this incremental
def checkInvs_impl(bbs, loop, invs):
    # 0. First get the overfitted invariants out of the way. We can check overfitted-ness
    #    individually for each invariant.
    pre_ctrexs = map(lambda inv:    (inv, loop_vc_pre_ctrex(loop, inv, bbs)), invs)
    overfitted, rest = split(lambda ((inv, ctrex)): ctrex != None, pre_ctrexs)
    rest = map(lambda x:    x[0], rest)

    # 1. Build an influences graph of the left-over invariants
    inflGraph = getInfluenceGraph(rest, loop, bbs)
    print "invs: ", invs 
    print "Overfitted: ", map(lambda x: x[0], overfitted)

    print "rest: ", rest
    print "inflGraph: ", inflGraph

    # 2. Build a collapsed version of the graph
    sccs = strongly_connected_components(inflGraph) 
    print "sccs: ", sccs;

    # 3. Sort collapsed graph topologically
    collapsedInflGraph = collapse_scc(inflGraph, sccs)
    print "collapsed infl graph: ", collapsedInflGraph

    # 5. For each collapsed s.c.c in topo order (single invariants can be viewed as a s.c.c with 1 elmnt.)
    check_order = topo_sort(collapsedInflGraph)
    print "Check order ind: comp: ", check_order

    sound_invs = set()
    nonind_ctrex = { }
    # TODO: Opportunities for optimization: Some elements can be viewed
    # in parallel. To do so - modified bfs on the influences graph
    for scc in map(lambda i:    sccs[i], check_order):
        # 5.1 For all possible subsets of s.c.c.
        for subset in powerset(scc):
            if (len(subset) == 0):  continue
            # TODO: Opportunity for optimization: If you find a sound invariant in a s.c.c, can you break up the s.c.c
            #       And re-sort just the s.c.c topologically? Thus reduce the complexity?
            # TODO: Should we order the possible subsets in increasing size?
            inv_subs = [ rest[x] for x in subset ]
            conj = ast_and(list(sound_invs) + inv_subs)
            ind_ctrex = loop_vc_ind_ctrex(loop, conj, bbs)
            # If conjunction is inductive:
            print conj, ind_ctrex
            if (not ind_ctrex):
                # Add all invariants in conj. in sound set.
                print inv_subs, "is inductive"
                for inv in inv_subs:
                    sound_invs.add(inv)
            else:
                if (len(inv_subs) == 1):
                    nonind_ctrex[inv_subs[0]] = ind_ctrex

    # 6. Label remainder as non-inductive
    nonind_invs = [ ]
    overfitted_set = set([ x[0] for x in overfitted ])

    for inv in invs:
        if inv not in overfitted_set and inv not in sound_invs:
            nonind_invs.append((inv, nonind_ctrex[inv]))

    return overfitted, nonind_invs, sound_invs
    
@api.method("App.checkInvs")
@pp_exc
@log_d
def checkInvs(levelSet, levelId, invs):
    """ See checkInvs_impl
    """
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + str(levelSet))

    if (levelId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + str(levelId) + " in levels " + str(levelSet))

    if (len(invs) == 0):
        raise Exception("No invariants given")

    lvl = traces[levelSet][levelId]

    if ('program' not in lvl):
      # Not a boogie level - error
      raise Exception("Level " + str(levelId) + " " + str(levelSet) + " not a dynamic boogie level.")

    print invs
    bbs = lvl['program']
    loop = lvl['loop']
    boogie_invs = [ esprimaToBoogie(x, {}) for x in invs ]
    overfitted, nonind, sound = checkInvs_impl(bbs, loop, boogie_invs)

    fix = lambda x: _from_dict(lvl['variables'], x)
    overfitted = map(lambda x:  (boogieToEsprima(x[0]), fix(x[1])), overfitted)
    nonind = map(lambda x:  (boogieToEsprima(x[0]), (fix(x[1][0]), fix(x[1][1]))), nonind)
    sound = map(lambda x:   boogieToEsprima(x), sound)
    print (overfitted, nonind, sound)

    return (overfitted, nonind, sound)

@api.method("App.simplifyInv")
@pp_exc
@log_d
def simplifyInv(inv):
    z3_inv = esprimaToZ3(inv, {});
    simpl_z3_inv = simplify(z3_inv, arith_lhs=True);
    return boogieToEsprima(z3_expr_to_boogie(simpl_z3_inv));

if __name__ == "__main__":
    app.run(host='0.0.0.0')
