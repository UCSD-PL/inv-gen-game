#!  /usr/bin/env python
# Builtin includes
import argparse
import sys
from copy import copy
from time import time
from datetime import datetime
from atexit import register
from os.path import dirname, abspath, realpath, join, isfile
# Third-party library includes
from flask import Flask
from flask import request, redirect, url_for, send_from_directory
from flask_jsonrpc import JSONRPC as rpc
from sqlalchemy.orm import Session
import z3

# Pyboogie includes
from pyboogie.ast import AstBinExpr, AstTrue, ast_and, AstId, AstNumber, \
        parseExprAst, AstExpr
from pyboogie.bb import TypeEnv as BoogieTypeEnv, Function
from pyboogie.eval import instantiateAndEval, _to_dict
from pyboogie.z3_embed import expr_to_z3, z3_expr_to_boogie,\
        Unknown, simplify, implies, equivalent, tautology, boogieToZ3TypeEnv,\
        Z3TypeEnv
from pyboogie.analysis import propagateUnmodifiedPreds 
from pyboogie.interp import BoogieVal

# Local repo includes
from lib.common.util import powerset, split, nonempty, nodups, \
        randomToken, ccast
from js import esprimaToZ3, esprimaToBoogie, boogieToEsprima, \
        boogieToEsprimaExpr, jsonToTypeEnv, JSONTypeEnv, EsprimaNode
from vc_check import _from_dict, tryAndVerifyLvl, loopInvSafetyCtrex
from levels import loadBoogieLvlSet, BoogieTraceLvl
from pp import pp_BoogieLvl, pp_EsprimaInv, pp_EsprimaInvs, pp_CheckInvsRes, \
        pp_tryAndVerifyRes, pp_mturkId, pp_EsprimaInvPairs
from models import open_sqlite_db, open_mysql_db, Event
from db_util import addEvent, allInvs, levelSolved, levelFinishedBy,\
        levelSkipCount, levelsPlayedInSession, tutorialDoneBy, questionaireDoneBy,\
        MturkIdT
from server_common import openLog, log, log_d, pp_exc

# Typing includes
from typing import Dict, Any, Optional, TypeVar, List, Tuple, Set
T = TypeVar("T")

### Flask code to initialize server
class Server(Flask):
    def get_send_file_max_age(self, name):
        if (name in ['jquery-1.12.0.min.js', \
                      'jquery-migrate-1.2.1.min.js', \
                      'jquery.jsonrpcclient.js']):
            return 100000

        return 0

app = Server(__name__, static_folder='frontend/', static_url_path='/game')
api = rpc(app, '/api')

@app.route('/game/app/start', methods=['GET', 'POST'])
def game():  # pragma: no cover
    return send_from_directory('frontend/app', 'start.html', mimetype="text/html")
@app.route('/')
def index():
    return redirect(url_for('static', filename='app/start.html'))

## Utility functions #################################################
def getLastVerResult(lvlset: str, lvlid: str, session: Session, workerId=None) -> Optional[Dict[str, Any]]:
    events = session.query(Event)
    verifyAttempts = events.filter(Event.type == "VerifyAttempt").all()
    verifyAttempts = [x for x in verifyAttempts if x.payl()["lvlset"] == lvlset and x.payl()["lvlid"] == lvlid and (workerId is None or x.payl()["workerId"] == workerId)]
    if (len(verifyAttempts) > 0):
      return verifyAttempts[-1].payl()
    else:
      return None

#TODO: This is very hacky. Either delete or make more robust
def divisionToMul(inv: AstExpr) -> AstExpr:
    if isinstance(inv, AstBinExpr) and \
       inv.op in ['==', '<', '>', '<=', '>=', '!==']:
        if (isinstance(inv.lhs, AstBinExpr) and inv.lhs.op == 'div' and \
                isinstance(inv.lhs.rhs, AstNumber)):
                    return AstBinExpr(inv.lhs.lhs, inv.op, \
                                      AstBinExpr(inv.rhs, '*', inv.lhs.rhs))

        if (isinstance(inv.rhs, AstBinExpr) and inv.rhs.op == 'div' and \
                isinstance(inv.rhs.rhs, AstNumber)):
                    return AstBinExpr(AstBinExpr(inv.lhs, "*", inv.rhs.rhs), \
                                      inv.op, inv.rhs.lhs)
    return inv

