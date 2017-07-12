#! /usr/bin/env python
from argparse import ArgumentParser
from levels import loadBoogieLvlSet
from lib.boogie.ast import parseExprAst, AstTrue, AstAssert, AstAssume
from lib.boogie.eval import evalPred

p = ArgumentParser(description="Playground for trace selection");
p.add_argument('--lvlset', type=str, help='Path to levelset used in experiment', required=True);

def preds(bbs):
    s = set()
    for bb in bbs:
      for stmt in bbs[bb].stmts:
        if isinstance(stmt, AstAssert) or \
           isinstance(stmt, AstAssume):
            s.add(stmt.expr)
    return s


def transition_points(preds, trace):
    points = {}
    evaluation = { p : None for p in preds }
    for (idx, env) in enumerate(trace):
      for p in preds:
        new_v = evalPred(p, env)
        if (evaluation[p] != new_v):
          evaluation[p] = new_v
          s = points.get(idx, set())
          s.add(p)
          points[idx] = s
    return points

if __name__ == "__main__":
    args = p.parse_args();

    lvlsetName, lvls = loadBoogieLvlSet(args.lvlset)

    lvl = lvls["s-gj2007_true-unreach-call"]
    
    all_preds = preds(lvl["program"])
    t = eval(open('../sv_manual_trans/loop-lit/gj2007_true-unreach-call.desugared.new_fuzz_traces/3108380886538425170.trace').read())
    print "Transition points in trace: ", transition_points(all_preds, t)
