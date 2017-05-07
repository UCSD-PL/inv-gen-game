#! /usr/bin/env python
from flask import Flask
from flask import request
from flask_jsonrpc import JSONRPC as rpc
from os.path import dirname, abspath, realpath, join, isfile
from js import esprimaToZ3, esprimaToBoogie, boogieToEsprima, \
        boogieToEsprimaExpr
from lib.boogie.ast import AstBinExpr, AstTrue, ast_and, AstId, AstNumber, \
        parseExprAst
from lib.common.util import pp_exc, powerset, split, nonempty, nodups, \
        randomToken
from lib.boogie.eval import instantiateAndEval, _to_dict
from lib.boogie.z3_embed import expr_to_z3, AllIntTypeEnv, z3_expr_to_boogie,\
        Unknown, simplify, implies, equivalent, tautology
from lib.boogie.analysis import propagate_sp
from vc_check import _from_dict, tryAndVerifyLvl, loopInvSafetyCtrex

from levels import _tryUnroll, findNegatingTrace, loadBoogieLvlSet

import argparse
import sys
from pp import pp_BoogieLvl, pp_EsprimaInv, pp_EsprimaInvs, pp_CheckInvsRes, \
        pp_tryAndVerifyRes, pp_mturkId, pp_EsprimaInvPairs
from copy import copy
from time import time
from datetime import datetime
from models import open_sqlite_db, Event
from db_util import playersWhoStartedLevel, enteredInvsForLevel,\
        getOrAddSource, addEvent, levelSolved, levelFinishedBy
from atexit import register
from server_common import openLog, log, log_d

from flask_compress import Compress
from flask.ext.cache import Cache

from nplayer_db import *

class Server(Flask):
    def get_send_file_max_age(self, name):
        if (name in [ 'jquery-1.12.0.min.js', \
                      'jquery-migrate-1.2.1.min.js', \
                      'jquery.jsonrpcclient.js']):
            return 100000

        return 0

app = Server(__name__, static_folder='static/', static_url_path='')
Compress(app)
cache = Cache(app,config={'CACHE_TYPE': 'filesystem', 'CACHE_DIR': '/'})
api = rpc(app, '/api')

## Utility functions #################################################
def getLastVerResult(lvlset, lvlid, session):
    events = session.query(Event)
    verifyAttempts = events.filter(Event.type == "VerifyAttempt").all();
    verifyAttempts = filter(
        lambda x:  x.payl()["lvlset"] == lvlset and x.payl()["lvlid"] == lvlid,
        verifyAttempts);
    if (len(verifyAttempts) > 0):
      return verifyAttempts[-1].payl();
    else:
      return None;

def divisionToMul(inv):
    if isinstance(inv, AstBinExpr) and \
       inv.op in ['==', '<', '>', '<=', '>=', '!==']:
        if (isinstance(inv.lhs, AstBinExpr) and inv.lhs.op == 'div' and\
                isinstance(inv.lhs.rhs, AstNumber)):
                    return AstBinExpr(inv.lhs.lhs, inv.op, \
                                      AstBinExpr(inv.rhs, '*', inv.lhs.rhs));

        if (isinstance(inv.rhs, AstBinExpr) and inv.rhs.op == 'div' and\
                isinstance(inv.rhs.rhs, AstNumber)):
                    return AstBinExpr(AstBinExpr(inv.lhs, "*", inv.rhs.rhs), \
                                      inv.op, inv.rhs.lhs);
    return inv


## API Entry Points ##################################################

@api.method("App.logEvent")
@pp_exc
@log_d(str,str,str,pp_mturkId, str)
def logEvent(workerId, name, data, mturkId):
    session = sessionF()
    addEvent(workerId, name, time(), args.ename, request.remote_addr, \
             data, session, mturkId);
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
        marker = join(ROOT_DIR, 'logs', args.ename, "tut-done-" + workerId)
        open(marker, "w").close()


