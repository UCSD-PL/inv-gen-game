#!/usr/bin/env python

import argparse
import boogie.ast
import levels
import tabulate
from boogie.eval import *
from boogie.ast import *
from js import *
from models import *
from os import listdir
from json import load, dumps
from util import powerset, nonempty
from time import time
from vc_check import tryAndVerify_impl

p = argparse.ArgumentParser(description="trace dumper")
p.add_argument("--lvlset", type=str, default="single-loop-conditionals",
  help="lvlset to use for benchmarks")
p.add_argument("--db", type=str,
  help="path to db")

args = p.parse_args()

# Process arguments
curLevelSetName, lvls = levels.loadBoogieLvlSet(args.lvlset)
src = open_sqlite_db(args.db);

invs = { lvl_name: set() for lvl_name in lvls }

# Load all found invariants
for inv_evt in src.query(Event).all():
  if inv_evt.type != "FoundInvariant":  continue
  pl = inv_evt.payl()
  if pl["lvlset"] != curLevelSetName:
    continue

  invs[pl["lvlid"]].add(pl["canonical"])
nchecks = 0

def reduction(a,b):
  return 100.0 * (a-b)/(1.0 * a)

precond_ok = { }
added = { }
# For each level in the level set
for lvl in invs:
  loop = lvls[lvl]["loop"]
  bbs = lvls[lvl]["program"]

  print "Lvl: ", lvl
  parseStart = time()
  invs[lvl] = [ parseExprAst(x)[0] for x in invs[lvl] ]
  parseEnd = time()

  if (len(invs[lvl]) == 0):       continue

  # Add derived conditional invariants
  splitterPreds = lvls[lvl]['splitterPreds'] if 'splitterPreds' in lvls[lvl] else [ ] 
  partialInv = lvls[lvl]['partialInv']
  candidate_antecedents = [ ast_and(pSet) for pSet in nonempty(powerset(splitterPreds)) ]
  print "Time to parse: ", parseEnd-parseStart, "parse per inv: ", (parseEnd-parseStart)/len(invs[lvl])

  cond_invs = [ AstBinExpr(antec, "==>", inv)\
    for antec in candidate_antecedents\
    for inv in invs[lvl] ]

  print "Starting with ", len(invs[lvl]), " adding ", len(cond_invs), "from implications"
  invs[lvl] = invs[lvl] + cond_invs
  added[lvl] = len(cond_invs)

  # Remove any invariants not implied by the precondition
  overf, nonind, sound = tryAndVerify_impl(bbs, loop, [partialInv], invs[lvl], 10)
  print len(invs[lvl]), "tried", len(overf), "removed by prec", len(nonind), "nonind", len(sound), "sound"
  print "Sound inv for lvl", lvl,"is", " && ".join([str(x) for x in sound])
