#!/usr/bin/env python

import boogie.ast
import boogie.eval
import json
import os
import tabulate

DATA_SET = [
  {
    "trace_dir": "new_summer_benchmarks/sum1.boogie.desugared.fuzz_traces/",
    "preds": ["i<=n", "sn==n||sn==0", "n>0"],
    "correct_preds": ["n>0"]
  },
  {
    "trace_dir": "test-conditional/019.boogie.desugared.fuzz_traces/",
    "preds": ["x<n", "x>m", "y==n", "n>0"],
    "correct_preds": ["x>m"]
  },
  {
    "trace_dir": "new_summer_benchmarks/fig1.boogie.desugared.fuzz_traces/",
    "preds": ["x<0", "y>0"],
    "correct_preds": ["y>0"]
  },
  {
    "trace_dir": "sv_manual_trans/loop-new/half_true-unreach-call.desugared.fuzz_traces/",
    "preds": ["i<2*k", "i mod 2==0", "k<0||n==k", "0<2*k", "k>0"],
    "correct_preds": ["i mod 2==0", "k>0"]
  },
  {
    "trace_dir": "sv_manual_trans/loop-acceleration/diamond_true-unreach-call1.desugared.fuzz_traces/",
    "preds": ["x<99", "y mod 2==0", "x mod 2==y mod 2"],
    "correct_preds": ["y mod 2==0",]
  },
  {
    "trace_dir": "sv_manual_trans/loop-acceleration/phases_true-unreach-call1.desugared.fuzz_traces/",
    "preds": ["x<268435455", "x<65520", "0==x mod 2"],
    "correct_preds": ["x<65520"]
  },
  {
    "trace_dir": "sv_manual_trans/loop-lit/gj2007_true-unreach-call.desugared.fuzz_traces/",
    "preds": ["x<100", "x<50", "y==100"],
    "correct_preds": ["x<50"]
  },
  {
    "trace_dir": "sv_manual_trans/loop-lit/gr2006_true-unreach-call.desugared.fuzz_traces/",
    "preds": ["true", "x<50", "y<0", "x==100"],
    "correct_preds": ["x<50"]
  },
  {
    "trace_dir": "sv_manual_trans/loop-lit/gj2007b_true-unreach-call.desugared.fuzz_traces/",
    "preds": ["x<n", "m>=0||n<=0", "m<n||n<=0", "n>0"],
    "correct_preds": ["n>0"]
  },
  {
    "trace_dir": "sv_manual_trans/loops/sum01_true-unreach-call_true-termination.desugared.fuzz_traces/",
    "preds": ["i<=n", "sn==n*a||sn==0", "n>=1"],
    "correct_preds": ["n>=1"]
  }
]

def loadTraceRows(trace_dir):
  trace_rows = []
  for trace_file in os.listdir(trace_dir):
    trace_dump = json.load(open(trace_dir + trace_file))
    for (name, vals) in trace_dump:
      if name.endswith("_LoopHead"):
        trace_rows.extend(vals)
  return trace_rows

def evenness(x, y):
  # This is just Chi-squared with 50/50 expectation (lower is better)
  total = x + y
  expected = total / 2.
  return (x - expected)**2 / expected + (y - expected)**2 / expected

def prettyPredRanks(pred_ranks):
  return ", ".join("%s (rank %s)" % (pred, str(rank)) for pred, rank in
    pred_ranks.items())

def evaluatePreds(trace_dir, preds, correct_preds):
  trace_rows = loadTraceRows(trace_dir)

  results = []
  for pred in preds:
    bpred = boogie.ast.parseExprAst(pred)[0]
    t = 0
    f = 0
    for row in trace_rows:
      if boogie.eval.evalPred(bpred, row):
        t += 1
      else:
        f += 1
    e = evenness(t, f)
    results.append({"pred": pred, "t": t, "f": f, "evenness": e})

  # Most even -> least even
  results.sort(key=lambda d: d["evenness"])

  correct_ranks = {}
  for pred in correct_preds:
    correct_ranks[pred] = None
  for i, r in enumerate(results):
    pred = r["pred"]
    if pred in correct_ranks:
      correct_ranks[pred] = i

  print
  print "traces:", trace_dir
  print "correct_preds:", prettyPredRanks(correct_ranks)
  print "chosen_pred:", results[0]["pred"], "(rank 0)"
  columns = ["pred", "t", "f", "evenness"]
  print tabulate.tabulate([[r[c] for c in columns] for r in results],
    headers=[c.upper() for c in columns])

for data in DATA_SET:
  evaluatePreds(**data)
