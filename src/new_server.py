#! /usr/bin/env python
from flask import Flask
from flask import request
from flask_jsonrpc import JSONRPC as rpc
from os.path import dirname, abspath, realpath, join, isfile
from js import esprimaToZ3, esprimaToBoogie, boogieToEsprima, \
        boogieToEsprimaExpr
from lib.boogie.ast import AstBinExpr, AstTrue, ast_and, AstId, AstNumber, \
        parseExprAst
from lib.common.util import powerset, split, nonempty, nodups, \
        randomToken
from lib.boogie.eval import instantiateAndEval, _to_dict
from lib.boogie.z3_embed import expr_to_z3, z3_expr_to_boogie,\
        Unknown, simplify, implies, equivalent, tautology
from lib.boogie.analysis import propagate_sp

from levels import _tryUnroll, findNegatingTrace, loadBoogieLvlSet, loadNewBoogieLvlSet

import argparse
import sys
from pp import pp_BoogieLvl, pp_EsprimaInv, pp_EsprimaInvs, pp_CheckInvsRes, \
        pp_tryAndVerifyRes, pp_mturkId, pp_EsprimaInvPairs
from copy import copy
from time import time
from datetime import datetime
from models import open_sqlite_db, open_mysql_db, Event
from db_util import addEvent, allInvs, levelSolved, levelFinishedBy,\
        levelSkipCount, levelsPlayedInSession
from mturk_util import send_notification
from atexit import register
from server_common import openLog, log, log_d, pp_exc

from lib.boogie.inv_networks import Violation, checkInvNetwork

class Server(Flask):
    def get_send_file_max_age(self, name):
        if (name in [ 'jquery-1.12.0.min.js', \
                      'jquery-migrate-1.2.1.min.js', \
                      'jquery.jsonrpcclient.js']):
            return 100000

        return 0

app = Server(__name__, static_folder='static/', static_url_path='')
api = rpc(app, '/api')

## Utility functions #################################################

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

def getLvl(levelSet, lvlId):
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + levelSet)

    if (lvlId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + lvlId + " in levels " + levelSet)

    return traces[levelSet][lvlId]

## API Entry Points ##################################################
@api.method("App.logEvent")
def logEvent(workerId, name, data, mturkId):
    """ Log an event from either the frontend or backend. Event appears
        as JSON in both the textual log, as well as in the database """
    session = sessionF()
    addEvent(workerId, name, time(), args.ename, request.remote_addr, \
             data, session, mturkId);
    return None

@api.method("App.loadLvl")
def loadLvl(levelSet, lvlId, mturkId): #pylint: disable=unused-argument
    """ Load a given level. """
    lvl = getLvl(levelSet, lvlId)
    print ("Returning :",lvl.to_json())
    return lvl.to_json()

@api.method("App.equivalentPairs")
def equivalentPairs(invL1, invL2, mturkId): #pylint: disable=unused-argument
    """ 
        Given lists of invariants invL1, invL2, return all pairs (I1, I2)
        where I1 <==> I2, I1 \in invL1, I2 \in invL2 

        Not currently in use.
    """ 
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
def impliedPairs(invL1, invL2, mturkId): #pylint: disable=unused-argument
    """ 
        Given lists of invariants invL1, invL2, return all pairs (I1, I2)
        where I1 ==> I2, I1 \in invL1, I2 \in invL2 

        Used by game.html
    """ 
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
def isTautology(inv, mturkId): #pylint: disable=unused-argument
    """ 
        Check whether the invariant inv is a tautology.
        Used by game.html
    """ 
    try:
      res = (tautology(esprimaToZ3(inv, {})))
      return res
    except Unknown:
      return False; # Conservative assumption

@api.method("App.checkSoundness")
def checkSoundness(levelSet, levelId, rawInvs, mturkId):
    lvl = getLvl(levelSet, levelId)

    invs = {
      label: set(esprimaToBoogie(inv, {}) for inv in rawExps)
        for (label, rawExps) in rawInvs.items()
    }

    print ("invs: ", invs)

    res = checkInvNetwork(lvl._fun, AstTrue(), AstTrue(), invs, args.timeout)

    print ("res: ", res)
    return [v.to_json() for v in res]

