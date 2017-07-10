#!/usr/bin/env python
import argparse
import levels
from boogie_loops import loops
from lib.common.util import fatal, unique
from lib.boogie.bb import get_bbs, BB
from lib.boogie.ast import AstAssignment, AstAssert, AstId, AstNumber, AstBinExpr
from lib.boogie.paths import nd_bb_path_to_ssa, ssa_path_to_z3
from lib.boogie.z3_embed import Unknown, satisfiable
from lib.boogie.ssa import SSAEnv
from lib.boogie.eval import evalPred

uid = 0

def possible(bbs, start_env, path, end_env, timeout):
  global uid
  if start_env != None:
    bb_name = "tmp_{}".format(uid) 
    uid += 1
    stmts = [AstAssignment(AstId(k), AstNumber(v)) for (k, v) in start_env.items()]
    bbs[bb_name] = BB(set(), stmts, set())
    path = [bb_name] + path

  if end_env != None:
    bb_name = "tmp_{}".format(uid) 
    uid += 1
    stmts = [AstAssert(AstBinExpr(AstId(k), "==", AstNumber(v))) for (k, v) in end_env.items()]
    bbs[bb_name] = BB(set(), stmts, set())
    path = path + [bb_name]

  ssa_path, final_env = nd_bb_path_to_ssa(path, bbs, SSAEnv(None, ""))
  query = ssa_path_to_z3(ssa_path, bbs)
  return satisfiable(query, timeout)


def take_possible(bbs, loop, header_vals, timeout):
    res = []
    idx = 0
    if (not possible(bbs, None, list(loop.header), header_vals[0], timeout)):
      return res

    res.append(header_vals[0])

    while (evalPred(loop.entry_cond, res[idx])) and idx < len(header_vals)-1:
      if (not possible(bbs, header_vals[idx], [loop.loop_paths], header_vals[idx+1], args.timeout)):
        break

      res.append(header_vals[idx + 1])
      idx += 1

    return res

def does_split(bbs, loop, header_vals, timeout):
    t = [x for x in header_vals]
    total = []
    while len(t) > 0:
      taken = take_possible(bbs, loop, t, timeout)
      total.extend(taken)
      if len(taken) == 0:
        print ("Failed on iteration {}".format(len(total)))
        return False

      t = t[len(taken):]
    return True


if __name__ == "__main__":
  p = argparse.ArgumentParser(description="check that a trace file splits " +
    "cleanly in several concatinated traces from the start")
  p.add_argument("--boogie-file", type=str,
    help="path to desugared boogie file")
  p.add_argument("--trace-file", type=str,
    help="path to the trace file we are checking")
  p.add_argument("--timeout", type=int, help="z3 timeout")

  args = p.parse_args()
  (vs, header_vals) = levels.readTrace(args.trace_file)
  bbs = get_bbs(args.boogie_file)
  loop = unique(loops(bbs), "Expect single loop")

  try:
    if not (does_split(bbs, loop, header_vals, args.timeout)):
      fatal("This trace file doesn't split into traces cleanly")
  except Unknown:
    fatal("Timeout while checking")
