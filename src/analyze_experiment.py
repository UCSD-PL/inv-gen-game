#! /usr/bin/env python
from datetime import timedelta
from lib.invgame_server.models import open_sqlite_db, Event
from argparse import ArgumentParser
from lib.invgame_server.levels import loadBoogieLvlSet
from lib.common.util import error, fatal
from pyboogie.ast import parseExprAst
from pyboogie.bb import Function
from pyboogie.z3_embed import Unknown, tautology, expr_to_z3, boogieToZ3TypeEnv
from lib.invgame_server.vc_check import tryAndVerifyLvl
import csv
from functools import reduce
from typing import Dict, Any, Optional

argp = ArgumentParser(description="Compute stats over an experiment");
argp.add_argument('--ename', type=str, help='Name for experiment', required=True);
argp.add_argument('--lvlStats', action="store_const", const=True, default=False,
               help='If set print lvl stats');
argp.add_argument('--usrStats', action="store_const", const=True, default=False,
               help='If set print user stats');
argp.add_argument('--lvlset', type=str,
               help='Path to levelset used in experiment', required=True);
argp.add_argument('--timeout', type=int, default=10,
               help='Timeout in seconds for z3 queries.')
argp.add_argument('--additionalInvs', type=str,
               help='Path to a .csv file with additional invariants.')

def isSrcUser(srcId):
    return srcId != 'verifier'