columnSwaps = {
  2: [[0, 1]],
  3: [[0, 1, 2],
      [0, 2, 1]],
  4: [[0, 1, 2, 3],
      [2, 0, 3, 1]],
  5: [[0, 1, 2, 3, 4],
      [1, 3, 0, 4, 2],
      [3, 1, 4, 2, 0]]
}

def swapColumns(row: List[T], nSwap: int) -> List[T]:
  return [row[i] for i in columnSwaps[len(row)][nSwap]]

## API Entry Points ##################################################
@api.method("App.logEvent")
@pp_exc
@log_d(str,str,str,pp_mturkId, str)
def logEvent(workerId: str, name: str, data: Any, mturkId: Any):
    """ Log an event from either the frontend or backend. Event appears
        as JSON in both the textual log, as well as in the database """
    session: Session = sessionF()
    addEvent(workerId, name, time(), args.ename, request.remote_addr, \
             data, session, mturkId)
    return None

@api.method("App.getTutorialDone")
@pp_exc
@log_d(str, str)
def getTutorialDone(workerId: str) -> bool:
    """ Return whether a given user has done the tutorial. Called from
        mturk_landing.html """
    if workerId == "":
        return False
    session: Session = sessionF()
    return tutorialDoneBy(session, workerId)
    


@api.method("App.loadLvl")
@pp_exc
@log_d(str, str, pp_mturkId, str, pp_BoogieLvl)
def loadLvl(levelSet: str, lvlId: str, mturkId: MturkIdT, individualMode:bool = False) -> BoogieTraceLvl:
    """ Load a given level. """
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + levelSet)

    if (lvlId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + lvlId + " in levels " + levelSet)

    lvl = traces[levelSet][lvlId]
    assert 'program' in lvl
    lvl = {
            'lvlSet': levelSet,
            'id': lvlId,
            'variables': lvl['variables'],
            'data': lvl['data'],
    }

    if args.colSwap:
      nCols = len(lvl["variables"])
      if nCols not in columnSwaps:
        raise Exception("No column swap for %d columns" % nCols)

      nSwaps = (nCols + 1) // 2 # swaps are 0 to nSwaps - 1 inclusive

      session = sessionF()

      colSwaps: List[int] = [0] * nSwaps
      if individualMode:
        workerId = mturkId[0]
        allInvs(session, enames=[args.ename], lvlsets=[curLevelSetName],
          lvls=[lvlId], workers=[workerId], colSwaps=colSwaps)
      else:
        allInvs(session, enames=[args.ename], lvlsets=[curLevelSetName],
          lvls=[lvlId], colSwaps=colSwaps)
      sortKeys = colSwaps

      nSwap = sorted(zip(sortKeys, list(range(nSwaps))), key=lambda x: x[0])[0][1]
      lvl["colSwap"] = nSwap
      lvl["variables"] = swapColumns(lvl["variables"], nSwap)
      lvl["data"] = [[swapColumns(row, nSwap) for row in rows]
        for rows in lvl["data"]]

    lvl["startingInvs"] = []
    if args.replay:
      # Only show players their own invariants, even if individual mode is off
      invs = allInvs(session, enames=[args.ename], lvlsets=[curLevelSetName],
        lvls=[lvlId], workers=[workerId])

      lvl["startingInvs"] = [(inv[0], boogieToEsprima(parseExprAst(inv[1])))
        for inv in invs]

    return lvl


@api.method("App.loadNextLvlFacebook")
@pp_exc
@log_d(str, pp_mturkId, str, pp_BoogieLvl)
def loadNextLvl(workerId: str, mturkId: MturkIdT, individualMode: bool) -> Optional[BoogieTraceLvl]:
    """ Return the next level. """
    assignmentId = mturkId[2]
    session = sessionF()
    level_names = list(traces[curLevelSetName].keys())
    i=0
    for lvlId in level_names :
        i += 1
        if levelFinishedBy(session, curLevelSetName, lvlId, workerId):
            continue
        result = loadLvl(curLevelSetName, lvlId, mturkId, individualMode)
        result['LevelNumber'] = i 
        if i>2 and (not questionaireDoneBy(session, curLevelSetName, lvlId, workerId)):
            result['ShowQuestionaire'] = True
        return result
    return None

