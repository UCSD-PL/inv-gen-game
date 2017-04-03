from levels import loadBoogieLvlSet
import argparse
from vc_check import tryAndVerify_impl
from lib.cpa_checker import runCPAChecker, convertCppFileForCPAChecker
from lib.boogie.z3_embed import *
from lib.boogie.ast import ast_and, parseExprAst
from lib.common.util import error
from lib.boogie.analysis import propagate_sp
from shutil import move
from z3 import Solver as OriginalSolver
from signal import signal, SIGALRM,  alarm
from os.path import exists

def handler(signum, frame):
  raise Exception("timeout")
signal(SIGALRM, handler);

if (__name__ == "__main__"):
  p = argparse.ArgumentParser(description="run daikon on a levelset")
  p.add_argument('--lvlset', type=str, help='Path to lvlset file')
  #p.add_argument('--use-splitter-predicates', action="store_true", default=False, help='Wether to try inductive invariants with the splitter predicates')
  #p.add_argument('--check-solved', action="store_true", default=False, help='Wether to check for each level if it was solved')
  p.add_argument('--csv-table', action="store_true", default=False, help='Print results as a csv table')
  p.add_argument('--time-limit', type=int, default=300, help='Time limit for CPAChecker')
  args = p.parse_args();

  lvlSetName, lvls = loadBoogieLvlSet(args.lvlset)

  res = { }
  if (args.csv_table):
    print "Level,Solved,Confirmed"

  for lvlName, lvl in lvls.iteritems():
    cppFile = lvl["path"][1]
    preprocessedFile = cppFile + ".cpachecker.preprocessed"
    error("Running ", lvlName)

    if (not exists(preprocessedFile)):
      convertCppFileForCPAChecker(cppFile, preprocessedFile);

    res[lvlName] = runCPAChecker(preprocessedFile, args.time_limit);

    move("output", "tmp_outputs/" + lvlName + "");

    solved, loopHeaderLbl, loopInvs, rawOutput = res[lvlName]
    loop_header = lvl["loop"].loop_paths[0][0]
    sps = list(propagate_sp(lvl["program"])[loop_header])
    error("Added sps: ", sps)
    conf_status = "n/a"

    if (solved):
      error("z3 invs: ", len(loopInvs), loopInvs)
      try:
        alarm(args.time_limit)
        # On lvl d-14 for example the invariants explode exponentially due to
        # inlining of lets. So add timeout. Seems to be the only level with this problem
        invs = map(z3_expr_to_boogie, loopInvs)
      except Exception,e:
        if (e.message == "timeout"):
          invs = None
          conf_status = "timeout"
        else:
          for i in loopInvs:
            s = OriginalSolver();
            s.add(i);
            error(s.to_smt2())
            del s
          raise
      finally:
        alarm(0)
      if (invs != None):
        bbs = lvl["program"]
        loop = lvl["loop"]
        try:
          (overfitted, nonind, sound, violations) =\
            tryAndVerify_impl(bbs, loop, [], invs + sps, args.time_limit)

          error ("Out of ", invs+sps, "sound: ", sound)

          if (len(violations) > 0):
            error("Supposedly sound inv: ", invs)
            error("Level ", lvlName, "false claimed to be sound!")
            error("Raw output: ", rawOutput)
            conf_status = False
          else:
            conf_status = True
        except Unknown:
            conf_status = "z3 timeout"

    if (args.csv_table):
      print lvlName, ",", res[lvlName][0], ",", conf_status
    else:
      print "Level", lvlName, "solved: ", solved, "confirmed?: ", conf_status