if __name__ == "__main__":
    args = argp.parse_args();

    s = open_sqlite_db("../logs/" + args.ename + "/events.db")()
    lvlsetName, lvls = loadBoogieLvlSet(args.lvlset)

    otherInvs = { }
    if (args.additionalInvs):
      with open(args.additionalInvs) as f:
        r = csv.reader(f, delimiter=",");
        for row in r:
          (lvlName, invs) = row
          fun: Function = lvls[lvlName]
          typeEnv = boogieToZ3TypeEnv(fun.getTypeEnv())
          bInvs = []
          for inv in [x for x in invs.split(";") if len(x.strip()) != 0]:
            try:
              bInv = parseExprAst(inv)
              if (tautology(expr_to_z3(bInv, typeEnv))):
                  continue
              bInvs.append(bInv)
            except RuntimeError:
              # Some invariants are just too large for parsing :(
              pass
            except Unknown:
              bInvs.append(bInv)

          otherInvs[lvlName]=bInvs

    lvlStats: Dict[str, Dict[str, Any]] = { lvlN: {
          "usersStarted": set(),\
          "nusersStarted": 0,\
          "usersFinished": set(),\
          "nusersFinished": 0,\
          "invs": set(),\
          "ninvs": 0,\
          "invariantsTried": set(),\
          "nInvariantsTried": 0,\
          "invariantsFound": set(),\
          "nInvariantsFound": 0,\
          "skipped": 0,\
          "totalTime": timedelta(),\
        } for lvlN in lvls }
    usrStats: Dict[str, Any] = { }
    startTimes = { }

    for e in s.query(Event).all():
      typ, src, ename, time, p = e.type, e.src, e.experiment, e.time, e.payl()

      if ('lvlset' in p and p['lvlset'] != lvlsetName):
        fatal("Logs refer to levelset " + p['lvlset'] + " which is not loaded.")

      if ('lvlid' not in p):
        lvlId = None
      else:
        lvlId = p['lvlid']
        while lvlId[-2:] == '.g':
          lvlId = lvlId[:-2]

      if (lvlId and lvlId not in lvls):
        fatal("Logs refer to level " + lvlId +\
              " which is not found in current lvlset.")

      if (lvlId):
        lvl = lvls[lvlId]
        lvlS: Optional[Dict[str, Any]] = lvlStats[lvlId]
      else:
        lvl = None
        lvlS = None

      usrS: Dict[str, Any] = usrStats.get(src, {
        "gamesDone": 0,\
        "lvlsStarted": 0,\
        "levelsFinished": 0,\
        "tutorialStarted": 0, \
        "tutorialFinished": 0, \
        "invariantsTried": set(),\
        "nInvariantsTried": 0,\
        "invariantsFound": set(),\
        "nInvariantsFound": 0,\
        "totalNPowerups": 0,\
        "timesPowerupsActivated": 0,\
        "sumPowerupMultipliers": 0,\
        "skipped": 0,\
        "replayTutorial": 0,\
      })

      """
      # This assertion doesn't hold due to experiment merging
      if (ename != args.ename):
        fatal("Logs refer to experiment " + ename +
          " which is different from specified experiment " + args.ename)
      """

      if (typ == "StartLevel"):
        assert lvlS is not None
        usrS["lvlsStarted"] += 1
        lvlS['nusersStarted'] += 1
        lvlS['usersStarted'].add(src);
        startTimes[src] = time
      elif (typ == "TutorialStart"):
        usrS["tutorialStarted"] += 1
      elif (typ == "TutorialDone"):
        usrS["tutorialFinished"] += 1
      elif (typ == "TriedInvariant"):
        assert lvlS is not None
        usrS["nInvariantsTried"] += 1
        lvlS["nInvariantsTried"] += 1
        usrS["invariantsTried"].add((p['raw'], p['canonical']))
        lvlS["invariantsTried"].add((p['raw'], p['canonical']))
      elif (typ == "PowerupsActivated"):
        usrS['totalNPowerups'] += len(p['powerups'])
        usrS['timesPowerupsActivated'] += 1
        usrS['sumPowerupMultipliers'] += \
                reduce(lambda x,y: x*y, [z[1] for z in p['powerups']], 1)
      elif (typ == "FoundInvariant"):
        assert lvlS is not None
        usrS["nInvariantsFound"] += 1
        lvlS["nInvariantsFound"] += 1
        usrS["invariantsFound"].add((p['raw'], p['canonical']))
        lvlS["invariantsFound"].add((p['raw'], p['canonical']))
      elif (typ == "VerifyAttempt"):
        pass
      elif (typ == "SkipToNextLevel"):
        assert lvlS is not None
        usrS['skipped'] += 1
        lvlS['skipped'] += 1
      elif (typ == "FinishLevel"):
        assert lvlS is not None
        usrS['levelsFinished'] += 1
        lvlS['nusersFinished'] += 1
        lvlS['usersFinished'].add(src);
        assert(src in startTimes)
        duration = e.time - startTimes[src]
        lvlS['totalTime'] += duration
      elif (typ == "GameDone"):
        usrS['gamesDone'] += 1
      elif (typ == "ReplayTutorialAll"):
        usrS['replayTutorial'] += 1
      else:
        fatal("Unknown type: " + typ)

    for lvlName in lvls:
      lvlS = lvlStats[lvlName]
      lvl = lvls[lvlName]
      invs = lvlS["invariantsTried"].union(lvlS["invariantsFound"])
      invM = { }
      for (raw,b) in invs:
        try:
          parsed = str(parseExprAst(b))
          invM[parsed]=raw
        except Exception as e:
          print("Failed parsing: ", raw,b)

      userInvs = set();

      for x in invs:
        try:
          userInvs.add(parseExprAst(x[1]))
        except:
          print("Failed parsing: ", x[1])

      if (lvlName in otherInvs):
        oInvs = set(otherInvs[lvlName])
      else:
        oInvs = set([])

      ((overfitted, _), (nonind, _), sound, violations) =\
        tryAndVerifyLvl(lvl, userInvs, oInvs, args.timeout)

      lvlS["solved"] = (len(violations) == 0)
      lvlS["sound"] = [invM.get(str(x), str(x)) for x in sound];
      lvlS["overfitted"] = [invM.get(str(x[0]), str(x[0])) for x in overfitted]
      lvlS["nonind"] = [invM.get(str(x[0]),str(x[0])) for x in nonind]

    if (args.lvlStats):
      lvlStatColumns = ["Level", "Solved", "#Started", "Finished", \
                        "Total Time", "Ave Time/User", "#Invs Tried", \
                        "Ave #Invs Tried/Usr", "#Invs Found", "#Invs Found",\
                        "Ave #Invs Found/Usr", "#Sound", "Sound", \
                        "#Overfitted", "Overfitted", "#Nonind", "Nonind"]
      print(", ".join(lvlStatColumns))
      for (lvlName, lvlS) in lvlStats.items():
        print(", ".join([\
          lvlName,\
          str(lvlS["solved"]),\
          str(lvlS["nusersStarted"]),\
          str(lvlS["nusersFinished"]),\
          str(lvlS["totalTime"]),\
          (str(lvlS["totalTime"] / lvlS["nusersFinished"]) if lvlS["nusersFinished"] != 0 else "-"),\
          str(lvlS["nInvariantsTried"]),\
          (str(lvlS["nInvariantsTried"]/(lvlS["nusersFinished"]*1.0)) if lvlS["nusersFinished"] != 0 else "-"),\
          str(lvlS["nInvariantsFound"]),\
          (str(lvlS["nInvariantsFound"]/(lvlS["nusersFinished"]*1.0)) if lvlS["nusersFinished"] != 0 else "-"),\
          str(len(lvlS["sound"])),\
          ";".join(lvlS["sound"]),\
          str(len(lvlS["overfitted"])),\
          ";".join(lvlS["overfitted"]),\
          str(len(lvlS["nonind"])),\
          ";".join(lvlS["nonind"])]));

    if (args.usrStats):
        raise Exception("NYI!");