@api.method("App.tryAndVerify")
def tryAndVerify(levelSet, levelId, invs, mturkId, individualMode):
    """ 
        Given a level (levelSet, levelId) and a set of invaraints invs do:
        1) Find all invariants OldI that were not DEFINITELY false from the
           last time we tried to verify this level (getLastVerResult)

        2) Try and verify the level using S = OldI + invs. This is done by
           calling tryAndVerifyLvl. For more on that see comment in
           tryAndVerifyLvl

        3) Return object containing:
           overfitted - all invariants in invs not implied by precondition
           nonind - all invariants in invs that are not inductive
           sound - all invariants in invs that are sound
           post_ctrex - any safety counterexamples to the "sound" invariants.
              If this set is empty, then the level is verified.
           direct_ctrex - any safety counterexamples to ALL of the passed in
              invs (not just the sound ones). This is used by the 'rounds' game
              mode to generate red rows for the next level.
    """ 
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

    workerId, _, _ = mturkId
    print(repr(set));
    userInvs = set([ esprimaToBoogie(x, {}) for x in invs ])
    otherInvs = set([])
    lastVer = getLastVerResult(levelSet, levelId, s,
      workerId=(workerId if individualMode else None))

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
def simplifyInv(inv, mturkId): #pylint: disable=unused-argument
    """ Given an invariant inv return its 'simplified' version. We
        treat that as the canonical version of an invariant. Simplification
        is performed by z3 """
    boogieInv = esprimaToBoogie(inv, {});
    noDivBoogie = divisionToMul(boogieInv);
    z3_inv = expr_to_z3(noDivBoogie, AllIntTypeEnv())
    print(z3_inv, boogieInv)
    simpl_z3_inv = simplify(z3_inv, arith_lhs=True);
    simpl_boogie_inv = z3_expr_to_boogie(simpl_z3_inv);
    return boogieToEsprima(simpl_boogie_inv);


kvStore = { }

@api.method("App.get")
def getVal(key):
    """ Generic Key/Value store get() used by two-player gameplay for
        synchronizing shared state. 
    """
    if (type(key) != str):
      raise Exception("Key must be string");

    return kvStore[key];

@api.method("App.set")
def setVal(key, val, expectedGen):
    """ Generic Key/Value store set() used by two-player gameplay for
        synchronizing shared state. 
    """
    if (type(key) != str):
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


@api.method("App.getSolutions")
def getSolutions(): # Lvlset is assumed to be current by default
  """ Return all solutions for a levelset. Only used by admin interface.
  """
  res = { }
  for lvlId in lvls:
    solnFile = lvls[lvlId]["path"][0][:-len(".bpl")] + ".sol"
    soln = open(solnFile).read().strip();
    boogieSoln = parseExprAst(soln)
    res[curLevelSetName + "," + lvlId] = [boogieToEsprimaExpr(boogieSoln)]
  return res

@api.method("App.reportProblem")
def reportProblem(mturkId, lvl, desc):
  """ Accept a problem report from a player and send it to the current
      notification e-mail address.
  """
  lines = []
  lines.append("A problem report has been submitted.")
  lines.append("")
  lines.append("Time: %s" %
    datetime.now().strftime("%a, %d %b %Y %H:%M:%S %Z"))
  lines.append("HIT: %s" % mturkId[1])
  lines.append("Worker: %s" % mturkId[0])
  lines.append("Experiment: %s" % args.ename)
  lines.append("Level: %s" % lvl)
  lines.append("Problem description:")
  lines.append("")
  lines.append(desc)

  send_notification(args.email, "Inv-Game Problem Report", "\n".join(lines))

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="invariant gen game server")
    p.add_argument('--local', action='store_true',
            help='Run without SSL for local testing')
    p.add_argument('--log', type=str,
            help='an optional log file to store all user actions. ' +
                 'Entries are stored in JSON format.')
    p.add_argument('--port', type=int, help='an optional port number')
    p.add_argument('--ename', type=str, default='default',
            help='Name for experiment; if none provided, use "default"')
    p.add_argument('--lvlset', type=str, \
            default='lvlsets/unsolved.lvlset',
            help='Lvlset to use for serving benchmarks"')
    p.add_argument('--db', type=str, help='Path to database', required=True)
    p.add_argument('--adminToken', type=str,
            help='Secret token for logging in to admin interface. ' +
            'If omitted will be randomly generated')
    p.add_argument('--timeout', type=int, default=60,
            help='Timeout in seconds for z3 queries.')
    p.add_argument('--email', type=str,
            help='E-mail address to notify for problem reports')
    p.add_argument('--colSwap', action='store_true',
            help='Enable column swapping')
    p.add_argument('--maxlvls', type=int,
            help='Maximum number of levels that can be played per HIT')
    p.add_argument('--replay', action='store_true',
            help='Enable replaying levels')

    args = p.parse_args();

    if ('mysql+mysqldb://' in args.db):
      sessionF = open_mysql_db(args.db)
    else:
      sessionF = open_sqlite_db(args.db)

    if (args.adminToken):
      adminToken = args.adminToken
    else:
      adminToken = randomToken(5);

    if args.log:
        openLog(args.log);

    MYDIR = dirname(abspath(realpath(__file__)))
    ROOT_DIR = dirname(MYDIR)

    if args.local:
      host = '127.0.0.1'
      sslContext = None
    else:
      host = '0.0.0.0'
      sslContext = MYDIR + '/cert.pem', MYDIR + '/privkey.pem'

    curLevelSetName, lvls = loadNewBoogieLvlSet(args.lvlset)
    traces = { curLevelSetName: lvls }

    print("Admin Token: ", adminToken)
    print("Admin URL: ", "admin.html?adminToken=" + adminToken)
    app.run(host=host, port=args.port, ssl_context=sslContext, threaded=True)