@api.method("App.equivalentPairs")
@pp_exc
@log_d(pp_EsprimaInvs, pp_EsprimaInvs, str, pp_mturkId, pp_EsprimaInvPairs)
def equivalentPairs(
  invL1: List[EsprimaNode],
  invL2: List[EsprimaNode],
  typeEnv: JSONTypeEnv,
  mturkId: MturkIdT
  ) -> List[Tuple[EsprimaNode, EsprimaNode]]: #pylint: disable=unused-argument
    """ 
        Given lists of invariants invL1, invL2, return all pairs (I1, I2)
        where I1 <==> I2, I1 \in invL1, I2 \in invL2 

        Not currently in use.
    """ 
    boogieEnv: BoogieTypeEnv = jsonToTypeEnv(typeEnv)
    z3Env : Z3TypeEnv = boogieToZ3TypeEnv(boogieEnv)
    z3InvL1 = [esprimaToZ3(x, z3Env) for x in invL1]
    z3InvL2 = [esprimaToZ3(x, z3Env) for x in invL2]

    res = []
    for x in z3InvL1:
      for y in z3InvL2:
        try:
          equiv = equivalent(x, y)
        except Unknown:
          equiv = False # Conservative assumption

        if (equiv):
          res.append((x,y))

    return [(boogieToEsprima(z3_expr_to_boogie(x)),
            boogieToEsprima(z3_expr_to_boogie(y))) for (x,y) in res]

@api.method("App.impliedPairs")
@pp_exc
@log_d(pp_EsprimaInvs, pp_EsprimaInvs, str, pp_mturkId, pp_EsprimaInvPairs)
def impliedPairs(
  invL1: List[EsprimaNode],
  invL2: List[EsprimaNode],
  typeEnv: JSONTypeEnv,
  mturkId: MturkIdT
  ) -> List[Tuple[EsprimaNode, EsprimaNode]]: #pylint: disable=unused-argument
    """ 
        Given lists of invariants invL1, invL2, return all pairs (I1, I2)
        where I1 ==> I2, I1 \in invL1, I2 \in invL2 

        Used by game.html
    """ 
    boogieEnv = jsonToTypeEnv(typeEnv)
    z3Env = boogieToZ3TypeEnv(boogieEnv)
    z3InvL1 = [esprimaToZ3(x, z3Env) for x in invL1]
    z3InvL2 = [esprimaToZ3(x, z3Env) for x in invL2]

    res = []
    for x in z3InvL1:
      for y in z3InvL2:
        try:
          impl = implies(x, y)
        except Unknown:
          impl = False # Conservative assumption

        if (impl):
          res.append((x,y))

    return [(boogieToEsprima(z3_expr_to_boogie(x)),
            boogieToEsprima(z3_expr_to_boogie(y))) for (x,y) in res]

@api.method("App.isTautology")
@pp_exc
@log_d(pp_EsprimaInv, pp_mturkId, str)
def isTautology(inv: EsprimaNode, typeEnv: JSONTypeEnv, mturkId: MturkIdT): #pylint: disable=unused-argument
    """ 
        Check whether the invariant inv is a tautology.
        Used by game.html
    """ 
    boogieEnv = jsonToTypeEnv(typeEnv)
    z3Env = boogieToZ3TypeEnv(boogieEnv)

    try:
      res = (tautology(esprimaToZ3(inv, z3Env)))
      return res
    except Unknown:
      return False # Conservative assumption