@api.method("App.loadLvl")
@pp_exc
@log_d(str, str, pp_mturkId, pp_BoogieLvl)
def loadLvl(levelSet, lvlId, mturkId): #pylint: disable=unused-argument
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + levelSet)

    if (lvlId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + lvlId + " in levels " + levelSet)

    lvl = traces[levelSet][lvlId]
    if ('program' in lvl):
      # This is a boogie level - don't return the program/loop and other book
      # keeping
      lvl = {
             'lvlSet': levelSet,
             'id': lvlId,
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

@api.method("App.genNextLvl")
@pp_exc
@log_d(str, pp_mturkId, str, str, pp_EsprimaInvs, pp_BoogieLvl)
def genNextLvl(workerId, mturkId, levelSet, levelId, invs):
    s = sessionF();
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + str(levelSet))

    if (levelId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + str(levelId) + \
                        " in levels " + str(levelSet))

    if (len(invs) == 0):
        raise Exception("No invariants given")

    lvl = traces[levelSet][levelId]

    if ('program' not in lvl):
      # Not a boogie level - error
      raise Exception("Level " + str(levelId) + " " + \
                      str(levelSet) + " not a dynamic boogie level.")

    userInvs = set([ esprimaToBoogie(x, {}) for x in invs ])
    otherInvs = set([])
    lastVer = getLastVerResult(levelSet, levelId, s)

    if (lastVer):
      otherInvs = otherInvs.union([parseExprAst(x) for x in lastVer["sound"]])
      otherInvs = otherInvs.union([parseExprAst(x) for x in lastVer["nonind"]])

    ((overfitted, _), (_, _), _, violations) =\
      tryAndVerifyLvl(lvl, userInvs, otherInvs, args.timeout)

    # See if the level is solved
    solved = len(violations) == 0;
    if (solved):
        return loadNextLvl(workerId, mturkId);

    fix = lambda env:   _from_dict(lvl['variables'], env, 0)
    greenRows = [ fix(v.endEnv()) for v in overfitted if type(v) != tuple]
    print "Invs: ", otherInvs.union(userInvs)
    print "GreenRows: ", greenRows
    bbs = lvl["program"]
    loop = lvl["loop"]
    safetyCtrex =\
        loopInvSafetyCtrex(loop, otherInvs.union(userInvs), bbs, args.timeout)
    redRows = [ fix(x) for x in safetyCtrex if len(x) != 0 ]
    print "RedRows: ", redRows
    if (len(redRows) > 0 or len(greenRows) > 0):
        # Lets give them another level
        newLvl = copy(lvl);
        newLvlId = levelId + ".g"
        newLvl["data"][0].extend(greenRows)
        newLvl["data"][2].extend(redRows)
        traces[levelSet][newLvlId] = newLvl;
        return loadLvl(levelSet, newLvlId, mturkId);
    else:
        # Else give them the actual next level
        return loadNextLvl(workerId, mturkId);

@api.method("App.loadNextLvl")
@pp_exc
@log_d(str, pp_mturkId, pp_BoogieLvl)
def loadNextLvl(workerId, mturkId):
    session = sessionF();
    level_names = traces[curLevelSetName].keys();
    num_invs = [len(enteredInvsForLevel(curLevelSetName, x, session))
                    for x in level_names]
    ninvs_and_level = zip(num_invs, level_names)
    ninvs_and_level.sort()
    for _, lvlId in ninvs_and_level:
        if levelSolved(session, curLevelSetName, lvlId) or \
           (workerId != "" and \
            levelFinishedBy(session, curLevelSetName, lvlId, workerId)):
            continue
        result = loadLvl(curLevelSetName, lvlId, mturkId)
        return result

@api.method("App.instantiate")
@pp_exc
@log_d(pp_EsprimaInvs, str, str, pp_mturkId, pp_EsprimaInvs)
def instantiate(invs, traceVars, trace, mturkId): #pylint: disable=unused-argument
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

            if (implied):
                continue

            res.append(instInv)
            z3Invs.append(instZ3Inv)

    return map(boogieToEsprima, res)

