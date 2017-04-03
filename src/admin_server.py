#! /usr/bin/env python
from flask import Flask
from flask import request
from flask_jsonrpc import JSONRPC as rpc
from os.path import *
from json import dumps
from js import esprimaToZ3, esprimaToBoogie, boogieToEsprima
from lib.boogie.ast import AstBinExpr, AstTrue, ast_and, parseExprAst
from lib.common.util import pp_exc, powerset, split, nonempty
from lib.boogie.eval import instantiateAndEval, _to_dict
from lib.boogie.z3_embed import expr_to_z3, AllIntTypeEnv, z3_expr_to_boogie, Unknown, z3CacheStats
from lib.boogie.analysis import propagate_sp
from sys import exc_info
from cProfile import Profile
from pstats import Stats
from StringIO import StringIO
from random import choice

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
from atexit import register

colorama_init();

p = argparse.ArgumentParser(description="invariant gen game server")
p.add_argument('--port', type=int, help='a optional port number', default=12345)
p.add_argument('--ename', type=str, default = 'default', help='Name for experiment; if none provided, use "default"')
p.add_argument('--lvlset', type=str, default = 'desugared-boogie-benchmarks', help='Lvlset to use for serving benchmarks"')
p.add_argument('--db', type=str, help='Path to database', default=None)
p.add_argument('--adminToken', type=str, help='Secret token for logging in to admin interface. If omitted will be randomly generated')
p.add_argument('--timeout', type=int, default=60, help='Timeout in seconds for z3 queries.')

args = p.parse_args();
logF = None;

if (not args.db):
  db = join("..", "logs", args.ename, "events.db")
else:
  db = args.db

sessionF = open_sqlite_db(db)

invs = { }
players = { }

alphanum = "".join([chr(ord('a') + i) for i in range(26) ] + [ str(i) for i in range(0,10)])
if (args.adminToken):
  adminToken = args.adminToken
else:
  adminToken = "".join([ choice(alphanum) for x in xrange(5) ]);

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
    print "Admin Token: ", adminToken
    print "Admin URL: ", "admin.html?adminToken=" + adminToken
    app.run(host='0.0.0.0',port=args.port,ssl_context=(MYDIR + '/cert.pem', MYDIR + '/privkey.pem'), threaded=True)
