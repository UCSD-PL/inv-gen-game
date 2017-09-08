#!/usr/bin/env python2.7

from argparse import ArgumentParser
from boto.mturk.connection import MTurkRequestError
from collections import OrderedDict
from datetime import datetime
from sqlalchemy import func
import json

from models import Event, SurveyData, VerifyData
from db_util import open_db, filterEvents, filterSurveys
import mturk_util

def _add(m, k, v):
  a = m.get(k, [])
  a.append(v)
  m[k] = a

def _typs(events):
  return [x.type for x in events]

def events(session, **kwargs):
  query = session.query(
    Event,
    func.json_extract(Event.payload, "$.lvlid").label("lvlid"),
    func.json_extract(Event.payload, "$.lvlset").label("lvlset"),
    func.json_extract(Event.payload, "$.workerId").label("workerId"),
    func.json_extract(Event.payload, "$.assignmentId").label("assignmentId"))
  return filterEvents(query, **kwargs).all()


def splitEventsByAssignment(session, **kwargs):
  m = {}
  for e in events(session, **kwargs):
    _add(m, (e.workerId, e.assignmentId), e)

  for k in m:
    m[k].sort(key=lambda e:  e[0].time)
  return m
  

def splitGameInstances(session, **kwargs):
  """
    Split the events for each (assignment,worker) pair into
    separate levels. In the process remove any spurious events such as:
      - StartLevel in the middle of a started level
      - FinishLevel when there is no level present
      - Any event after a GameDone
      - Any in-level events (e.g. FoundInvariant) when there is no level present
  """
  stats = {}
  m = splitEventsByAssignment(session, **kwargs)
  plays = {}

  for k in m:
    curLvl = None
    gameDone = None

    ignore = ['Consent', 'TutorialStart', 'TutorialDone', 'ReplayTutorialAll']
    in_lvl = ['TriedInvariant', 'FoundInvariant', 'VerifyAttempt', 'PowerupsActivated', 'SkipToNextLevel']

    for (ev, lvlid, lvlset, workerId, assignmentId) in m[k]:
      if (ev.type in ignore):
        continue

      if (gameDone is not None):
        _add(stats, 'spurious_event_after_gamedone', ev)
        continue

      if (curLvl != None):
        if ev.type in in_lvl + ['GameDone', 'FinishLevel']:
          _add(plays, curLvl, ev)
          if ev.type in ['GameDone', 'FinishLevel']:
            curLvl = None
        else:
           _add(stats, 'spurious_event_inlevel', ev)
      else:
        if ev.type == 'StartLevel':
          curLvl = (assignmentId, workerId, (lvlset, lvlid))
          _add(plays, curLvl, ev)
            
      if (ev.type == 'GameDone'):
        gameDone = ev

  return stats, plays

def prunePlays(plays, n):
  """
  Prune the plays such that for each level we keep only the first n
  plays in chronological order.
  """
  lvlPlays = {} # map from level to the plays for that level
  for (k, v) in plays.items():
    (_, _, (_, lvlid)) = k
    _add(lvlPlays, lvlid, (k, v))

  # Sort the plays by start time
  for lvlid in lvlPlays:
    lvlPlays[lvlid].sort(key=lambda x:  x[1][0].time)

  # Keep only the first n for each level.
  for lvlid in lvlPlays:
    lvlPlays[lvlid] = lvlPlays[lvlid][:n]

  return {k: play for lvlId in lvlPlays for (k, play) in lvlPlays[lvlId]}

def interrupted(events):
  """ Given the events of one play, determine if it was interrupted - i.e. if it has a
      GameDone or a SkipLevel event, or none of these and no FinishLevel
  """
  ev_types = [e.type for e in events]
  return 'SkipLevel' in ev_types or 'GameDone' in ev_types or 'FinishLevel' not in ev_types

def finished(events):
  """ Given the events of one play, determine if it was finished - i.e. if its last event is a FinishLevel
  """
  return events[-1].type == 'FinishLevel'

def assignment(events):
  assert len(set(e.payl()['assignmentId'] for e in events)) == 1
  return events[0].payl()['assignmentId']

