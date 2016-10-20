#!/usr/bin/env python

import argparse
import boogie.ast
import levels
import tabulate
from boogie.eval import *

p = argparse.ArgumentParser(description="trace dumper")
p.add_argument("--lvlset", type=str, default="single-loop-conditionals",
  help="lvlset to use for benchmarks")
p.add_argument("--lvl", type=str, default="18",
  help="lvl to use for generating traces")

args = p.parse_args()

# Process arguments
LVLSET_PATH = "lvlsets/%s.lvlset" % args.lvlset

curLevelSetName, lvls = levels.loadBoogieLvlSet(LVLSET_PATH)

lvl = lvls[args.lvl]

for t in execute({"i": 100, "n": 100, "k": 20, "LARGE_INT":100}, "anon0", lvl["program"], 1000): 
  print t[-1];
