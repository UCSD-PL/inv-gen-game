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
import re

p = argparse.ArgumentParser(description="check a lvlset is correctly built")
p.add_argument("--lvlset", type=str, help="lvlset to checl", required=True)

args = p.parse_args()
curLevelSetName, lvls = levels.loadBoogieLvlSet(args.lvlset)

for lvl_name, lvl in lvls.items():
  boogieF, cF, origF = lvl["path"]

  if (not exists(origF)):
    print "Error: ", origF, "doesnt exist";
    assert False

  newBoogieF = origF[:-4] + ".ice-dt.bpl";
  bbs = lvl["program"]
  loop = lvl["loop"]

  print "Translating ", origF, "to", newBoogieF
  invFuncDecl = "function {:existential true} b0(" +\
    ", ".join([v + ":int" for v in lvl["variables"]]) + "): bool;"
  invFuncRef = "invariant b0(" + ", ".join(lvl["variables"]) + ");"
  print invFuncDecl
  print invFuncRef

  lines = open(origF).read().split("\n");
  whileRE = re.compile("^\s*while")
  whileLines = [(i,l) for (i,l) in enumerate(lines) if whileRE.match(l)]
  assert len(whileLines) == 1
  whileLineNo = whileLines[0][0]
  newLines = [invFuncDecl] + lines[:whileLineNo+1] + [invFuncRef] + lines[whileLineNo+1:]
  open(newBoogieF, "w").write("\n".join(newLines))