StoreArr = List[BoogieVal]
@api.method("App.tryAndVerify")
@pp_exc
@log_d(str, str, pp_EsprimaInvs, pp_mturkId, str, pp_tryAndVerifyRes)
def tryAndVerify(
  levelSet: str,
  levelId: str,
  invs: List[EsprimaNode],
  mturkId: MturkIdT,
  individualMode: bool
  ) -> Tuple[List[Tuple[EsprimaNode, StoreArr]],\
             List[Tuple[EsprimaNode, Tuple[StoreArr, StoreArr]]],\
             List[EsprimaNode],\
             List[StoreArr],
             List[StoreArr]]:
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
    s = sessionF()
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + str(levelSet))

    if (levelId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + str(levelId) + \
                        " in levels " + str(levelSet))

    if (len(invs) == 0):
        raise Exception("No invariants given")

    lvl: BoogieTraceLvl = traces[levelSet][levelId]

    assert 'program' in lvl
    workerId, _, _ = mturkId
    userInvs = set([ esprimaToBoogie(x, {}) for x in invs ])
    otherInvs: Set[AstExpr] = set([])
    lastVer = getLastVerResult(levelSet, levelId, s,
      workerId=(workerId if individualMode else None))

    if (lastVer):
      otherInvs = otherInvs.union([parseExprAst(x) for x in lastVer["sound"]])
      otherInvs = otherInvs.union([parseExprAst(x) for x in lastVer["nonind"]])

    ((overfitted, _), (nonind, _), sound, violations) = \
      tryAndVerifyLvl(lvl, userInvs, otherInvs, args.timeout)

    # See if the level is solved
    solved = len(violations) == 0
    fix = lambda x: _from_dict(lvl['variables'], x, 0)
    # TODO: Why is this shit needed?
    if (not solved):
        fun: Function = lvl["program"]
        direct_ctrexs = loopInvSafetyCtrex(fun, otherInvs.union(userInvs),\
                                           args.timeout)
    else:
        direct_ctrexs = []

    # Convert all invariants from Boogie to esprima expressions, and
    # counterexamples to arrays
    # from dictionaries
    overfittedEsp = [ (boogieToEsprima(inv), fix(v.endEnv()))
      for (inv, v) in overfitted ]
    nonindEsp = [ (boogieToEsprima(inv), (fix(v.startEnv()), fix(v.endEnv())))
      for (inv, v) in nonind ]
    soundEsp = [ boogieToEsprima(inv) for inv in sound ]
    safetyCtrexsArr = [ fix(v.startEnv()) for v in violations ]
    directCtrexsArr = [ fix(v) for v in direct_ctrexs ]
    res = (overfittedEsp, nonindEsp, soundEsp, safetyCtrexsArr, directCtrexsArr)

    # Log verification result in Db (storing invariants as boogie strings)
    payl = {
      "lvlset": levelSet,
      "lvlid": levelId,
      "overfitted":nodups([str(inv) for (inv, _) in overfitted]),
      "nonind":nodups([str(inv) for (inv,_) in nonind]),
      "sound":nodups([str(inv) for inv in sound]),
      "post_ctrex":safetyCtrexsArr,
      "direct_ctrex": directCtrexsArr
    }
    addEvent("verifier", "VerifyAttempt", time(), args.ename, \
             "localhost", payl, s, mturkId)

    return res

@api.method("App.simplifyInv")
@pp_exc
@log_d(pp_EsprimaInv, str, pp_mturkId, pp_EsprimaInv)
def simplifyInv(inv: EsprimaNode, typeEnv: JSONTypeEnv, mturkId: MturkIdT) -> EsprimaNode: #pylint: disable=unused-argument
    """ Given an invariant inv return its 'simplified' version. We
        treat that as the canonical version of an invariant. Simplification
        is performed by z3 """
    boogieEnv = jsonToTypeEnv(typeEnv)
    z3Env = boogieToZ3TypeEnv(boogieEnv)

    boogieInv = esprimaToBoogie(inv, {})
    noDivBoogie = divisionToMul(boogieInv)
    z3_inv = expr_to_z3(noDivBoogie, z3Env)
    simpl_z3_inv = ccast(simplify(z3_inv, arith_lhs=True), z3.ExprRef)
    simpl_boogie_inv = z3_expr_to_boogie(simpl_z3_inv)
    return boogieToEsprima(simpl_boogie_inv)

