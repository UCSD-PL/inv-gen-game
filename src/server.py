#! /usr/bin/env python
from flask import Flask
from flask import request
from flask_jsonrpc import JSONRPC as rpc
from os.path import *
from json import dumps
from js import esprimaToZ3, esprimaToBoogie, boogieToEsprima
from lib.boogie.ast import AstBinExpr, AstTrue, ast_and
from lib.common.util import pp_exc, powerset, split, nonempty
from lib.boogie.eval import instantiateAndEval, _to_dict
from lib.boogie.z3_embed import expr_to_z3, AllIntTypeEnv, z3_expr_to_boogie
from sys import exc_info
from cProfile import Profile
from pstats import Stats
from StringIO import StringIO
from random import choice
from vc_check import tryAndVerify_impl, _from_dict

from levels import _tryUnroll, findNegatingTrace, loadBoogieLvlSet

import argparse
import traceback
import sys
from pp import *
from copy import copy
from colorama import Fore,Back,Style
from colorama import init as colorama_init
from time import time
from datetime import datetime
from models import open_sqlite_db, Event
from db_util import playersWhoStartedLevel, enteredInvsForLevel, getOrAddSource, addEvent,\
  levelSolved, levelFinishedBy

from nplayer_db import Login, Scores, Badges, open_db, addPlayerLogin, checkPlayerLogin, newPlayerScore, updatePlayerScore

colorama_init();

p = argparse.ArgumentParser(description="invariant gen game server")
p.add_argument('--log', type=str, help='an optional log file to store all user actions. Entries are stored in JSON format.')
p.add_argument('--port', type=int, help='a optional port number', required=True)
p.add_argument('--ename', type=str, default = 'default', help='Name for experiment; if none provided, use "default"')
p.add_argument('--lvlset', type=str, default = 'desugared-boogie-benchmarks', help='Lvlset to use for serving benchmarks"')
p.add_argument('--db', type=str, help='Path to database', required=True)
p.add_argument('--adminToken', type=str, help='Secret token for logging in to admin interface. If omitted will be randomly generated')

args = p.parse_args();
logF = None;

sessionF = open_sqlite_db(args.db)
sessionN = open_db('nplayers.db')

invs = { }
players = { }

alphanum = "".join([chr(ord('a') + i) for i in range(26) ] + [ str(i) for i in range(0,10)])
if (args.adminToken):
  adminToken = args.adminToken
else:
  adminToken = "".join([ choice(alphanum) for x in xrange(5) ]);

if args.log:
    logF = open(args.log,'w')

def arg_tostr(arg):
    return str(arg);

def log(action, *pps):
    action['time'] = time()
    action['ip'] = request.remote_addr;
    if (logF):
        logF.write(dumps(action) + '\n')
        logF.flush()
    else:
        if (len(pps) == 0):
          print dumps(action) + "\n";
        else:
          assert(len(action['kwargs']) == 0);
          assert(len(pps) >= len(action['args']));
          prompt = "[" + Fore.GREEN + str(action['ip']) + Style.RESET_ALL + '] ' + \
              Style.DIM + str(action['time']) + Style.RESET_ALL + ':'

          call = Fore.RED + action['method'] + "(" + Style.RESET_ALL \
              + (Fore.RED + "," + Style.RESET_ALL).join(\
                  [pps[ind](arg) for (ind, arg) in enumerate(action["args"])]) + \
               Fore.RED + ")" + Style.RESET_ALL

          if (len(action['args']) + 1 == len(pps) and 'res' in action):
            call += "=" + pps[len(action['args'])](action['res']);

          print prompt + call;
        sys.stdout.flush();

def log_d(*pps):
    def decorator(f):
        def decorated(*args, **kwargs):
            try:
                res = f(*args, **kwargs)
                log({ "method": f.__name__, "args": args, "kwargs": kwargs, "res": res }, *pps)
                return res;
            except Exception,e:
                log({ "method": f.__name__, "args": args, "kwargs": kwargs,
                      "exception": ''.join(traceback.format_exception(*exc_info()))})
                raise
        return decorated
    return decorator

def prof_d(f):
    def decorated(*args, **kwargs):
        try:
            pr = Profile()
            pr.enable()
            res = f(*args, **kwargs)
            pr.disable()
            return res;
        except Exception,e:
            raise
        finally:
            # Print results
            s = StringIO()
            ps = Stats(pr, stream=s).sort_stats('cumulative')
            ps.print_stats()
            print s.getvalue()
    return decorated

