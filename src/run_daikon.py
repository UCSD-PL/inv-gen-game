from levels import readTrace, loadBoogieLvlSet
from lib.daikon import toDaikonTrace, runDaikon
from lib.daikon.inv_grammar import *
from lib.daikon.inv_ast import *
from conversions import daikonToBoogieExpr
import argparse
from os.path import exists
from os import listdir
from vc_check import tryAndVerify_impl, tryAndVerifyWithSplitterPreds
from boogie_loops import loop_vc_post_ctrex
import lib.boogie.ast as bast

if (__name__ == "__main__"):
  p = argparse.ArgumentParser(description="run daikon on a levelset")
  p.add_argument('--lvlset', type=str, help='Path to lvlset file')
  p.add_argument('--use-splitter-predicates', action="store_true", default=False, help='Wether to try inductive invariants with the splitter predicates')
  p.add_argument('--no-suppression', action="store_true", default=False, help='Wether to have daikon suppress obvious invariants')
  p.add_argument('--check-solved', action="store_true", default=False, help='Wether to check for each level if it was solved')
  p.add_argument('--csv-table', action="store_true", default=False, help='Print results as a csv table')
  args = p.parse_args();

  name,lvls = loadBoogieLvlSet(args.lvlset)

  if (args.csv_table):
    if (args.check_solved):
      print "Level, Num Invariants Found, Invariants Found, Num Sound Invariants, Sound Invariants, IsSolved"
    else:
      print "Level, Num Invariants Found, Invariants Found, Num Sound Invariants, Sound Invariants"

  for lvlName, lvl in lvls.iteritems():
    (vs, header_vals) = (lvl["variables"], lvl["data"][0])
    fuzz_path = lvl["path"][0][:-len(".bpl")] + ".fuzz_traces"
    if (exists(fuzz_path)):
      for f in listdir(fuzz_path):
        t = eval(open(fuzz_path + "/" + f).read());
        t_loop_headers = [x for x in t if 'LoopHead' in x[0]]
        assert (len(set([x[0] for x in t_loop_headers])) == 1)
        t_header_vals = [ [ row[1][0][v] for v in vs ] for row in t_loop_headers ]
        header_vals = header_vals + t_header_vals
    invs = runDaikon(vs, header_vals, args.no_suppression)
    binvs = [ ]
    for inv in invs:
      try:
        binvs.append(daikonToBoogieExpr(inv))
      except:
        if (not args.csv_table):
          print "Can't translate ", inv;

    bbs = lvl["program"]
    loop = lvl["loop"]
    if ("splitterPreds" in lvl and args.use_splitter_predicates):
      splitterPreds = lvl['splitterPreds']
      partialInv = [ lvl['partialInv'] ] if 'partialInv' in lvl else []
      (overfitted, nonind, soundInvs) = tryAndVerifyWithSplitterPreds(bbs, loop, [], binvs, splitterPreds, partialInv)
    else:
      (overfitted, nonind, soundInvs) = tryAndVerify_impl(bbs, loop, [], binvs)

    if (args.check_solved):
      post_ctrex = loop_vc_post_ctrex(loop, bast.ast_and(soundInvs), bbs)
      solved = "," + str((post_ctrex == None))
    else:
      solved = "";

    if (args.csv_table):
      print ",".join([lvlName, str(len(binvs)), ";".join(map(str, binvs)), str(len(soundInvs)), ";".join(map(str, soundInvs)) ]) + solved
    else:
      print "For lvl", lvlName, " daikon found", len(binvs), ":", binvs,\
            "of which", len(soundInvs), " are sound: ", soundInvs
