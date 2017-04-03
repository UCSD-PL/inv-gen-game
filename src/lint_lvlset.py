#!/usr/bin/env python
import argparse
import levels
import tabulate
from lib.boogie.eval import *
import lib.boogie.ast as bast
from lib.boogie.z3_embed import *
from vc_check import tryAndVerify_impl
from boogie_loops import *
from re import compile
from lib.common.util import unique
from os.path import exists
import os

p = argparse.ArgumentParser(description="check a lvlset is correctly built")
p.add_argument("--lvlset", type=str, help="lvlset to checl", required=True)
p.add_argument("--timeout", type=int, help="timeout on z3 queries")

args = p.parse_args()
curLevelSetName, lvls = levels.loadBoogieLvlSet(args.lvlset)

def verify(lvl, invs):
  bbs = lvl["program"]
  loop = lvl["loop"]

  return tryAndVerify_impl(bbs, loop, set([]), set(invs), args.timeout)


def isSolved(lvl, invs):
  (overfitted, nonind, sound, safety_violations) = verify(lvl, invs)
  return len(safety_violations) == 0

print "Checking paths..."
for lvl_name, lvl in lvls.items():
  paths = lvl["path"]
  if (len(paths) < 3):
    print "Missing original boogie path for ", lvl_name
  else:
    if (not(exists(paths[2]))):
      print "Original boogie file for ", lvl_name, ":", paths[2], "is missing"

  if (len(paths) < 2):
    print "Missing C path for ", lvl_name
  else:
    if (not(exists(paths[1]))):
      print "C file for ", lvl_name, ":", paths[1], "is missing"

  if (len(paths) == 0):
    print "Missing desugared boogie file path for", lvl_name;
  else:
    if (not exists(paths[0])):
      print "Desugared boogie for ", lvl_name, ":", paths[0], "is missing";
      
  
print "Checking all solutions work..."
for lvl_name, lvl in lvls.items():
  sol = open(lvl["path"][0].replace(".bpl", ".sol")).read()
  sol = parseExprAst(sol);
  bbs = lvl["program"]
  loop = lvl["loop"]

  try:
    if (not isSolved(lvl, [sol])):
      print lvl_name, "doesn't satisfy solution ", sol, "details:", verify(lvl, [sol])
  except Unknown:
    print "Can't tell for level ", lvl_name
    continue

endsWithNumP = compile(".*\.[0-9]*$")
justEnd = compile("\.[0-9]*$")

originalToSplitM = { }
splitToOriginal = { }

print "Checking that split levels are properly named..."
for lvl_name, lvl in lvls.items():
  if "splitterPreds" in lvl and not endsWithNumP.match(lvl_name):
    print "Print split traces level has name not ending in number: ", lvl_name

  if (endsWithNumP.match(lvl_name) and not "splitterPreds" in lvl):
    print "Print split lvl ", lvl_name, "is missing splitterPreds"

  if (endsWithNumP.match(lvl_name) and not "partialInv" in lvl):
    print "Print split lvl ", lvl_name, "is missing partialInv"

  if (endsWithNumP.match(lvl_name)):
    origName = justEnd.split(lvl_name)[0]
    originalToSplitM[origName] = originalToSplitM.get(origName, []) + [ lvl_name ]
    splitToOriginal[lvl_name] = origName

print "Checking splitter predicates non-ovrelapping"
for origName in originalToSplitM.keys():
  # For now we assume each split level has a single splitterPred
  preds = [ unique(lvls[x]["splitterPreds"]) for x in originalToSplitM[origName] ]
  for i in xrange(0, len(preds)):
    for j in xrange(i+1, len(preds)):
      if (not unsatisfiable(expr_to_z3(bast.ast_and([preds[i], preds[j]]), AllIntTypeEnv()))):
        print "Predicates ", preds[i], "and", preds[j], "from split of ", origName, "are not independent"

print "Checking conjunction of partial predicates is a solution"
for origName in originalToSplitM.keys():
  # For now we assume each split level has a single splitterPred
  preds = [ lvls[x]["partialInv"] for x in originalToSplitM[origName] ]
  if (len(preds) == 1):
    print "Skipping ", origName, " with only 1 split level (missing other side of split)"
    continue
  conj = bast.ast_and(preds);
  lvl = lvls[originalToSplitM[origName][0]]
  try:
    if (not isSolved(lvl, [conj])):
      (a,b,c,d) = verify(lvl, [conj])
      print origName, "not solved by partial conjunction ", conj
      #print "nonind: ", map(lambda x:  (x[0], x[1].startEnv(), x[1].endEnv(), x[1]._path), b)
  except Unknown:
    print "Can't tell if partials solve level for ", lvl_name
    continue

print "Checking for any trivial levels"
for lvl_name, lvl in lvls.iteritems():
  if "partialInv" in lvl:
    inv = lvl["partialInv"]
  else:
    inv = bast.AstTrue();

  if (isSolved(lvl, [AstTrue()])):
    print lvl_name, " is trivial."

print "Checking for any levels with < 3 rows"
for lvl_name, lvl in lvls.iteritems():
  if (len(lvl["data"][0]) < 3):
    rowExprs = [ env_to_expr(dict(zip(lvl["variables"], row))) for row in lvl["data"][0] ]
    exactValExpr = [ bast.ast_or(rowExprs) ]
    if "splitterPreds" in lvl:
      exactValExpr.append(bast.AstBinExpr(unique(lvl["splitterPreds"]), "==>", exactValExpr[0]))
      exactValExpr.append(lvl["partialInv"]);

    bbs = lvl["program"]
    loop = lvl["loop"]
    over, nonind, sound, violations = \
      tryAndVerify_impl(bbs, loop, [], exactValExpr, 120);
    if (len(sound) == 0):
      print "Level", lvl_name, "has only", len(lvl["data"][0]), "rows"

print "Checking all traces satisfy solution and partial invariants"
for lvl_name, lvl in lvls.iteritems():
  sol = open(lvl["path"][0].replace(".bpl", ".sol")).read()
  sound = [ parseExprAst(sol) ];
  if "partialInv" in lvl:
    sound.append(lvl["partialInv"]);

  for row in lvl["data"][0]:
    env = dict(zip(lvl["variables"], row))
    for p in sound:
      if not evalPred(p, env):
        print "Level", lvl_name, " predicate ", p, "doesn't hold for trace row: ", env