@api.method("App.getRandomCode")
@pp_exc
@log_d(str)
def getRandomCode() -> str:
    return randomToken(5)

kvStore : Dict[str, Tuple[int, Any]] = { }

@api.method("App.get")
@pp_exc
@log_d(str)
def getVal(key: str) -> Any:
    """ Generic Key/Value store get() used by two-player gameplay for
        synchronizing shared state. 
    """
    if (type(key) != str):
      raise Exception("Key must be string")

    return kvStore[key]

@api.method("App.set")
@pp_exc
@log_d(str, str, str)
def setVal(key: str, val: Any, expectedGen: int) -> Tuple[int, Any]:
    """ Generic Key/Value store set() used by two-player gameplay for
        synchronizing shared state. 
    """
    if (type(key) != str):
      raise Exception("Key must be string")

    if (expectedGen != -1):
      (curGen, curVal) = kvStore[key]
    else:
      if (key in kvStore):
        raise Exception("Trying to add a new key with gen 0 " + \
                        "but key already there: " + key)

    if (expectedGen != -1 and curGen != expectedGen):
      return (curGen, curVal)
    else:
      kvStore[key] = (expectedGen + 1, val)
      return (expectedGen + 1, val)

@api.method("App.reportProblem")
@pp_exc
@log_d(pp_mturkId, str, str, str)
def reportProblem(mturkId: MturkIdT, lvl: str, desc: str) -> None:
  """ Accept a problem report from a player and send it to the current
      notification e-mail address.
  """
  #lines = []
  #lines.append("A problem report has been submitted.")
  #lines.append("")
  #lines.append("Time: %s" % datetime.now().strftime("%a, %d %b %Y %H:%M:%S %Z"))
  #lines.append("HIT: %s" % mturkId[1])
  #lines.append("Worker: %s" % mturkId[0])
  #lines.append("Experiment: %s" % args.ename)
  #lines.append("Level: %s" % lvl)
  #lines.append("Problem description:")
  #lines.append("")
  #lines.append(desc)

  session = sessionF()
  addEvent(mturkId[0], "SupportForm", time(), args.ename, request.remote_addr, \
           desc, session, mturkId)
  return None

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="invariant gen game server")
    p.add_argument('--local', action='store_true',
            help='Run without SSL for local testing')
    p.add_argument('--log', type=str,
            help='an optional log file to store all user actions. ' + 'Entries are stored in JSON format.')
    p.add_argument('--port', type=int, help='an optional port number')
    p.add_argument('--ename', type=str, default='default',
            help='Name for experiment; if none provided, use "default"')
    p.add_argument('--lvlset', type=str, \
            default='lvlsets/unsolved.lvlset',
            help='Lvlset to use for serving benchmarks"')
    p.add_argument('--db', type=str, help='Path to database', required=True)
    p.add_argument('--adminToken', type=str,
            help='Secret token for logging in to admin interface. ' + 'If omitted will be randomly generated')
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

    args = p.parse_args()
    if ('mysql+pymysql://' in args.db):
      #if ('mysql+mysqldb://' in args.db):
      sessionF = open_mysql_db(args.db)
    else:
      sessionF = open_sqlite_db(args.db)

    if (args.adminToken):
      adminToken = args.adminToken
    else:
      adminToken = randomToken(5)

    if args.log:
        openLog(args.log)

    MYDIR: str = dirname(abspath(realpath(__file__)))
    ROOT_DIR: str = dirname(MYDIR)

    if args.local:
      #host = '127.0.0.1'
      host: str = '0.0.0.0'
      sslContext: Optional[Tuple[str, str]] = None
    else:
      host = '0.0.0.0'
      sslContext = None # MYDIR + '/cert.pem', MYDIR + '/privkey.pem'

    curLevelSetName, lvls = loadBoogieLvlSet(args.lvlset)
    traces = { curLevelSetName: lvls }

    print("Admin Token: ", adminToken)
    print("Admin URL: ", "admin.html?adminToken=" + adminToken)
    app.run(host=host, port=args.port, ssl_context=sslContext, threaded=True)
