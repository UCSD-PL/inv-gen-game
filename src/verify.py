#!/usr/bin/env python2.7

from argparse import ArgumentParser
import csv

from db_util import allInvs
from levels import loadBoogieFile, loadBoogieLvlSet
from lib.boogie.ast import parseExprAst
from lib.boogie.z3_embed import AllIntTypeEnv, Unknown, expr_to_z3, tautology
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

def processLevel(args, lvl, lvlName=None, additionalInvs=[]):
  lvls = args.lvls if lvlName is None else [lvlName]

  actualEnames = set()
  actualLvls = set()
  actualLvlsets = set()
  actualWorkers = set()
  dbInvs = allInvs(s, enames=args.enames, lvls=lvls, lvlsets=args.lvlsets,
    workers=args.workers, enameSet=actualEnames, lvlSet=actualLvls,
    lvlsetSet=actualLvlsets, workerSet=actualWorkers)

  invs = set(parseExprAst(inv[1]) for inv in dbInvs)
  invs.update(additionalInvs)

  if lvlName is not None:
    print "_" * 40
    print "RESULTS FOR LEVEL", lvlName
    print
  print "ENAMES:", ", ".join(actualEnames)
  print "LVLS:", ", ".join(actualLvls)
  print "LVLSETS:", ", ".join(actualLvlsets)
  if len(actualWorkers) < 6:
    print "WORKERS:", ", ".join(actualWorkers)
  else:
    print "UNIQUE WORKERS:", len(actualWorkers)
  if len(additionalInvs) < 6:
    print "ADDITIONAL INVARIANTS:", ", ".join(additionalInvs)
  else:
    print "ADDITIONAL INVARIANTS:", len(additionalInvs)
  print "UNIQUE INVARIANTS:", len(invs)
  print

  verify(lvl, invs, args.timeout)

if __name__ == "__main__":
  p = ArgumentParser(description="Verify a level using selected invariants")
  p.add_argument("--additionalInvs",
    help="A .csv file with additional invariants")
  p.add_argument("--bpl",
    help="A desugared .bpl file for the level to verify")
  p.add_argument("--db", required=True,
    help="The event database to use")
  p.add_argument("--enames", nargs="*",
    help="Include experiment invs; may specify multiple items (unset = any)")
  p.add_argument("--lvls", nargs="*",
    help="Include level invs; may specify multiple items (unset = any)")
  p.add_argument("--lvlset",
    help="A levelset file to load levels from")
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

  if args.bpl:
    try:
      lvl = loadBoogieFile(args.bpl, False)
    except Exception as e:
      print "Couldn't load boogie file--is it desugared?"
      raise e
  elif args.lvlset:
    lvlset, lvls = loadBoogieLvlSet(args.lvlset)
  else:
    print "Either --bpl or --lvlset must be specified"
    exit(1)

  additionalInvs = {}
  if args.additionalInvs:
    with open(args.additionalInvs) as f:
      r = csv.reader(f, delimiter=",")
      for row in r:
        lvl, invlist = row
        invs = []
        for invstr in invlist.split(";"):
          if not len(invstr.strip()):
            continuer
          try:
            inv = parseExprAst(invstr)
            if tautology(expr_to_z3(inv, AllIntTypeEnv())):
              continue
          except RuntimeError:
            # Some invariants are too large to parse
            continue
          except Unknown:
            # Timeouts could be valid invariants
            pass
          invs.append(inv)
        additionalInvs[lvl] = invs

  print "ADDITIONAL INVARIANTS LOADED FOR LVLS:", \
    ", ".join(additionalInvs.keys())

  if args.bpl:
    processLevel(args, lvl)
  elif args.lvlset:
    for lvlName, lvl in lvls.items():
      processLevel(args, lvl, lvlName, additionalInvs.get(lvlName, []))