def worker(events):
  assert len(set(e.payl()['workerId'] for e in events)) == 1
  return events[0].payl()['workerId']

if __name__ == "__main__":
  p = ArgumentParser(description="Build graphs from database")
  p.add_argument("--db", required=True, help="Database path")
  p.add_argument("--experiments", nargs='+', help="Only consider plays from these experiments")
  p.add_argument("--lvlids", nargs='+', help="Only consider plays from these levels")
  p.add_argument("--nplays", type=int, help="Only consider the first N plays for each level")
  p.add_argument("--stat",
    choices=[
      'fun_histo',
      'math_exp_histo',
      'prog_exp_histo',
      'challenging_histo',
      'num_players_per_lvl',
    ], help='Which stat to print', required=True)

  args = p.parse_args()
  filter_args = {}
  if args.experiments:
    filter_args['enames'] = args.experiments
  if args.lvlids:
    filter_args['lvls'] = args.lvlids

  sessionF = open_db(args.db)
  session = sessionF()
  stats, plays = splitGameInstances(session, **filter_args)

  if (args.nplays is not None):
    plays = prunePlays(plays, args.nplays)

  assignments = set(assignment(play) for play in plays.values())
  """
  print "Stats:"
  for k in stats:
    print k, len(stats[k]), [x.type for x in stats[k]]
  """

  if args.stat in ['fun_histo', 'challenging_histo']:
    field = {
      'fun_histo':  'fun',
      'challenging_histo':  'challenging',
    }[args.stat]

    histo = { }

    for s in filterSurveys(session.query(SurveyData), assignments=assignments).all():
      v = int(json.loads(s.payload)[field])
      histo[v] = histo.get(v, 0) + 1

    print "Score, # Replies"
    for k in sorted(histo.keys()):
      print k, ',', histo[k]

  elif args.stat in ['math_exp_histo', 'prog_exp_histo']:
    field = {
      'math_exp_histo':  'math_experience',
      'prog_exp_histo':  'prog_experience',
    }[args.stat]

    histo = { }
    workerM = {}

    # A worker may self-report different experiences in several hits.  Collect
    # all the self-reported experiences, average out and round to nearest
    # number.
    for s in filterSurveys(session.query(SurveyData), assignments=assignments).all():
      v = int(json.loads(s.payload)[field])
      _add(workerM, s.worker, v)

    for w in workerM:
      ave_score = int(round(sum(workerM[w]) * 1.0 / len(workerM[w])))
      histo[ave_score] = histo.get(ave_score, 0) + 1

    print "Score, # Workers"
    keys = range(1,6)

    for k in keys:
      print k, ',', histo.get(k, 0)
  elif args.stat == 'num_players_per_lvl':
    players = { }
    interrupts = {}
    finishes = {}
    total_time = {}
    found_invs = {}
    tried_invs = {}

    for (assignmentId, workerId, (lvlset, lvlid)) in plays:
      play = plays[(assignmentId, workerId, (lvlset, lvlid))]
      _add(players, lvlid, workerId)

      assert interrupted(play) or finished(play), _typs(play)
      if interrupted(play):
        interrupts[lvlid] = interrupts.get(lvlid, 0) + 1
      else:
        finishes[lvlid] = finishes.get(lvlid, 0) + 1

      time_spent = (play[-1].time - play[0].time).total_seconds()
      total_time[lvlid] = total_time.get(lvlid, 0.0) + time_spent
      for e in play:
        if e.type == 'FoundInvariant':
          _add(found_invs, lvlid, e.payl()['raw'])
        if e.type == 'TriedInvariant':
          _add(tried_invs, lvlid, e.payl()['raw'])

    print "Level, # Plays, # Finishes, #Interrupts,  %Finishing, # Unique Players, Average Time Spent(s)"
    for k in sorted(players.keys()):
      num_plays = len(players[k])
      finished_plays = finishes.get(k, 0)
      interrupted_plays = interrupts.get(k, 0)
      unique_players = len(set(players[k]))
      print k, ",", \
            num_plays, ",", \
            finished_plays, ",", \
            interrupted_plays, ",", \
            100*(finished_plays*1.0/num_plays), ",", \
            unique_players, ",", \
            total_time[k] / num_plays