@api.method("App.getPositiveExamples")
@pp_exc
@log_d()
def getPositiveExamples(levelSet, levelId, cur_expl_state, overfittedInvs, num):
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + str(levelSet))

    if (levelId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + str(levelId) + \
                        " in levels " + str(levelSet))

    lvl = traces[levelSet][levelId]

    if ('program' not in lvl):
      # Not a boogie level - error
      raise Exception("Level " + str(levelId) + " " + \
                      str(levelSet) + " not a dynamic boogie level.")

    bbs = lvl['program']
    loop = lvl["loop"]
    found = []
    need = num
    overfitBoogieInvs = [esprimaToBoogie(x, {}) for x in overfittedInvs]
    negatedVals, _= findNegatingTrace(loop, bbs, num, overfitBoogieInvs)

    if (negatedVals):
        newExpState = (_from_dict(lvl['variables'], negatedVals[0]), 0, False)
        cur_expl_state.insert(0, newExpState)

    for (ind, (loop_head, nunrolls, is_finished)) in enumerate(cur_expl_state):
        if is_finished:
            continue
        if need <= 0:
            break

        good_env = _to_dict(lvl['variables'], loop_head)
        # Lets first try to find terminating executions:
        new_vals, terminating = _tryUnroll(loop, bbs, nunrolls+1, \
                                           nunrolls+1+need, None, good_env)
        new_vals = new_vals[nunrolls+1:]
        cur_expl_state[ind] = (loop_head, nunrolls + len(new_vals), terminating)

        found.extend(new_vals)
        need -= len(new_vals)

    while need > 0:
        bad_envs = [ _to_dict(lvl['variables'], row)
                        for (row,_,_) in cur_expl_state ]
        new_vals, terminating = _tryUnroll(loop, bbs, 0, need, bad_envs, None)
        found.extend(new_vals)
        need -= len(new_vals)
        if (len(new_vals) == 0):
            break
        newExpState = (_from_dict(lvl['variables'], new_vals[0]), \
                       len(new_vals)-1, \
                       terminating)
        cur_expl_state.append(newExpState)

    # De-z3-ify the numbers
    js_found = [ _from_dict(lvl["variables"], env) for env in found]
    return (copy(cur_expl_state), js_found)

@api.method("App.equivalentPairs")
@pp_exc
@log_d(pp_EsprimaInvs, pp_EsprimaInvs, pp_mturkId, pp_EsprimaInvPairs)
def equivalentPairs(invL1, invL2, mturkId): #pylint: disable=unused-argument
    z3InvL1 = [esprimaToZ3(x, {}) for x in invL1]
    z3InvL2 = [esprimaToZ3(x, {}) for x in invL2]

    res = []
    for x in z3InvL1:
      for y in z3InvL2:
        try:
          equiv = equivalent(x, y)
        except Unknown:
          equiv = False; # Conservative assumption

        if (equiv):
          res.append((x,y))

    res = [(boogieToEsprima(z3_expr_to_boogie(x)),
            boogieToEsprima(z3_expr_to_boogie(y))) for (x,y) in res]
    return res

@api.method("App.impliedPairs")
@pp_exc
@log_d(pp_EsprimaInvs, pp_EsprimaInvs, pp_mturkId, pp_EsprimaInvPairs)
@cache.memoize(timeout=1000)
def impliedPairs(invL1, invL2, mturkId): #pylint: disable=unused-argument
    z3InvL1 = [esprimaToZ3(x, {}) for x in invL1]
    z3InvL2 = [esprimaToZ3(x, {}) for x in invL2]

    res = []
    for x in z3InvL1:
      for y in z3InvL2:
        try:
          impl = implies(x, y)
        except Unknown:
          impl = False; # Conservative assumption

        if (impl):
          res.append((x,y))

    res = [(boogieToEsprima(z3_expr_to_boogie(x)),
            boogieToEsprima(z3_expr_to_boogie(y))) for (x,y) in res]
    return res

@api.method("App.isTautology")
@pp_exc
@log_d(pp_EsprimaInv, pp_mturkId, str)
def isTautology(inv, mturkId): #pylint: disable=unused-argument
    try:
      res = (tautology(esprimaToZ3(inv, {})))
      return res
    except Unknown:
      return False; # Conservative assumption

