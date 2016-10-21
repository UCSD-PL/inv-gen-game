#!/usr/bin/env python

import argparse
import boogie.ast
import boogie.z3_embed as z3_embed
import contextlib
import json
import levels
import os
import tabulate
import threading

p = argparse.ArgumentParser(description="trace dumper")
p.add_argument("--all", action="store_const", const=True, default=False,
  help="run on all levels in the lvlset")
p.add_argument("--lvl", type=str, default="18",
  help="lvl to use for generating traces")
p.add_argument("--lvlset", type=str, default="single-loop-conditionals",
  help="lvlset to use for benchmarks")
p.add_argument("--nunrolls", type=int, default=20,
  help="number of times to unroll loops")
p.add_argument("--saveto", type=str, default=None,
  help="save traces to disk under the given directory")
p.add_argument("--timeout", type=int, default=0,
  help="timeout in seconds for z3 queries")

@contextlib.contextmanager
def z3Timeout(interval):
  t = threading.Timer(interval, z3_embed.shutdownZ3)
  t.start()
  try:
    yield
  finally:
    t.cancel()
    t.join()

def dumpLevel(name, lvl, nunrolls, saveto=None, timeout=None):
  relpath = os.path.relpath(lvl["path"])

  print
  print "=== LEVEL ==="
  print "name:", name
  print "path:", relpath
  # This occasionally gives maximum recursion depth exceeded in repr
  #print "contents:", lvl

  # Invariant placeholder
  invs = [boogie.ast.parseExprAst(inv)[0] for inv in []]

  # XXX We shouldn't need to do this...
  z3_embed.shuttingDown = False

  try:
    with z3Timeout(timeout):
      trace = levels.getInitialData(lvl["loop"], lvl["program"], nunrolls,
        [boogie.ast.parseExprAst(inv)[0] for inv in []])
  except z3_embed.Die:
    print "Z3 Error! (probably timeout)"
    return

  print
  print "=== RAW TRACE ==="
  print trace

  vars_ = lvl["variables"]
  vars_.sort()
  data = trace[0]

  # Get rid of Z3-typed integers
  for d in data:
    for k, v in d.items():
      d[k] = v.as_long()

  print
  print "=== TRACE ==="
  print tabulate.tabulate([[d[v] for v in vars_] for d in data],
    headers=vars_)

  if saveto is not None:
    print

    if len(data) < nunrolls:
      print "Trace too short; not saving"
      return

    tracestr = json.dumps(data)

    tracename = "%x.trace" % hash(tracestr)
    savedir = os.path.join(saveto, relpath)
    try:
      os.makedirs(savedir)
    except OSError:
      pass
    savepath = os.path.join(savedir, tracename)

    f = open(savepath, "w")
    f.write(tracestr)
    f.close()

    print "Trace saved to %s" % savepath

# Process arguments
args = p.parse_args()

lvlset_path = "lvlsets/%s.lvlset" % args.lvlset
curLevelSetName, lvls = levels.loadBoogieLvlSet(lvlset_path)

if args.timeout <= 0:
  args.timeout = None

# Run
if args.all:
  run_lvls = lvls
else:
  run_lvls = {args.lvl: lvls[args.lvl]}

for name, lvl in run_lvls.items():
  dumpLevel(name, lvl, args.nunrolls, saveto=args.saveto,
    timeout=args.timeout)
