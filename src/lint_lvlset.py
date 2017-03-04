#!/usr/bin/env python
import argparse
import levels
import tabulate
from lib.boogie.eval import *
import lib.boogie.ast as bast
from lib.boogie.z3_embed import *
from vc_check import tryAndVerify_impl, checkLoopInv
from boogie_loops import *
from re import compile
from lib.common.util import unique
import os

p = argparse.ArgumentParser(description="check a lvlset is correctly built")
p.add_argument("--lvlset", type=str, help="lvlset to checl", required=True)
p.add_argument("--timeout", type=int, help="timeout on z3 queries")

args = p.parse_args()
curLevelSetName, lvls = levels.loadBoogieLvlSet(args.lvlset)

print "Checking all solutions work..."
for lvl_name, lvl in lvls.items():
  sol = open(lvl["path"][0].replace(".bpl", ".sol")).read()
  sol = parseExprAst(sol);
  bbs = lvl["program"]
  loop = lvl["loop"]

  try:
    res = checkLoopInv(bbs, loop, [sol], args.timeout)
  except Unknown:
    print "Can't tell for level ", lvl_name
    continue

  if (res != True):
    print lvl_name, "doesn't satisfy solution ", sol, "info: ", res

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

print "Checking for any trivial levels"
for lvl_name, lvl in lvls.iteritems():
  if "partialInv" in lvl:
    inv = lvl["partialInv"]
  else:
    inv = bast.AstTrue();

  bbs = lvl["program"]
  loop = lvl["loop"]
  trivial = checkLoopInv(bbs, loop, [AstTrue()], args.timeout);

  if (trivial == True):
    print lvl_name, " is new trivial."

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
    over, nonind, sound = tryAndVerify_impl(bbs, loop, [], exactValExpr, 120);
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
