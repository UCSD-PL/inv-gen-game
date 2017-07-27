#!/usr/bin/env python2.7

from argparse import ArgumentParser

from db_util import allInvs
from levels import loadBoogieFile
from lib.boogie.ast import parseExprAst
from models import open_sqlite_db, open_mysql_db
from vc_check import tryAndVerifyLvl

def verify(lvl, invs, timeout=None):
  (overfitted, _), (nonind, _), sound, violations = tryAndVerifyLvl(lvl, invs,
    set(), timeout)

  print "OVERFITTED:", overfitted
  print "NONIND:", nonind
  print "SOUND:", sound
  print "VIOLATIONS:", violations
  print
  print "SOLVED:", not len(violations)

if __name__ == "__main__":
  p = ArgumentParser(description="Verify a level using selected invariants")
  p.add_argument("--additionalInvs",
    help="A .csv file with additional invariants")
  p.add_argument("--bpl", required=True,
    help="A desugared .bpl file for the level to verify")
  p.add_argument("--db", required=True,
    help="The event database to use")
  p.add_argument("--enames", nargs="*",
    help="Include experiment invs; may specify multiple items (unset = any)")
  p.add_argument("--lvls", nargs="*",
    help="Include level invs; may specify multiple items (unset = any)")
  p.add_argument("--lvlsets", nargs="*",
    help="Include lvlset invs; may specify multiple items (unset = any)")
  p.add_argument("--timeout", type=int, default=30,
    help="The maximum time (in seconds) to wait for Z3 queries")
  p.add_argument("--workers", nargs="*",
    help="Include worker invs; may specify multiple items (unset = any)")

  args = p.parse_args()

  if "mysql+mysqldb://" in args.db:
    sessionF = open_mysql_db(args.db)
  else:
    sessionF = open_sqlite_db(args.db)
  s = sessionF()

  try:
    lvl = loadBoogieFile(args.bpl, False)
  except Exception as e:
    print "Couldn't load boogie file--is it desugared?"
    raise e

  if args.additionalInvs:
    print "Additional invariants not yet implemented" # TODO
    exit(1)

  actualEnames = set()
  actualLvls = set()
  actualLvlsets = set()
  actualWorkers = set()
  dbInvs = allInvs(s, args.enames, args.lvls, args.lvlsets, args.workers,
    actualEnames, actualLvls, actualLvlsets, actualWorkers)

  invs = set(parseExprAst(inv) for inv in dbInvs)

  print "ENAMES:", ", ".join(actualEnames)
  print "LVLS:", ", ".join(actualLvls)
  print "LVLSETS:", ", ".join(actualLvlsets)
  if len(actualWorkers) < 6:
    print "WORKERS:", ", ".join(actualWorkers)
  else:
    print "UNIQUE WORKERS:", len(actualWorkers)
  print "UNIQUE INVARIANTS:", len(invs)
  print

  verify(lvl, invs, args.timeout)
