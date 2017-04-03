from levels import loadBoogieLvlSet
import argparse
from vc_check import tryAndVerify_impl
from lib.invgen import runInvGen, convertCppFileForInvGen
from lib.boogie.z3_embed import *
from lib.boogie.ast import ast_and, parseExprAst
from lib.common.util import error
from lib.boogie.analysis import propagate_sp
from shutil import move
from z3 import Solver as OriginalSolver
from signal import signal, SIGALRM,  alarm
from os.path import exists
import re

def handler(signum, frame):
  raise Exception("timeout")
signal(SIGALRM, handler);

def parseInvGenInvariant(inv):
  replaceEq = re.compile("([^<>=])=([^<>=])")
  inv = replaceEq.sub(r"\1==\2", inv)
  inv = inv.replace("=<", "<=")
  return parseExprAst(inv)

if (__name__ == "__main__"):
  p = argparse.ArgumentParser(description="run daikon on a levelset")
  p.add_argument('--lvlset', type=str, help='Path to lvlset file', required=True)
  p.add_argument('--time-limit', type=int, help='Timeout for any operation involving InvGen or z3')
  p.add_argument('--csv-table', action="store_true", default=False, help='Print results as a csv table')
  args = p.parse_args();

  lvlSetName, lvls = loadBoogieLvlSet(args.lvlset)

  res = { }
  if (args.csv_table):
    print "Level,Invariants,TranslatedTo,Solved,Confirmed"

  for lvlName, lvl in lvls.iteritems():
    cppFile = lvl["path"][1]
    invgenCppFile = cppFile + ".invgen.preprocessed"

    if (not exists(invgenCppFile)):
      optionalManualModifiedFile = cppFile + ".invgen.manual.pretranslation";
      if (exists(optionalManualModifiedFile)):
        src = optionalManualModifiedFile
      else:
        src = cppFile;

      convertCppFileForInvGen(src, invgenCppFile);

    error("Running ", lvlName)

    mainRoutine = "main" if lvlName !="i-cegar1" else "cegar1"
    res[lvlName] = runInvGen(invgenCppFile, mainRoutine);

    solved, loopInvs, rawOutput = res[lvlName]
    loop_header = lvl["loop"].loop_paths[0][0]
    sps = list(propagate_sp(lvl["program"])[loop_header])
    error("Added sps: ", sps)
    conf_status = "n/a"

    if (solved == True):
      error("z3 invs: ", len(loopInvs), loopInvs)
      boogieInvs = map(parseInvGenInvariant, loopInvs);
      bbs = lvl["program"]
      loop = lvl["loop"]
      try:
        (overfitted, nonind, sound, violations) =\
          tryAndVerify_impl(bbs, loop, [], boogieInvs + sps, args.time_limit)
        if (len(violations) > 0):
          error("Supposedly sound inv: ", loopInvs)
          error("Results : ", overfitted, nonind, sound)
          error("Level ", lvlName, "false claimed to be sound!")
          error("Raw output: ", rawOutput)
          conf_status = False
        else:
          conf_status = True
      except Exception,e:
        if (e.message == "Unknown binary operator /"):
          conf_status = "unhandled division"
        else:
          raise e
    else:
      boogieInvs = []

    if (args.csv_table):
      print lvlName, ",", ";".join(map(str, loopInvs)), ",", ";".join(map(str, boogieInvs)), ",", res[lvlName][0], ",", conf_status
    else:
      print "Level", lvlName, "discovered:", loopInvs, "solved: ", solved, "confirmed?: ", conf_status
