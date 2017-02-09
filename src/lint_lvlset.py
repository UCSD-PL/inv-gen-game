#!/usr/bin/env python

import argparse
import levels
import tabulate
from lib.boogie.eval import *
from lib.boogie.ast import *
from vc_check import tryAndVerify_impl
from boogie_loops import *
import os

p = argparse.ArgumentParser(description="check a lvlset is correctly built")
p.add_argument("--lvlset", type=str, help="lvlset to checl", required=True)

args = p.parse_args()
curLevelSetName, lvls = levels.loadBoogieLvlSet(args.lvlset)

for lvl_name, lvl in lvls.items():
  print "Checking ", lvl_name
  if "desugared" not in lvl["path"][0]:  continue;
  #print "Removing :", lvl["path"].replace(".bpl", ".trace")
  #os.system("rm " + lvl["path"].replace(".bpl", ".trace"))
  sol = open(lvl["path"][0].replace(".bpl", ".sol")).read()
  sol = parseExprAst(sol);
  bbs = lvl["program"]
  loop = lvl["loop"]
  over, nonind, sound = tryAndVerify_impl(bbs, loop, [], [sol], 120);
  post_ctrex = loop_vc_post_ctrex(loop, ast_and(sound), bbs)
  if (post_ctrex != None):
    print lvl["path"][0], "not verified with sound = ", sound, " original sol ", sol, "ctrex:", post_ctrex
    print over, nonind
