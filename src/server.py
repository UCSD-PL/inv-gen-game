from flask import Flask
from flask import request
from flask_jsonrpc import JSONRPC as rpc
from os.path import *
from os import listdir
from json import load, dumps 
from z3 import *
from js import invJSToZ3, addAllIntEnv, esprimaToZ3, esprimaToBoogie
from boogie_ast import parseAst, AstBinExpr, AstTrue, AstUnExpr
from boogie_bb import get_bbs
from boogie_loops import loops, get_loop_header_values, \
  loop_vc_pre_ctrex, loop_vc_post_ctrex, loop_vc_ind_ctrex
from util import unique, pp_exc, powerset
from boogie_analysis import livevars

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

def loadBoogieFile(fname):
    bbs = get_bbs(fname)
    loop = unique(loops(bbs), "Cannot handle program with multiple loops:" + fname)
    header_vals, terminates = _tryUnroll(loop, bbs, 0, 4, None, None)
    # Assume we have no tests with dead loops
    assert(header_vals != [])

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
             'program' : bbs,
             'loop' : loop
    }

def loadBoogies(dirN):
    return { name[:-4] : loadBoogieFile(dirN + '/' + name) for name in listdir(dirN)
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
             'data': [[[ row.get(n, None) for n in vs  ]  for row in rows ], None, None],
             'hint': hint,
             'goal' : goal,
             'support_pos_ex' : False,
             'support_neg_ex' : False,
             'support_ind_ex' : False,
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
    "desugared-boogie-benchmarks" : loadBoogies(MYDIR + '/../desugared-boogie-benchmarks'),
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
def listData(levelSet):
    res = traces[levelSet].keys();
    res.sort()
    return res

@api.method("App.loadLvl")
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
      }
  
    log({"type": "load_data", "data": lvl}) 
    return lvl

def _to_dict(vs, vals):
    return { vs[i]: vals[i] for i in xrange(0, len(vs)) }

def _from_dict(vs, vals):
    if type(vals) == tuple:
        return ( _from_dict(vs, vals[0]), _from_dict(vs, vals[1]) )
    else:
        return [ vals[vs[i]].as_long() if vs[i] in vals else None for i in xrange(0, len(vs)) ]

@api.method("App.getPositiveExamples")
@pp_exc
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

    for (ind, (loop_head, nunrolls, is_finished)) in enumerate(cur_expl_state):
        if is_finished: continue
        if need <= 0:   break

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
    log({"type": "getPositiveExamples", "data": (cur_expl_state, js_found)})
    return (copy(cur_expl_state), js_found)

def implies(inv1, inv2):
    s = Solver();
    s.add(inv1)
    s.add(Not(inv2))
    return unsat == s.check();

def equivalent(inv1, inv2):
    s = Solver();
    s.push();
    s.add(inv1)
    s.add(Not(inv2))
    impl = s.check();
    s.pop();

    if (impl != unsat):
      return False;

    s.push();
    s.add(Not(inv1))
    s.add(inv2)
    impl = s.check();
    s.pop();

    if (impl != unsat):
      return False;

    return True

def tautology(inv):
    s = Solver();
    s.add(Not(inv))
    return (unsat == s.check())

@api.method("App.equivalentPairs")
def equivalentPairs(invL1, invL2):
    try:
      z3InvL1 = list(enumerate([esprimaToZ3(x, {}) for x in invL1]))
      z3InvL2 = list(enumerate([esprimaToZ3(x, {}) for x in invL2]))

      res = [(x,y) for x in z3InvL1 for y in z3InvL2 if equivalent(x[1], y[1])]
      res = [(x[0], y[0]) for x,y in res]
      log({"type": "equivalentPairs", "data":  (invL1, invL2, res)})
      return res
    except:
      traceback.print_exc();
      traceback.print_tb(e);
      raise Exception(":(")

@api.method("App.impliedPairs")
def impliedPairs(invL1, invL2):
    try:
      z3InvL1 = list(enumerate([esprimaToZ3(x, {}) for x in invL1]))
      z3InvL2 = list(enumerate([esprimaToZ3(x, {}) for x in invL2]))

      res = [(x,y) for x in z3InvL1 for y in z3InvL2 if implies(x[1], y[1])]
      res = [(x[0], y[0]) for x,y in res]
      log({"type": "impliedPairs", "data":  (invL1, invL2, res)})
      return res
    except:
      traceback.print_exc();
      traceback.print_tb(e);
      raise Exception(":(")

@api.method("App.isTautology")
def isTautology(inv):
    res = (tautology(esprimaToZ3(inv, {})))
    log({"type": "isTautology", "data":  (inv, res)})
    return res

@api.method("App.verifyInvariants")
@pp_exc
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
    boogie_inv = reduce(lambda x, y:    AstBinExpr(x, '&&', y), boogie_invs[1:], boogie_invs[0])
    bbs = lvl['program']
    loop = lvl['loop']

    fix = lambda x: _from_dict(lvl['variables'], x)
    pre_ctrex = map(fix, filter(lambda x:    x, [ loop_vc_pre_ctrex(loop, boogie_inv, bbs) ]))
    post_ctrex = map(fix, filter(lambda x:    x, [ loop_vc_post_ctrex(loop, boogie_inv, bbs) ]))
    ind_ctrex = map(fix, filter(lambda x:    x, [ loop_vc_ind_ctrex(loop, boogie_inv, bbs) ]))
    res = (pre_ctrex, post_ctrex, ind_ctrex)

    log({"type": "verifyInvariant", "data": res })
    return res

if __name__ == "__main__":
    app.run(host='0.0.0.0')