@api.method("App.tryAndVerify")
@pp_exc
@log_d(str, str, pp_EsprimaInvs, pp_mturkId, pp_tryAndVerifyRes)
def tryAndVerify(levelSet, levelId, invs, mturkId):
    s = sessionF();
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + str(levelSet))

    if (levelId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + str(levelId) + \
                        " in levels " + str(levelSet))

    if (len(invs) == 0):
        raise Exception("No invariants given")

    lvl = traces[levelSet][levelId]

    if ('program' not in lvl):
      # Not a boogie level - error
      raise Exception("Level " + str(levelId) + " " + \
                      str(levelSet) + " not a dynamic boogie level.")

    userInvs = set([ esprimaToBoogie(x, {}) for x in invs ])
    otherInvs = set([])
    lastVer = getLastVerResult(levelSet, levelId, s)

    if (lastVer):
      otherInvs = otherInvs.union([parseExprAst(x) for x in lastVer["sound"]])
      otherInvs = otherInvs.union([parseExprAst(x) for x in lastVer["nonind"]])

    ((overfitted, _), (nonind, _), sound, violations) =\
      tryAndVerifyLvl(lvl, userInvs, otherInvs, args.timeout)

    # See if the level is solved
    solved = len(violations) == 0;
    fix = lambda x: _from_dict(lvl['variables'], x, 0)

    if (not solved):
        bbs = lvl["program"]
        loop = lvl["loop"]
        direct_ctrexs = loopInvSafetyCtrex(loop, otherInvs.union(userInvs),\
                                           bbs, args.timeout);
    else:
        direct_ctrexs = []

    # Convert all invariants from Boogie to esprima expressions, and
    # counterexamples to arrays
    # from dictionaries
    overfitted = [ (boogieToEsprima(inv), fix(v.endEnv()))
      for (inv, v) in overfitted ]
    nonind = [ (boogieToEsprima(inv), (fix(v.startEnv()), fix(v.endEnv())))
      for (inv, v) in nonind ]
    sound = [ boogieToEsprima(inv) for inv in sound ]
    safety_ctrexs = [ fix(v.startEnv()) for v in violations ]
    direct_ctrexs = [ fix(v) for v in direct_ctrexs ]


    res = (overfitted, nonind, sound, safety_ctrexs, direct_ctrexs)
    payl ={
      "lvlset": levelSet,
      "lvlid": levelId,
      "overfitted":nodups([str(esprimaToBoogie(x[0], {})) for x in overfitted]),
      "nonind":nodups([str(esprimaToBoogie(inv, {})) for (inv,_) in nonind]),
      "sound":nodups([str(esprimaToBoogie(inv, {})) for inv in sound]),
      "post_ctrex":safety_ctrexs,
      "direct_ctrex": direct_ctrexs
    }
    addEvent("verifier", "VerifyAttempt", time(), args.ename, \
             "localhost", payl, s, mturkId)

    return res

@api.method("App.simplifyInv")
@pp_exc
@log_d(pp_EsprimaInv, pp_mturkId, pp_EsprimaInv)
def simplifyInv(inv, mturkId): #pylint: disable=unused-argument
    boogieInv = esprimaToBoogie(inv, {});
    noDivBoogie = divisionToMul(boogieInv);
    z3_inv = expr_to_z3(noDivBoogie, AllIntTypeEnv())
    simpl_z3_inv = simplify(z3_inv, arith_lhs=True);
    simpl_boogie_inv = z3_expr_to_boogie(simpl_z3_inv);
    return boogieToEsprima(simpl_boogie_inv);

@api.method("App.getRandomCode")
@pp_exc
@log_d(str)
def getRandomCode():
    return randomToken(5)

kvStore = { }

@api.method("App.get")
@pp_exc
@log_d(str)
@cache.memoize(timeout=50)
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
        raise Exception("Trying to add a new key with gen 0 " + \
                        "but key already there: " + key);

    if (expectedGen != -1 and curGen != expectedGen):
      return (curGen, curVal);
    else:
      kvStore[key] = (expectedGen + 1, val);
      return (expectedGen + 1, val)

    return kvStore[key];


