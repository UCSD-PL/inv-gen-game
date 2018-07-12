#!/usr/bin/env python
import argparse
import boogie.ast
import levels
import tabulate
from levels import getEnsamble
from boogie_loops import get_loop_header_values

def _tryUnroll(loop, bbs, min_un, max_un, bad_envs, good_env):
    # Lets first try to find a terminating loop between min and max iterations
    term_vals = get_loop_header_values(loop, bbs, min_un, max_un,
                                       bad_envs, good_env, True)
    if (term_vals != []):
      return (term_vals, True)

    # Couldn't find a terminating loop between 0 and 6 iteration. Lets find
    # a loop that has at LEAST min iterations
    term_vals = get_loop_header_values(loop, bbs, min_un, max_un,
                                       bad_envs, good_env, False)
    return (term_vals, False)


def getInitialData(loop, bbs, nunrolls, invs, invVars = None, invConsts = None):
    if (invConsts == None):
        invConsts = ["_sc_a", "_sc_b", "_sc_c"]
    trace_enasmble = list(getEnsamble(loop, bbs, nunrolls, 1))
    vals, _ = _tryUnroll(loop, bbs, 0, nunrolls, None, None)
    if (vals):
        trace_enasmble.append(vals)
    
    traceVs = list(livevars(bbs)[loop.loop_paths[0][0]])
    trace_enasmble = [ [ { varName: env[varName] for varName in traceVs }
                       for env in tr ]
                     for tr in trace_enasmble ]

    if (invVars == None):
        invVars = traceVs

    invs_lst = [ reduce(lambda x,y: x+y,
                        [ instantiateAndEval(inv, trace, invVars, invConsts)
                            for inv in invs ],
                        [])
                 for trace in trace_enasmble if len(trace) > 0 ]

    tmp_lst = [ (len(invs), invs, tr)
                for (invs, tr) in zip(invs_lst, trace_enasmble) ]

    tmp_lst.sort(key=lambda t:  t[0]);
    return (tmp_lst[0][2], False)


p = argparse.ArgumentParser(description="trace dumper")
p.add_argument("--lvlset", type=str, default="single-loop-conditionals",
  help="lvlset to use for benchmarks")
p.add_argument("--lvl", type=str, default="18",
  help="lvl to use for generating traces")
p.add_argument("--nunrolls", type=int, default=20,
  help="number of times to unroll loops")

args = p.parse_args()

# Process arguments
LVLSET_PATH = "lvlsets/%s.lvlset" % args.lvlset

curLevelSetName, lvls = levels.loadBoogieLvlSet(LVLSET_PATH)

lvl = lvls[args.lvl]
print()
print("=== LEVEL ===")
print(lvl)

trace = levels.getInitialData(lvl["loop"], lvl["program"], args.nunrolls,
  [boogie.ast.parseExprAst(inv)[0] for inv in []]) # Invariant placeholder
print()
print("=== RAW TRACE ===")
print(trace)

vars_ = lvl["variables"]
vars_.sort()
data = trace[0]

print()
print("=== TRACE ===")
print(tabulate.tabulate([[d[v] for v in vars_] for d in data],
  headers=vars_))
