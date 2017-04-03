#! /usr/bin/env python
from json import loads, dumps
from js import esprimaToBoogie
from datetime import datetime, timedelta
from models import open_sqlite_db, Source, Event, workers, done_tutorial,\
    finished_levels, found_invs, experiments
from argparse import *
from levels import loadBoogieLvlSet
from sys import exit
from lib.common.util import eprint
from lib.boogie.analysis import propagate_sp
from lib.boogie.ast import parseExprAst
from vc_check import tryAndVerify_impl, tryAndVerifyWithSplitterPreds, _from_dict


p = ArgumentParser(description="Compute stats over an experiment");
p.add_argument('--ename', type=str, help='Name for experiment', required=True);
p.add_argument('--lvlStats', action="store_const", const=True, default=False,
               help='If set print lvl stats');
p.add_argument('--usrStats', action="store_const", const=True, default=False,
               help='If set print user stats');
p.add_argument('--lvlset', type=str, help='Path to levelset used in experiment', required=True);
p.add_argument('--timeout', type=int, default=10, help='Timeout in seconds for z3 queries.')

def error(msg):
    eprint(msg);
    exit(-1)

def isSrcUser(src):
    return src != 'verifier'

if __name__ == "__main__":
    args = p.parse_args();

    s = open_sqlite_db("../logs/" + args.ename + "/events.db")()
    lvlsetName, lvls = loadBoogieLvlSet(args.lvlset)

    lvlStats = { lvlN: {
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
    usrStats = { }
    startTimes = { }

    for e in s.query(Event).all():
      typ, src, ename, time, p = e.type, e.src, e.experiment, e.time, e.payl()

      if ('lvlset' in p and p['lvlset'] != lvlsetName):
        error("Logs refer to levelset " + p['lvlset'] + " which is not loaded.")

      if ('lvlid' in p and p['lvlid'] not in lvls):
        error("Logs refer to level " + p['lvlid'] + " which is not found in current lvlset.")

      if ('lvlid' in p):
        lvl = lvls[p['lvlid']]
        lvlS = lvlStats[p['lvlid']]
      else:
        lvl = None
        lvlS = None

      usrS = usrStats.get(src, {
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
        error("Logs refer to experiment " + ename +
          " which is different from specified experiment " + args.ename)
      """

      if (typ == "StartLevel"):
        usrS["lvlsStarted"] += 1
        lvlS['nusersStarted'] += 1
        lvlS['usersStarted'].add(src);
        startTimes[src] = time
      elif (typ == "TutorialStart"):
        usrS["tutorialStarted"] += 1
      elif (typ == "TutorialDone"):
        usrS["tutorialFinished"] += 1
      elif (typ == "TriedInvariant"):
        usrS["nInvariantsTried"] += 1
        lvlS["nInvariantsTried"] += 1
        usrS["invariantsTried"].add((p['raw'], p['canonical']))
        lvlS["invariantsTried"].add((p['raw'], p['canonical']))
      elif (typ == "PowerupsActivated"):
        usrS['totalNPowerups'] += len(p['powerups'])
        usrS['timesPowerupsActivated'] += 1
        usrS['sumPowerupMultipliers'] += reduce(lambda x,y: x*y, [z[1] for z in p['powerups']], 1)
      elif (typ == "FoundInvariant"):
        usrS["nInvariantsFound"] += 1
        lvlS["nInvariantsFound"] += 1
        usrS["invariantsFound"].add((p['raw'], p['canonical']))
        lvlS["invariantsFound"].add((p['raw'], p['canonical']))
      elif (typ == "VerifyAttempt"):
        pass
      elif (typ == "SkipToNextLevel"):
        usrS['skipped'] += 1
        lvlS['skipped'] += 1
      elif (typ == "FinishLevel"):
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
        error("Unknown type: " + typ)

    for lvlName in lvls:
      lvlS = lvlStats[lvlName]
      lvl = lvls[lvlName]
      bbs = lvl['program']
      loop = lvl['loop']
      partialInvs = [ lvl['partialInv'] ] if 'partialInv' in lvl else []
      splitterPreds = lvl['splitterPreds'] if 'splitterPreds' in lvl else [ ]
      invM = { str(parseExprAst(b)) : raw for (raw, b) in lvlS["invariantsFound"] }
      boogie_invs = set([parseExprAst(x[1]) for x in lvlS["invariantsFound"]])
      loop_header = loop.loop_paths[0][0]
      sps = list(propagate_sp(bbs)[loop_header])
      boogie_invs = boogie_invs.union(sps)
      boogie_invs = boogie_invs.union(partialInvs)

      for b in boogie_invs:
        if str(b) not in invM:
          invM[str(b)] = str(b);

      if (len(splitterPreds) > 0):
        ((overfitted, overfitted_ignore), (nonind, nonind_ignore), sound, violations) =\
            tryAndVerifyWithSplitterPreds(bbs, loop, set(), boogie_invs,
            splitterPreds, partialInvs, args.timeout)
      else:
        overfitted, nonind, sound, violations =\
            tryAndVerify_impl(bbs, loop, set(), boogie_invs, args.timeout)

      lvlS["solved"] = (len(violations) == 0)
      lvlS["sound"] = [invM.get(str(x), str(x)) for x in sound];
      lvlS["overfitted"] = [invM.get(str(x[0]), str(x[0])) for x in overfitted]
      lvlS["nonind"] = [invM.get(str(x[0]),str(x[0])) for x in nonind]

    if (args.lvlStats):
      print ", ".join(["Level", "Solved", "#Started", "Finished", "Total Time", "Ave Time/User", "#Invs Tried", "Ave #Invs Tried/Usr""#Invs Found", "#Invs Found", "Ave #Invs Found/Usr", "#Sound", "Sound", "#Overfitted", "Overfitted", "#Nonind", "Nonind"])
      for (lvlName, lvlS) in lvlStats.items():
        print ", ".join([\
          lvlName,\
          str(lvlS["solved"]),\
          str(lvlS["nusersStarted"]),\
          str(lvlS["nusersFinished"]),\
          str(lvlS["totalTime"]),\
          str(lvlS["totalTime"] / lvlS["nusersFinished"]),\
          str(lvlS["nInvariantsTried"]),\
          str(lvlS["nInvariantsTried"]/(lvlS["nusersFinished"]*1.0)),\
          str(lvlS["nInvariantsFound"]),\
          str(lvlS["nInvariantsFound"]/(lvlS["nusersFinished"]*1.0)),\
          str(len(lvlS["sound"])),\
          ";".join(lvlS["sound"]),\
          str(len(lvlS["overfitted"])),\
          ";".join(lvlS["overfitted"]),\
          str(len(lvlS["nonind"])),\
          ";".join(lvlS["nonind"])]);