MYDIR = dirname(abspath(realpath(__file__)))
ROOT_DIR = dirname(MYDIR)

curLevelSetName, lvls = loadBoogieLvlSet(args.lvlset)
traces = { curLevelSetName: lvls }

session = sessionF()
for lvl in lvls:
  invs[lvl] = enteredInvsForLevel(curLevelSetName, lvl, session)
  players[lvl] = playersWhoStartedLevel(curLevelSetName, lvl, session)
del session

class Server(Flask):
    def get_send_file_max_age(self, name):
        if (name in [ 'jquery-1.12.0.min.js', 'jquery-migrate-1.2.1.min.js', 'jquery.jsonrpcclient.js']):
            return 100000

        return 0

app = Server(__name__, static_folder='static/', static_url_path='')
api = rpc(app, '/api')

@api.method("App.logEvent")
@pp_exc
@log_d(str,str,str,str)
def logEvent(workerId, name, data):
    session = sessionF()
    addEvent(workerId, name, time(), args.ename, request.remote_addr, data, session);
    return None

@api.method("App.listData")
@pp_exc
@log_d(str,str)
def listData(levelSet):
    res = traces[levelSet].keys()
    res.sort()
    return res

@api.method("App.getTutorialDone")
@pp_exc
@log_d(str, str)
def getTutorialDone(workerId):
    if workerId == "":
        return False
    return isfile(join(ROOT_DIR, 'logs', args.ename, "tut-done-" + workerId))

@api.method("App.setTutorialDone")
@pp_exc
@log_d(str)
def setTutorialDone(workerId):
    if workerId != "":
        open(join(ROOT_DIR, 'logs', args.ename, "tut-done-" + workerId), "w").close()


@api.method("App.loadLvl")
@pp_exc
@log_d(str, str, pp_BoogieLvl)
def loadLvl(levelSet, lvlId):
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + levelSet)

    if (lvlId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + lvlId + " in levels " + levelSet)

    lvl = traces[levelSet][lvlId]
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

class IgnoreManager:
    def __init__(self):
        self.ignores = {}
    def fname(self, workerId):
        return join(ROOT_DIR, 'logs', args.ename, "ignore-" + workerId)
    def ignoreset(self, workerId):
        if not workerId in self.ignores:
            self.load_from_file(workerId)
        return self.ignores[workerId]
    def load_from_file(self, workerId):
        res = set()
        try:
            with open(self.fname(workerId)) as f:
                for l in f.readlines():
                    res.add(tuple(l.split()))
        except IOError:
            pass # file does not exist, this is just empty ignore set
        self.ignores[workerId] = res
    def add(self, workerId, levelSet, lvlId):
        self.ignoreset(workerId).add((levelSet, lvlId))
        with open(self.fname(workerId), "a") as f:
            f.write(levelSet + " " + lvlId + "\n")
    def contains(self,workerId, levelSet, lvlId):
        return (levelSet, lvlId) in self.ignoreset(workerId)

@api.method("App.loadNextLvl")
@pp_exc
@log_d(str, pp_BoogieLvl)
def loadNextLvl(workerId):
    session = sessionF();
    exp_dir = join(ROOT_DIR, "logs", args.ename)
    level_names = traces[curLevelSetName].keys();
    num_invs = [len(enteredInvsForLevel(curLevelSetName, x, session)) for x in level_names]
    ninvs_and_level = zip(num_invs, level_names)
    #ninvs_and_level.sort()
    for ninvs, lvlId in ninvs_and_level:
        if levelSolved(session, curLevelSetName, lvlId) or \
           workerId != "" and levelFinishedBy(session, curLevelSetName, lvlId, workerId):
            continue
        result = loadLvl(curLevelSetName, lvlId)
        result["id"] = lvlId
        result["lvlSet"] = curLevelSetName
        return result

@api.method("App.instantiate")
@pp_exc
@log_d(pp_EsprimaInvs, str, str)
def instantiate(invs, traceVars, trace):
    res = []
    z3Invs = []
    templates = [ (esprimaToBoogie(x[0], {}), x[1], x[2]) for x in invs]
    vals = map(lambda x:    _to_dict(traceVars, x), trace)

    for (bInv, symConsts, symVars) in templates:
        for instInv in instantiateAndEval(bInv, vals, symVars, symConsts):
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
@log_d()
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

    if (negatedVals):
        cur_expl_state.insert(0, (_from_dict(lvl['variables'], negatedVals[0]), 0, False))

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
        if (len(new_vals) == 0):
            break
        cur_expl_state.append((_from_dict(lvl['variables'], new_vals[0]), len(new_vals)-1, terminating))

    # De-z3-ify the numbers
    js_found = [ _from_dict(lvl["variables"], env) for env in found]
    return (copy(cur_expl_state), js_found)