@api.method("App.getGames")
@pp_exc
def getGames():
    return kvStore


@api.method("App.newPlayer")
@pp_exc
def newPlayer(playerId, password):
    session = sessionN()
    addPlayerLogin(playerId, password, session)


@api.method("App.checkLogin")
@pp_exc
def checkLogin(playerId, password):
    session = sessionN()
    result = checkPlayerLogin(playerId, password, session)
    if result == 1:
        return "valid"
    else:
        return "invalid"


@api.method("App.newScore")
@pp_exc
def newScore(playerId, gameId):
    session = sessionN()
    newPlayerScore(playerId, gameId, session)


@api.method("App.updateScore")
@pp_exc
def updateScore(playerId, gameId, score):
    session = sessionN()
    updatePlayerScore(playerId, gameId, score, session)


@api.method("App.getTotalScore")
@pp_exc
def getTotalScore(playerId):
    session = sessionN()
    return getPlayerTotalScore(playerId, session)


@api.method("App.getAllScores")
@pp_exc
def getAllScores():
    session = sessionN()
    return getAllPlayerScores(session)


@api.method("App.addNewFeedback")
@pp_exc
def addNewFeedback(playerId, fun, challenge, prog, math, comments):
    session = sessionN()
    addFeedback(playerId, fun, challenge, prog, math, comments, session)


@api.method("App.getAllFeedback")
@pp_exc
def getAllFeedback():
    session = sessionN()
    return getFeedback(session)


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

  return [ { "id": e.id,
             "type": e.type,
             "experiment": e.experiment,
             "src": e.src,
             "addr": e.addr,
             "time": str(e.time),
             "payload": e.payl() } for e in evts ]

@api.method("App.getSolutions")
@pp_exc
@log_d()
def getSolutions(): # Lvlset is assumed to be current by default
  res = { }
  for lvlId in lvls:
    solnFile = lvls[lvlId]["path"][0][:-len(".bpl")] + ".sol"
    soln = open(solnFile).read().strip();
    boogieSoln = parseExprAst(soln)
    res[curLevelSetName + "," + lvlId] = [boogieToEsprimaExpr(boogieSoln)]
  return res

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="invariant gen game server")
    p.add_argument('--log', type=str,
            help='an optional log file to store all user actions. ' +
                 'Entries are stored in JSON format.')
    p.add_argument('--port', type=int, help='a optional port number', \
                   required=True)
    p.add_argument('--ename', type=str, default='default',
            help='Name for experiment; if none provided, use "default"')
    p.add_argument('--lvlset', type=str, \
            default='desugared-boogie-benchmarks',
            help='Lvlset to use for serving benchmarks"')
    p.add_argument('--db', type=str, help='Path to database')
    p.add_argument('--adminToken', type=str,
            help='Secret token for logging in to admin interface. ' +
            'If omitted will be randomly generated')
    p.add_argument('--timeout', type=int, default=60,
            help='Timeout in seconds for z3 queries.')

    args = p.parse_args();

    sessionF = open_sqlite_db(args.db)
    sessionN = open_db('nplayers.db')

    if (args.adminToken):
      adminToken = args.adminToken
    else:
      adminToken = randomToken(5);

    if args.log:
        openLog(args.log);

    MYDIR = dirname(abspath(realpath(__file__)))
    ROOT_DIR = dirname(MYDIR)

    curLevelSetName, lvls = loadBoogieLvlSet(args.lvlset)
    traces = { curLevelSetName: lvls }

    print "Admin Token: ", adminToken
    print "Admin URL: ", "admin.html?adminToken=" + adminToken
    app.run(host='0.0.0.0', port=args.port, threaded=True)
    # app.run(host='0.0.0.0',
    #         port=args.port,
    #         ssl_context=(MYDIR + '/cert.pem', MYDIR + '/privkey.pem'),
    #         threaded=True)
