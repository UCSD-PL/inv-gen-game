#!/usr/bin/env python

import argparse
import boogie.ast
import levels
import tabulate
from boogie.eval import *
from boogie.ast import *
from vc_check import tryAndVerify_impl
from boogie_loops import *
import os

p = argparse.ArgumentParser(description="trace dumper")
p.add_argument("--lvlset", type=str, default="single-loop-conditionals",
  help="lvlset to use for benchmarks")

args = p.parse_args()
curLevelSetName, lvls = levels.loadBoogieLvlSet(args.lvlset)

for lvl_name, lvl in lvls.items():
  if "desugared" not in lvl["path"]:  continue;
  #print "Removing :", lvl["path"].replace(".bpl", ".trace")
  #os.system("rm " + lvl["path"].replace(".bpl", ".trace"))
  sol = open(lvl["path"].replace(".bpl", ".sol")).read()
  sol = parseExprAst(sol)[0];
  bbs = lvl["program"]
  loop = lvl["loop"]
  over, nonind, sound = tryAndVerify_impl(bbs, loop, [], [sol], 10);
  post_ctrex = loop_vc_post_ctrex(loop, ast_and(sound), bbs)
  if (post_ctrex != None):
    print lvl["path"], "not verified with sound = ", sound, " original sol ", sol, "ctrex:", post_ctrex
    print over, nonind
