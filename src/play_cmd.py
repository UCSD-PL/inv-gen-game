#! /usr/bin/env python
from datetime import timedelta
from models import open_sqlite_db, Event
from argparse import ArgumentParser
from levels import loadBoogieLvlSet
from lib.common.util import error, fatal
from lib.boogie.analysis import propagate_sp
from lib.boogie.ast import parseExprAst, expr_read
from lib.boogie.z3_embed import Unknown, tautology, expr_to_z3, AllIntTypeEnv
from lib.boogie.eval import evalPred
from vc_check import tryAndVerifyLvl, loopInvSafetyCtrex
from readline import parse_and_bind, set_history_length
import csv
from re import sub

p = ArgumentParser(description="Compute stats over an experiment");
p.add_argument('--lvlset', type=str, help='Path to levelset used in experiment', required=True);
p.add_argument('--timeout', type=int, default=10, help='Timeout in seconds for z3 queries.')
p.add_argument('--additionalInvs', type=str, help='Path to a .csv file with additional invariants.')

set_history_length(1000);

if __name__ == "__main__":
    args = p.parse_args();
    lvlsetName, lvls = loadBoogieLvlSet(args.lvlset)
    lvlNames = lvls.keys();

    while (len(lvlNames) > 0):
      lvlName = lvlNames.pop();
      lvl = lvls[lvlName]
      bbs = lvl['program']
      loop = lvl['loop']
      vs = lvl['variables']
      greenRows = lvl['data'][0]
      curInvs = set()
      overfitted = set()
      sound = set()
      nonind = set()
      redRows = set()
      redRowsL = []
      if 'partialInv' in lvl:
        oInvs = set([lvl['partialInv']])
      else:
        oInvs = set()
      roundN= 0

      greenRowsEvals = {}
      redRowsEvals = {}

      while (True):
        # Display Menu
        print lvlName, "round", roundN
        print "All Tried(", len(curInvs),"): ", " ".join(map(str, curInvs))
        print "Sound(", len(sound),"): ", " ".join(map(str, sound))
        print "Overfit(", len(overfitted),"): ", " ".join(map(str, overfitted))
        print "Nonind(", len(nonind),"): ", " ".join(map(str, nonind))
        print "Green Rows:"
        print " ".join(vs), "InvFalse?";
        for i in xrange(len(greenRows)):
          row = greenRows[i]
          if i < len(greenRowsEvals):
            ev = 'x' if not greenRowsEvals[i] else ""
          else:
            ev = ""
          print " ".join(map(str, row)), ev

        print "Red Rows: "
        for i in xrange(len(redRowsL)):
          row = redRowsL[i]
          if i < len(redRowsEvals):
            ev = 'x' if redRowsEvals[i] else ""
          else:
            ev = ""
          print " ".join(map(str, row)), ev;

        # Ask for Input
        while (True):
          inv = raw_input("Your invariant: ");
          pp_inv = sub(r'([^<>=])=([^<>=])', r'\1==\2', inv)
          print pp_inv
          try:
            binv = parseExprAst(pp_inv)
            break
          except:
            print "Error: Can't parse ", inv

        invVars = set(expr_read(binv))

        for i in xrange(len(greenRows)):
          gR = greenRows[i]
          env = { vs[i]: (gR[i] if gR[i] != None else 0) for i in xrange(len(gR)) }
          greenRowsEvals[i] = evalPred(binv, env);

        redRowsEvals = { }
        for i in xrange(len(redRows)):
          rR = redRowsL[i]
          env = { vs[i]: rR[i] for i in xrange(len(rR)) if rR[i] != '*' }
          if (len(invVars.difference(set(env.keys()))) > 0):
            # Not all cariables in binv are defined - can't evalute
            pass
          else:
            redRowsEvals[i] = evalPred(binv, env);

        if (len([x for x in greenRowsEvals if not greenRowsEvals[x]]) > 0 or\
            len([x for x in redRowsEvals if redRowsEvals[x]])):
          print "======================================================="
          print "Doesn't satisfy all rows!"
          continue;

        redRowsL = [ redRowsL[i] for i in xrange(0, len(redRowsL)) if i not in redRowsEvals ]
        redRows = set(redRowsL);

        print "Verifying..."
        curInvs.add(binv);
        # Try and Verify
        ((overfitted, overfitted_ignore), (nonind, nonind_ignore), sound, violations) =\
          tryAndVerifyLvl(lvl, curInvs, oInvs, args.timeout)

        if (len(violations) == 0):
          break;

        # tryAndVerifyLvl filters out invariants we can't show to be sound before checking for
        # safety ctrexamples. Call loopInvSafetyCtrex directly to obtain any red-rows for the
        # current invariant set
        direct_violations = loopInvSafetyCtrex(loop, curInvs, bbs, args.timeout);
        for endEnv in direct_violations:
          redRows.add(tuple([endEnv.get(v, '*') for v in vs]))
        redRowsL = list(redRows)
        roundN += 1
        print "======================================================="
      print "Congrats! You solved :", lvlName, " after ", roundN, " rounds!"
