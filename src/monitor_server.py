#!/usr/bin/env python
import argparse
import json
import sys
from atexit import register
from os.path import dirname, abspath, realpath

from flask import Flask
from flask_jsonrpc import JSONRPC as rpc
from sqlalchemy import case, func

from lib.common.util import pp_exc, randomToken
from models import open_sqlite_db, open_mysql_db, Event, LvlData
from server_common import openLog, log_d

class Server(Flask):
  def get_send_file_max_age(self, name):
    if name in [
      "jquery-1.12.0.min.js",
      "jquery-migrate-1.2.1.min.js",
      "jquery.jsonrpcclient.js"
      ]:
      return 100000
    return 0

app = Server(__name__, static_folder="static/", static_url_path="")
api = rpc(app, "/api")

@api.method("App.getDashboard")
@pp_exc
@log_d()
def getDashboard(inputToken):
  """ Return data for the dashboard view; only used by the dashboard.
  """
  if inputToken != adminToken:
    raise Exception(str(inputToken) + " not a valid token.")

  s = sessionF()
  rows = s.query(
      LvlData.experiment,
      LvlData.lvl,
      # count includes all non-null values, so we need case to exclude values
      # that do not match (the default case returns null)
      func.count(case({1: 1}, value=LvlData.startflag)),
      func.count(case({0: 1}, value=LvlData.startflag)),
      func.count(case({1: 1}, value=LvlData.provedflag))
    ) \
    .group_by(LvlData.experiment, LvlData.lvl)

  return [ dict(zip([
      "experiment",
      "lvl",
      "nStarted",
      "nFinished",
      "nProved"
    ], r)) for r in rows ]

@api.method("App.getDashboardInvs")
@pp_exc
@log_d()
def getDashboardInvs(inputToken, experiment, lvl):
  """ Return invariants for the dashboard view; only used by the dashboard.
  """
  if inputToken != adminToken:
    raise Exception(str(inputToken) + " not a valid token.")

  s = sessionF()
  rows = s.query(
      LvlData.hit,
      LvlData.allinvs
    ) \
    .filter(
      LvlData.experiment == experiment,
      LvlData.lvl == lvl,
      LvlData.startflag == 0
    )

  d = dict()
  for hit, allinvs in rows:
    try:
      invs = d[hit]
    except KeyError:
      invs = d[hit] = []
    invs.extend(i[0] for i in json.loads(allinvs))

  return d

if __name__ == "__main__":
  p = argparse.ArgumentParser(description="experiment monitor server")
  p.add_argument("--local", action="store_true",
    help="Run without SSL for local testing")
  p.add_argument("--port", type=int,
    help="An optional port number")
  p.add_argument("--db", type=str, required=True,
    help="Path to database")
  p.add_argument("--adminToken", type=str,
    help="Secret token for admin interface; randomly generated if omitted")

  args = p.parse_args()

  if "mysql+mysqldb://" in args.db:
    sessionF = open_mysql_db(args.db)
  else:
    sessionF = open_sqlite_db(args.db)

  if args.adminToken:
    adminToken = args.adminToken
  else:
    adminToken = randomToken(5)

  MYDIR = dirname(abspath(realpath(__file__)))
  ROOT_DIR = dirname(MYDIR)

  if args.local:
    host = "127.0.0.1"
    sslContext = None
  else:
    host = "0.0.0.0"
    sslContext = MYDIR + "/cert.pem", MYDIR + "/privkey.pem"

  print "Admin Token:", adminToken
  print "Dashboard URL:", "dashboard.html?adminToken=" + adminToken
  app.run(host=host, port=args.port, ssl_context=sslContext, threaded=True)