@api.method("App.equivalentPairs")
@pp_exc
@log_d(pp_EsprimaInvs, pp_EsprimaInvs, pp_EsprimaInvPairs)
def equivalentPairs(invL1, invL2):
    z3InvL1 = [esprimaToZ3(x, {}) for x in invL1]
    z3InvL2 = [esprimaToZ3(x, {}) for x in invL2]

    res = [(x,y) for x in z3InvL1 for y in z3InvL2 if equivalent(x, y)]
    res = [(boogieToEsprima(z3_expr_to_boogie(x)),
            boogieToEsprima(z3_expr_to_boogie(y))) for (x,y) in res]
    return res

@api.method("App.impliedPairs")
@pp_exc
@log_d(pp_EsprimaInvs, pp_EsprimaInvs, pp_EsprimaInvPairs)
def impliedPairs(invL1, invL2):
    z3InvL1 = [esprimaToZ3(x, {}) for x in invL1]
    z3InvL2 = [esprimaToZ3(x, {}) for x in invL2]

    res = [(x,y) for x in z3InvL1 for y in z3InvL2 if implies(x, y)]
    res = [(boogieToEsprima(z3_expr_to_boogie(x)),
            boogieToEsprima(z3_expr_to_boogie(y))) for (x,y) in res]
    return res

@api.method("App.isTautology")
@pp_exc
@log_d(pp_EsprimaInv, str)
def isTautology(inv):
    res = (tautology(esprimaToZ3(inv, {})))
    return res


def getLastVerResult(lvlset, lvlid, session):
    verifyAttempts = session.query(Event).filter(Event.type == "VerifyAttempt").all();
    verifyAttempts = [x for x in verifyAttempts if x.payl()["lvlset"] == lvlset and x.payl()["lvlid"] == lvlid]
    if (len(verifyAttempts) > 0):
      return verifyAttempts[-1].payl();
    else:
      return None;

def nodups(s):
  return list(set(s))

@api.method("App.tryAndVerify")
@pp_exc
@log_d(str, str, pp_EsprimaInvs, pp_tryAndVerifyRes)
def tryAndVerify(levelSet, levelId, invs):
    s = sessionF();
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
    partialInvs = [ lvl['partialInv'] ] if 'partialInv' in lvl else []
    splitterPreds = lvl['splitterPreds'] if 'splitterPreds' in lvl else [ AstTrue() ]
    boogie_invs = [ esprimaToBoogie(x, {}) for x in invs ]
    candidate_antecedents = [ ast_and(pSet) for pSet in nonempty(powerset(splitterPreds)) ]

    initial_sound = partialInvs 

    lastVer = getLastVerResult(levelSet, levelId, s)
    if (lastVer):
      initial_sound += [parseExprAst(x) for x in lastVer["sound"]]
      boogie_invs += [parseExprAst(x) for x in lastVer["nonind"]]

    # First lets find the invariants that are sound without implication
    overfitted, nonind, sound, violations =\
      tryAndVerify_impl(bbs, loop, initial_sound, boogie_invs)
    sound = [x for x in sound if not tautology(expr_to_z3(x, AllIntTypeEnv()))]

    # Next lets add implication  to all unsound invariants from first pass
    # Also add manually specified partialInvs
    unsound = [ inv_ctr_pair[0] for inv_ctr_pair in overfitted + nonind ]
    p2_invs = [ AstBinExpr(antec, "==>", inv)
      for antec in candidate_antecedents for inv in unsound ] + partialInvs
    p2_invs = [ x for x in p2_invs if not tautology(expr_to_z3(x, AllIntTypeEnv())) ]

    # And look for any new sound invariants
    overfitted, nonind, sound_p2, violations =\
      tryAndVerify_impl(bbs, loop, sound, p2_invs)
    sound = set(sound).union(sound_p2)

    # Finally see if the sound invariants imply the postcondition. 
    solved = len(violations) == 0;
    fix = lambda x: _from_dict(lvl['variables'], x)
    
    # Convert all invariants from Boogie to esprima expressions, and counterexamples to arrays
    # from dictionaries
    overfitted = [ (boogieToEsprima(inv), fix(v.endEnv()))
      for (inv, v) in overfitted ]
    nonind = [ (boogieToEsprima(inv), (fix(v.startEnv(), v.endEnv())))
      for (inv, v) in nonind ]
    sound = [ boogieToEsprima(inv) for inv in sound ]
    safety_ctrexs = [ fix(v.startEnv()) for v in violations ]

    res = (overfitted, nonind, sound, safety_ctrexs)
    addEvent("verifier", "VerifyAttempt", time(), args.ename, "localhost", {
      "lvlset": levelSet,
      "lvlid": levelId,
      "overfitted":nodups([str(esprimaToBoogie(inv, {})) for (inv,c) in overfitted]),
      "nonind":nodups([str(esprimaToBoogie(inv, {})) for (inv,c) in nonind]),
      "sound":nodups([str(esprimaToBoogie(inv, {})) for inv in sound]),
      "post_ctrex":safety_ctrexs
    }, s)

    return res

