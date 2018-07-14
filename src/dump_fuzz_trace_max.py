#!/usr/bin/env python

import argparse
#import pyboogie.ast
import json
from lib.invgame_server.levels import loadBoogieLvlSet, BoogieTraceLvl
from lib.invgame_server.trace_gen import getEnsamble
import math
import os
import random
import tabulate

from pyboogie.bb import Function
from pyboogie.interp import Store

from typing import Set, List, Tuple, Iterator, Optional

p = argparse.ArgumentParser(description="improved trace dumper")
p.add_argument("--lvlset", type=str, required=True,
  help="lvlset to use for benchmarks")
p.add_argument("--lvl", type=str, required=True,
  help="lvl to use for generating traces")
p.add_argument("--write", action="store_true")
p.add_argument("--length", type=int, default=10, help="try find traces of length (defualt 10)")
p.add_argument("--limit", type=int, default=100, help="max numer of traces found (defualt 100)")

args = p.parse_args()

# Process arguments
lvlset_path: str = args.lvlset
curLevelSetName, lvls = loadBoogieLvlSet(lvlset_path)
lvl : BoogieTraceLvl = lvls[args.lvl]

trace_dir: Optional[str] = None
if args.write:
  trace_dir = lvl["path"][0][:-4] + ".new_fuzz_traces"
  print("Making trace directory:", trace_dir)
  try:
    assert trace_dir is not None
    os.mkdir(trace_dir)
  except OSError:
    pass

print()
print("=== LEVEL ===")
print(lvl)

vars_ = lvl["variables"]
vars_.sort()

def write_trace(rowsL, prefix=""):
  trace_str = json.dumps(rowsL)
  trace_file = "%s/%s%d.trace" % (trace_dir, prefix, hash(trace_str))
  print("Writing trace to file:", trace_file)
  with open(trace_file, "w") as fh:
    fh.write(trace_str)

# http://www.cs.huji.ac.il/course/2005/algo2/scribes/lecture2.pdf
def weighted_set_cover(u, xs, cost, coverage):
  ys = []
  # Compute costs
  for i, x in enumerate(xs):
    c = cost(x)
    s = coverage(x)
    ys.append((c, s, i))

  a = set()
  def weight_key(y):
    sc = len(y[1] - a)
    return y[0] / float(sc) if sc > 0 else None

  cxs = []
  while ys and u - a:
    ys.sort(key=weight_key)
    y = ys.pop(0)
    if weight_key(y) is None:
      continue
    a.update(y[1])
    cxs.append(xs[y[2]])

  return cxs

def gen():
  # XXX Do something more principled
  yield 0
  yield 1
  yield -1
  n = 2
  while True:
    yield random.randint(-n, n)
    if n < 100:
      n *= 2

fun: Function = lvl["program"]
# TODO Refine generators based on BB asserts?
def storegen() -> Iterator[Store]:
  varGen = {v: gen() for v in fun.getTypeEnv().keys()}
  while True:
    yield { v: varGen[v].__next__() for v in fun.getTypeEnv().keys()}
tracegen = getEnsamble(fun, exec_limit=args.limit,
  tryFind=args.length, vargens=storegen())

bbset: Set[str] = set(bb.label for bb in fun.bbs())
nbbset = len(bbset)
bbneed = set(bbset)

alltraces: List[Tuple[List[Store], Set[str]]] = []
mintraces = 0
# Attempt to get 2x traces needed for full coverage (arbitrary heuristic)
while bbneed or len(alltraces) < 2 * mintraces:
  try:
    valss, bbhit = next(tracegen)
  except StopIteration:
    break
  if bbneed:
    mintraces += 1
  bbneed -= bbhit

  alltraces.append((valss, bbhit))

  # Dump intermediate traces to file
  if trace_dir is not None:
    write_trace(valss)

  nbbcov = len(bbset.intersection(bbhit))
  print("Found a trace of length %d with coverage %d/%d (%f%%)" % (len(valss),
    nbbcov, nbbset, nbbcov * 100. / nbbset))
  print("Still need:", bbneed)

# Weighted set cover
# NOTE Cost heuristic has odd behavior: cost = len will pick many short traces
# with 75% coverage (e.g. 1/3 = 1.5) over slightly longer traces with 100%
# coverage (e.g. 2/4 = 2).  This is a consequence of the greedy approximation.
ctraces = weighted_set_cover(bbset, alltraces, lambda x: len(x[0]),
  lambda x: x[1])

# Combine rows from selected traces
rows: List[Store] = []
for valss, _ in ctraces:
  rows += valss

# TODO Refine traces based on changing conditional expressions

# Dump combined trace to file
if trace_dir:
  write_trace(rows, prefix="combined-")

print("Selected %d/%d rows (%d/%d traces)" % (len(rows),
  sum(len(valss) for valss, _ in alltraces), len(ctraces), len(alltraces)))
print("Naive would have used %d rows (%d traces)" % (
  sum(len(valss) for valss, _ in alltraces[:mintraces]), mintraces))

print()
print("=== TRACE ===")
print(tabulate.tabulate([[vals[v] for v in vars_] for vals in rows],
  headers=vars_))

nbbcov = nbbset - len(bbneed)
print()
print("=== COVERAGE ===")
print("BBSET:", bbset)
print("BBNEED:", bbneed)
print("COVERAGE:", "%d/%d, (%f%%)" % (nbbcov, nbbset, nbbcov * 100. / nbbset))
