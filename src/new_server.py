#! /usr/bin/env python
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
from pyboogie.z3_embed import expr_to_z3, z3_expr_to_boogie,\
        Unknown, simplify, implies, equivalent, tautology, boogieToZ3TypeEnv,\
        Z3TypeEnv
from pyboogie.analysis import propagateUnmodifiedPreds 
from pyboogie.interp import BoogieVal
from pyboogie.inv_networks import Violation, checkInvNetwork

# Local repo includes
from lib.common.util import powerset, split, nonempty, nodups, \
        randomToken, ccast, fatal
from lib.invgame_server.js import esprimaToZ3, esprimaToBoogie, boogieToEsprima, \
        boogieToEsprimaExpr, jsonToTypeEnv, JSONTypeEnv, EsprimaNode, \
        typeEnvToJson
from lib.flowgame_server.levels import loadLvlSet, FlowgameLevel
from lib.invgame_server.models import open_sqlite_db, open_mysql_db, Event
from lib.invgame_server.db_util import addEvent, allInvs, levelSolved, levelFinishedBy,\
        levelSkipCount, levelsPlayedInSession, tutorialDoneBy, questionaireDoneBy,\
        MturkIdT
from lib.invgame_server.server_common import openLog, log, log_d, pp_exc

# Typing includes
from typing import Dict, Any, Optional, TypeVar, List, Tuple, Set
T = TypeVar("T")

class Server(Flask):
    def get_send_file_max_age(self, name: str) -> int:
        if (name in [ 'jquery-1.12.0.min.js', \
                      'jquery-migrate-1.2.1.min.js', \
                      'jquery.jsonrpcclient.js']):
            return 100000

        return 0

app = Server(__name__, static_folder='frontend/', static_url_path='/game')
api = rpc(app, '/api')

traces : Dict[str, Dict[str, FlowgameLevel]] = {}
## Utility functions #################################################

def divisionToMul(inv: AstExpr) -> AstExpr:
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

def getLvl(levelSet: str, lvlId: str) -> FlowgameLevel:
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + levelSet)

    if (lvlId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + lvlId + " in levels " + levelSet)

    return traces[levelSet][lvlId]

## API Entry Points ##################################################
@api.method("App.logEvent")
@pp_exc
def logEvent(workerId: str, name: str, data: Any, mturkId: MturkIdT) -> None:
    """ Log an event from either the frontend or backend. Event appears
        as JSON in both the textual log, as well as in the database """
    session = sessionF()
    addEvent(workerId, name, time(), args.ename, request.remote_addr, \
             data, session, mturkId);
    return None

@api.method("App.loadLvl")
@pp_exc
def loadLvl(levelSet: str, lvlId: str, mturkId: MturkIdT) -> Any: #pylint: disable=unused-argument
    """ Load a given level. """
    lvl: FlowgameLevel = getLvl(levelSet, lvlId)
    res = lvl.to_json()
    res["lvlSet"] = levelSet
    return res

@api.method("App.loadNextLvl")
@pp_exc
def loadNextLvl(workerId: str, mturkId: MturkIdT) -> Any:
    """ Return the next level. """
    assignmentId = mturkId[2]
    session = sessionF()
    level_names = list(traces[curLevelSetName].keys())
    i=0
    for lvlId in level_names :
        i += 1
        if levelFinishedBy(session, curLevelSetName, lvlId, workerId):
            continue
        result = loadLvl(curLevelSetName, lvlId, mturkId)
        return result
    return None


@api.method("App.equivalentPairs")
@pp_exc
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


@api.method("App.checkSoundness")
@pp_exc
def checkSoundness(levelSet: str, levelId: str, rawInvs: Dict[str, List[EsprimaNode]], mturkId: MturkIdT) -> List[Any]:
    lvl: FlowgameLevel = getLvl(levelSet, levelId)

    invs: Dict[str, Set[AstExpr]] = {
      label: set(esprimaToBoogie(inv, lvl._fun.getTypeEnv()) for inv in rawExps)
        for (label, rawExps) in rawInvs.items()
    }

    print ("invs: ", invs)

    res = checkInvNetwork(lvl._fun, AstTrue(), AstTrue(), invs, args.timeout)

    print ("res: ", res)
    return [v.to_json() for v in res]

@api.method("App.simplifyInv")
@pp_exc
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

@api.method("App.reportProblem")
@pp_exc
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
    p.add_argument('--log', type=str,
            help='an optional log file to store all user actions. ' +
                 'Entries are stored in JSON format.')
    p.add_argument('--port', type=int, help='an optional port number. Defaults to 8080', default=8080)
    p.add_argument('--host', type=str,
            help='Optional hostname. Defaults to 127.0.0.1', default='127.0.0.1')
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
    p.add_argument('--ssl-key', type=str,
            help='Path to ssl .key file')
    p.add_argument('--ssl-cert', type=str,
            help='Path to ssl .cert file')

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

    if args.ssl_key is not None or args.ssl_cert is not None:
        if (args.ssl_key is None or args.ssl_cert is None):
            fatal("Error: can't speciy only --ssl-cert or --ssl-key. Need both");
        sslContext: Optional[Tuple[str, str]] = (args.ssl_key, args.ssl_cert)
    else:
        sslContext = None

    sslContext = None;
    host = args.host

    curLevelSetName, lvls = loadLvlSet(args.lvlset)
    traces  = { curLevelSetName: lvls }

    print("Admin Token: ", adminToken)
    print("Admin URL: ", "admin.html?adminToken=" + adminToken)
    app.run(host=host, port=args.port, ssl_context=sslContext, threaded=True)