@api.method("App.simplifyInv")
@pp_exc
@log_d(pp_EsprimaInv, pp_EsprimaInv)
def simplifyInv(inv):
    z3_inv = esprimaToZ3(inv, {});
    simpl_z3_inv = simplify(z3_inv, arith_lhs=True);
    return boogieToEsprima(z3_expr_to_boogie(simpl_z3_inv));

@api.method("App.getRandomCode")
@pp_exc
@log_d(str)
def getRandomCode():
    return "".join([ choice(alphanum) for x in range(5) ]);


kvStore = { }

@api.method("App.get")
@pp_exc
@log_d(str)
def get(key):
    if (type(key) != unicode):
      raise Exception("Key must be string");

    return kvStore[key];

@api.method("App.set")
@pp_exc
@log_d(str, str, str)
def get(key, val, expectedGen):
    if (type(key) != unicode):
      raise Exception("Key must be string");

    if (expectedGen != -1):
      (curGen, curVal) = kvStore[key]
    else:
      if (key in kvStore):
        raise Exception("Trying to add a new key with gen 0 but key already there: " + key);

    if (expectedGen != -1 and curGen != expectedGen):
      return (curGen, curVal);
    else:
      kvStore[key] = (expectedGen + 1, val);
      return (expectedGen + 1, val)

    return kvStore[key];


@api.method("App.newPlayer")
@pp_exc
# @log_d(str, str)
def newPlayer(playerId, password):
    session = sessionN()
    addPlayerLogin(playerId, password, session)


@api.method("App.checkLogin")
@pp_exc
# @log_d(str, str)
def checkLogin(playerId, password):
    session = sessionN()
    result = checkPlayerLogin(playerId, password, session)
    if result == 1:
        return "valid"
    else:
        return "invalid"


@api.method("App.newScore")
@pp_exc
# @log_d(str, str)
def newScore(playerId, gameId):
    session = sessionN()
    newPlayerScore(playerId, gameId, session)


@api.method("App.updateScore")
@pp_exc
# @log_d(str, str, str)
def updateScore(playerId, gameId, score):
    session = sessionN()
    updatePlayerScore(playerId, gameId, score, session)


# Admin Calls:
@api.method("App.getLogs")
@pp_exc
@log_d(str, str, str)
def getLogs(inputToken, afterTimestamp, afterId):
  if inputToken != adminToken:
    raise Exception(str(inputToken) + " not a valid token.");

  s = sessionF();
  if (afterTimestamp != None):
    afterT = datetime.strptime(afterTimestamp, "%a, %d %b %Y %H:%M:%S %Z")
    evts = s.query(Event).filter(Event.time > afterT).all();
  elif (afterId != None):
    evts = s.query(Event).filter(Event.id > afterId).all();
  else:
    evts = s.query(Event).all();

  return [ { "id": e.id, "type": e.type, "experiment": e.experiment, "src": e.src,
              "addr": e.addr, "time": str(e.time), "payload": e.payl() } for e in evts ]
  
if __name__ == "__main__":
    ignore = IgnoreManager()
    print "Admin Token: ", adminToken
    print "Admin URL: ", "admin.html?adminToken=" + adminToken
    app.run(host='0.0.0.0',port=args.port,ssl_context=(MYDIR + '/cert.pem', MYDIR + '/privkey.pem'), threaded=True)
