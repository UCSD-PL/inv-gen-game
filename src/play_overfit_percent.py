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
from json import load
from util import powerset, nonempty
from time import time
from boogie_loops import loop_vc_pre_ctrex
from vc_check import tryAndVerify_impl

p = argparse.ArgumentParser(description="trace dumper")
p.add_argument("--lvlset", type=str, default="single-loop-conditionals",
  help="lvlset to use for benchmarks")
p.add_argument("--db", type=str,
  help="path to db")

args = p.parse_args()

def getLoopHeaderFuzzVals(lvl_path):
  assert lvl_path[-4:] == ".bpl"
  traces = [ ]
  baseDir = lvl_path[:-4] + ".fuzz_traces/"
  for d in listdir(baseDir):
    print baseDir + d
    t = load(open(baseDir + d))
    t1 = [ ]
    for (bb_name, vals) in t:
      if not bb_name.endswith("_LoopHead"): continue
      t1.append(vals[0])
    traces.append(t1)
  return traces

# Process arguments
curLevelSetName, lvls = levels.loadBoogieLvlSet(args.lvlset)
src = open_sqlite_db(args.db);

invs = { lvl_name: set() for lvl_name in lvls }
traces = { lvl_name: getLoopHeaderFuzzVals(lvls[lvl_name]["path"]) for lvl_name in lvls }
for inv_evt in src.query(Event).all():
  if inv_evt.type != "FoundInvariant":  continue
  pl = inv_evt.payl()
  if pl["lvlset"] != curLevelSetName:
    print pl["lvlset"] 
    continue

  invs[pl["lvlid"]].add(pl["canonical"])
nchecks = 0

def contradicted(inv, traces):
  global nchecks
  for trace in traces:
    for row in trace:
      nchecks += 1;
      if not evalPred(x,row):
        return True;
  return False;

def reduction(a,b):
  return 100.0 * (a-b)/(1.0 * a)
  
non_contr = { }
precond_ok = { }
added = { }
for lvl in invs:#['03.0']:
  loop = lvls[lvl]["loop"]
  bbs = lvls[lvl]["program"]

  print "Lvl: ", lvl
  parseStart = time()
  invs[lvl] = [ parseExprAst(x)[0] for x in invs[lvl] ]
  parseEnd = time()

  if (len(invs[lvl]) == 0):       continue
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

  precond_ok[lvl] = [ x for x in invs[lvl] if loop_vc_pre_ctrex(loop, x, bbs) == None ]
  print "Implied by prec: ", len(precond_ok[lvl]), "out of", len(invs[lvl]), "reduction:",\
    reduction(len(invs[lvl]), len(precond_ok[lvl]))
  
  before=nchecks
  checkStart = time()
  non_contr[lvl] = [ x for x in precond_ok[lvl] if not contradicted(x, traces[lvl]) ]
  checkEnd = time()
  after=nchecks
  print (after-before), " checks for ", len(invs[lvl]), " invariants ", 1.0*(after-before)/len(invs[lvl]), " average checks per inv"
  print "Reduction from", len(precond_ok[lvl]), "to", len(non_contr[lvl]), "reduction: ", reduction(len(invs[lvl]),len(non_contr[lvl]))
  print "Time to check: ", checkEnd-checkStart, "check per inv: ", (checkEnd-checkStart)/len(invs[lvl]),   "average check time: ", (checkEnd-checkStart)/(after-before)

  print "Try and verify:"
  overf, nonind, sound = tryAndVerify_impl(bbs, loop, [partialInv], non_contr[lvl], 10)
  print len(sound), "of those are sound"
  print "Sound inv for lvl", lvl,"is", " && ".join([str(x) for x in sound])


ave_red = 0 
num_lvls = 0

for lvl in non_contr:
    if (len(invs[lvl]) == 0):       continue
    print "Total", len(invs[lvl]), "Not contradicted: ", len(non_contr[lvl]), "reduction:", 100*(1-len(non_contr[lvl])*1.0/len(invs[lvl]))
    num_lvls += 1
    ave_red += 100*(1-len(non_contr[lvl])*1.0/len(invs[lvl]))  

print "Average reduction: ", ave_red/num_lvls
