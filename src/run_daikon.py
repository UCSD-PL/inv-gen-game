from levels import readTrace
from daikon import toDaikonTrace, runDaikon
from daikon.inv_grammar import *
from daikon.inv_ast import *
from conversions import daikonToBoogieExpr
from levels import loadBoogieLvlSet, readTrace
import argparse
from os.path import exists
from os import listdir
from vc_check import tryAndVerify_impl

if (__name__ == "__main__"):
  p = argparse.ArgumentParser(description="run daikon on a levelset")
  p.add_argument('--lvlset', type=str, help='Path to lvlset file')
  args = p.parse_args();

  name,lvls = loadBoogieLvlSet(args.lvlset)

  for lvlName, lvl in lvls.iteritems():
    (vs, header_vals) = (lvl["variables"], lvl["data"][0])
    fuzz_path = lvl["path"][:-len(".bpl")] + ".fuzz_traces"
    if (exists(fuzz_path)):
      for f in listdir(fuzz_path):
        t = eval(open(fuzz_path + "/" + f).read());
        t_loop_headers = [x for x in t if 'LoopHead' in x[0]]
        assert (len(set([x[0] for x in t_loop_headers])) == 1)
        t_header_vals = [ [ row[1][0][v] for v in vs ] for row in t_loop_headers ]
        header_vals = header_vals + t_header_vals
    invs = runDaikon(vs, header_vals)
    binvs = [ ]
    for inv in invs:
      try:
        binvs.append(daikonToBoogieExpr(inv))
      except:
        print "Can't translate ", inv;

    bbs = lvl["program"]
    loop = lvl["loop"]
    (overfitted, nonind, soundInvs) = tryAndVerify_impl(bbs, loop, [], binvs)
    print "For lvl", lvlName, " daikon found", len(binvs), ":", binvs, "of which", len(soundInvs), " are sound: ", soundInvs
