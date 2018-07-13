#!/usr/bin/env python
from argparse import ArgumentParser
from boto.mturk.connection import MTurkRequestError
from collections import OrderedDict
from datetime import datetime
from sqlalchemy import func
import json

from lib.invgame_server.levels import loadBoogieFile, loadBoogieLvlSet
from lib.invgame_server.models import Event, SurveyData, VerifyData
from lib.invgame_server.db_util import open_db, filterEvents, filterSurveys
from pyboogie.ast import parseExprAst
from lib.invgame_server.vc_check import tryAndVerifyLvl
from functools import reduce

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

def split(lst, pred):
  res = []
  cur = []
  for x in lst:
    cur.append(x)

    if pred(x):
      res.append(cur)
      cur = []

  if (len(cur) > 0):
    res.append(cur)

  return res


def splitEventsByLvlPlay(session, **kwargs):
  """
  Split the events by their (assignment, worker, lvlid) tuples. Any event
  without lvlid is ignored
  """
  m = splitEventsByAssignment(session, **kwargs)
  plays = {}

  for k in m:

    ignore = ['Consent', 'TutorialStart', 'TutorialDone', 'ReplayTutorialAll', 'VerifyAttempt']

    for (ev, lvlid, lvlset, workerId, assignmentId) in m[k]:
      if (ev.type in ignore):
        continue

      if (lvlid is None):
        continue

      curLvl = (assignmentId, workerId, (lvlset, lvlid))
      _add(plays, curLvl, ev)

  split_plays = {}
  for ((assignmentId, workerId, (lvlset, lvlid)), play) in list(plays.items()):
    play.sort(key=lambda x: x.time)
    play_lst = split(play, lambda evt:  evt.type == 'StartLevel')

    #if (len(play_lst) != 1):
    #  print play_lst

    for idx, split_play in enumerate(play_lst):
      split_plays[(assignmentId, workerId, (lvlset, lvlid), idx)] = split_play

  return split_plays
  
def pruneByNumPlays(plays, n):
  """
  Prune the plays such that for each level we keep only the first n
  plays in chronological order.
  """
  lvlPlays = {} # map from level to the plays for that level
  for (k, v) in list(plays.items()):
    _add(lvlPlays, lvlid(v), (k, v))

  # Sort the plays by start time
  for lvlid in lvlPlays:
    lvlPlays[lvlid].sort(key=lambda x:  x[1][0].time)

  # Keep only the first n for each level.
  for lvlid in lvlPlays:
    lvlPlays[lvlid] = lvlPlays[lvlid][:n]

  return {k: play for lvlId in lvlPlays for (k, play) in lvlPlays[lvlId]}

def pruneByNumPlayers(plays, n):
  """
  Prune the plays such that for each level we keep only the 
  plays by the first n unique players in chronological order.
  """
  lvlPlays = {} # map from level to the plays for that level
  for (k, v) in list(plays.items()):
    _add(lvlPlays, lvlid(v), (k, v))

  # Sort the plays by start time
  for lvlid in lvlPlays:
    lvlPlays[lvlid].sort(key=lambda x:  x[1][0].time)

  # For each level keep the plays for the first N unique players
  for lvlid in lvlPlays:
    unique_players = set()
    old_plays = lvlPlays[lvlid]
    new_plays = []
    while len(unique_players) < n and len(old_plays) > 0:
      play = old_plays.pop(0)
      unique_players.add(worker(play[1]))
      new_plays.append(play)

    lvlPlays[lvlid] = new_plays

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
  ev_types = [e.type for e in events]
  return 'FinishLevel' in ev_types

def assignment(events):
  assert len(set(e.payl()['assignmentId'] for e in events)) == 1
  return events[0].payl()['assignmentId']

def worker(events):
  assert len(set(e.payl()['workerId'] for e in events)) == 1
  return events[0].payl()['workerId']

def get_lvlid(events):
  assert len(set(e.payl()['lvlid'] for e in events)) == 1,\
    (assignment(events), worker(events), [set(e.payl()['lvlid'] for e in events)], [(e.type, e.payl()['lvlid']) for e in events])
  return events[0].payl()['lvlid']

def start_time(events):
  return events[0].time

def duration(events):
  return (events[-1].time - events[0].time).total_seconds()

def math_exp(worker):
    """
    Return the avearge self-reported math experience rounded to the nearest int
    """
    scores = session.query(func.json_extract(SurveyData.payload, '$.math_experience')).filter(SurveyData.worker == worker).all()
    if (len(scores) == 0):
        return None
    ave_math_exp = sum(int(score[0]) for score in scores) * 1.0 / len(scores)
    return int(round(ave_math_exp))

def prog_exp(worker):
    """
    Return the avearge self-reported prog experience rounded to the nearest int
    """
    scores = session.query(func.json_extract(SurveyData.payload, '$.prog_experience')).filter(SurveyData.worker == worker).all()
    if (len(scores) == 0):
        return None
    ave_math_exp = sum(int(score[0]) for score in scores) * 1.0 / len(scores)
    return int(round(ave_math_exp))

def ave_exp(worker):
    """
    Return the avearge of the programming and math experience rounded to the nearest int
    """
    e1 = math_exp(worker)
    e2 = prog_exp(worker)
    if e1 is None or e2 is None:
      return None

    return int(round((e1+e2)/2.0))

def max_exp(worker):
    """
    Return the max of the programming and math experience rounded to the nearest int
    """
    e1 = math_exp(worker)
    e2 = prog_exp(worker)
    if e1 is None:
        return e2

    if e2 is None:
        return e1

    return max(e1, e2)

def sum_exp(worker):
    """
    Return the sum of the programming and math experience rounded to the nearest int
    """
    e1 = math_exp(worker)
    e2 = prog_exp(worker)
    if e1 is None or e2 is None:
      return None

    return e1 + e2

def assignment_experiment(assignId):
    evts = session.query(Event)\
            .filter(func.json_extract(Event.payload, '$.assignmentId') == assignId)
    s = set(e.experiment for e in evts)
    assert (len(s) == 1)
    return list(s)[0]

def workers_played(lvl, exp):
    workers = session.query(Event.src)\
            .filter(func.json_extract(Event.payload, '$.lvlid') == lvl)\
            .filter(Event.type == 'FoundInvariant')\
            .filter(Event.experiment == exp).all()
    return set([x[0] for x in workers])

def verified_up_to_exp(lvl, exp, exp_typ, experiment):
    """
    Return whether a lvl was solved by adding all of the invariants up to a math experience level exp
    """
    assert typ in ['math', 'prog']
    tag = '{}-exp-le-{}'.format(typ, exp)
    exp_f = math_exp if typ == 'math' else prog_exp

    entries = session.query(VerifyData.provedflag)\
            .filter(VerifyData.lvl == lvl)\
            .filter(func.json_extract(VerifyData.config, '$.mode') == 'combined')\
            .filter(func.json_extract(VerifyData.config, '$.tag') == tag)\
            .order_by(VerifyData.time.desc())\
            .all()

    if (len(entries) == 0):
        workers = workers_played(lvl, experiment)
        workers = [w for w in workers if exp_f(w) is not None and exp_f(w) <= exp]
        assert len(workers) == 0, "{}, {}, {}".format(lvl, exp, workers)
        return False
    return entries[0][0] == 1

def verified_by_worker(lvl, worker, exp):
  s = session.query(VerifyData)\
    .filter(VerifyData.lvl == lvl)\
    .filter(func.json_extract(VerifyData.config, "$.mode") == "individual")\
    .filter(func.json_extract(VerifyData.config, "$.enames[0]") == exp)\
    .filter(func.json_extract(VerifyData.payload, "$.workers[0]") == worker)\
    .order_by(VerifyData.time.desc())

  vs = s.all()
  if (len(vs) == 0):
    assert len(events(session, typ='InvariantFound', lvls=[lvl], workers=[worker])) == 0
    return False
  #assert (len(vs) == 1), "Not 1 VerifyData entry for {}, {}, {}".format(lvl, worker, exp),
  return vs[-1].provedflag

def verified(lvl):
  s = session.query(VerifyData)\
    .filter(VerifyData.lvl == lvl)
  vs = s.all()

  for v in vs:
    if v.provedflag:
      return True

  return False

def verified_by_play(lvl, assignment, worker, exp):
  s = session.query(VerifyData)\
    .filter(VerifyData.lvl == lvl)\
    .filter(func.json_extract(VerifyData.config, "$.mode") == "individual-play")\
    .filter(func.json_extract(VerifyData.config, "$.enames[0]") == exp)\
    .filter(func.json_extract(VerifyData.payload, "$.workers[0]") == worker)\
    .filter(func.json_extract(VerifyData.payload, "$.assignments[0]") == assignment)\
    .order_by(VerifyData.time.desc())
  vs = s.all()
  if (len(vs) == 0):
    assert len(events(session, typ='InvariantFound', lvls=[lvl], workers=[worker])) == 0
    return False
  #assert (len(vs) == 1), "Not 1 VerifyData entry for {}, {}, {}, {} = {}".format(lvl, assignment, worker, exp, vs)
  return vs[0].provedflag == 1

def sound_invs(lvl):
    s = session.query(VerifyData.payload)\
        .filter(VerifyData.lvl == lvl)\

    invs = [json.loads(x[0])['sound'] for x in s.all()]
    return reduce(lambda acc, x:    acc.union(set(x)), invs, set())

def really_verified_by_play(lvl, assignment, worker, exp, play, timeout):
  invs = set([parseExprAst(x.payl()['canonical']) for x in play if x.type == 'FoundInvariant'])
  (overfitted, _), (nonind, _), sound, violations = tryAndVerifyLvl(lvl, invs, set(), timeout)
  assert type(violations) == list
  return len(violations) == 0

if __name__ == "__main__":
  all_lvl_cols = ['nplays', 'nplay_solved', 'nfinish', 'ninterrupt', 'nplayers', 'nplayers_solved', 'avetime', 'ninv_found', 'ninv_sound', 'ninv_tried', 'solved']
  all_exp_cols = ['nplays', 'nplay_solved', 'nfinish', 'ninterrupt', 'nplayers', 'ave_levels_solved_per_player', 'avetime', 'ninv_found', 'ninv_tried', 'nlevels_solved_ind', 'nlevels_solved_cum']
  combined_exp_cols = ['nplays', 'nplay_solved', 'nfinish', 'ninterrupt', 'nplayers', 'ave_levels_solved_per_player', 'avetime', 'ninv_found', 'ninv_tried', 'nlevels_solved_ind']
  p = ArgumentParser(description="Build graphs from database")
  p.add_argument("--db", required=True, help="Database path")
  p.add_argument("--experiment", type=str, help="Only consider plays from this experiment", required=True)
  p.add_argument("--lvlids", nargs='+', help="Only consider plays from these levels")
  p.add_argument("--nplays", type=int, help="Only consider the first N plays for each level")
  p.add_argument("--nplayers", type=int, help="Only consider the first N unique players for each level")
  p.add_argument("--stat",
    choices=[
      'fun_histo',
      'math_exp_histo',
      'prog_exp_histo',
      'challenging_histo',
      'lvl_stats',
      'math_exp_stats',
      'prog_exp_stats',
      'ave_exp_stats',
      'max_exp_stats',
      'sum_exp_stats',
      'lvl_solved_stacked_math',
      'lvl_solved_stacked_prog',
      'lvl_solved_stacked_ave',
      'lvl_solved_stacked_max',
      'lvl_solved_stacked_sum',
      'viewed_before_solve',
      'first_soln_cost',
    ], help='Which stat to print', required=True)
  p.add_argument("--lvl-columns", nargs='+', choices = all_lvl_cols, help='Optionally pick which columns per benchmarks we want')
  p.add_argument("--exp-columns", nargs='+', choices = all_exp_cols, help='Optionally pick which columns per experience level we want')
  p.add_argument("--timeout", type=int, help="Z3 timeout")
  p.add_argument("--lvlset", required=True, help="Include lvlset invs; may specify multiple items (unset = any)")

  args = p.parse_args()
  filter_args = {}

  lvlset, lvls = loadBoogieLvlSet(args.lvlset)
  if args.experiments:
    filter_args['enames'] = args.experiments
  if args.lvlids:
    filter_args['lvls'] = args.lvlids

  if args.lvl_columns is not None:
    assert args.stat == 'lvl_stats'
    lvl_cols = args.lvl_columns
  else:
    lvl_cols = all_lvl_cols

  if args.exp_columns is not None:
    assert args.stat in ['math_exp_stats', 'prog_exp_stats', 'ave_exp_stats', 'max_exp_stats', 'sum_exp_stats']
    exp_cols = args.exp_columns
  else:
    if args.stat in ['math_exp_stats', 'prog_exp_stats']:
        exp_cols = all_exp_cols
    else:
        exp_cols = combined_exp_cols

  if (args.stat in ['ave_exp_stats', 'max_exp_stats', 'sum_exp_stats'] and 'nlevels_solved_cum' in exp_cols):
    print("Error: Can't use column type 'nlevels_solved_cum' with stat type {}".format(args.stat))
    exit(-1)

  if args.nplayers is not None and args.nplays is not None:
    print("Error: Can't specify both --nplayers and --nplays")
    exit(-1)

  sessionF = open_db(args.db)
  session = sessionF()
  plays = splitEventsByLvlPlay(session, **filter_args)

  if (args.nplays is not None):
    plays = pruneByNumPlays(plays, args.nplays)

  if (args.nplayers is not None):
    plays = pruneByNumPlayers(plays, args.nplayers)

  assignments = set(assignment(play) for play in list(plays.values()))
  lvlids = set(get_lvlid(play) for play in list(plays.values()))


  playsPerLvl = {lvlid: [] for lvlid in lvlids}
  for (assignmentId, workerId, (lvlset, lvlid)) in plays:
    play = plays[(assignmentId, workerId, (lvlset, lvlid))]
    _add(playsPerLvl, lvlid, play)

  if args.stat in ['fun_histo', 'challenging_histo']:
    field = {
      'fun_histo':  'fun',
      'challenging_histo':  'challenging',
    }[args.stat]

    histo = { }

    for s in filterSurveys(session.query(SurveyData), assignments=assignments).all():
      v = int(json.loads(s.payload)[field])
      histo[v] = histo.get(v, 0) + 1

    print("Score, # Replies")
    for k in sorted(histo.keys()):
      print(k, ',', histo[k])

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

    print("Score, # Workers")
    keys = list(range(1,6))

    for k in keys:
      print(k, ',', histo.get(k, 0))
  elif args.stat == 'lvl_stats':
    players = {lvlid: [] for lvlid in lvlids}
    interrupts = {lvlid: 0 for lvlid in lvlids}
    finishes = {lvlid: 0 for lvlid in lvlids}
    total_time = {lvlid: 0.0 for lvlid in lvlids}
    found_invs = {lvlid: [] for lvlid in lvlids}
    tried_invs = {lvlid: [] for lvlid in lvlids}

    for (assignmentId, workerId, (lvlset, lvlid), idx) in plays:
      play = plays[(assignmentId, workerId, (lvlset, lvlid), idx)]
      _add(players, lvlid, workerId)

      assert interrupted(play) or finished(play), _typs(play)
      if interrupted(play):
        interrupts[lvlid] = interrupts.get(lvlid, 0) + 1
      else:
        finishes[lvlid] = finishes.get(lvlid, 0) + 1

      total_time[lvlid] = total_time.get(lvlid, 0.0) + duration(play)
      for e in play:
        if e.type == 'FoundInvariant':
          _add(found_invs, lvlid, e.payl()['canonical'])
        if e.type == 'TriedInvariant':
          _add(tried_invs, lvlid, e.payl()['canonical'])

    col_header = {
      'nplays': '# Plays',
      'nplay_solved': '# Solving Plays',
      'nfinish': '# Finishes',
      'ninterrupt': '#Interrupts',
      'nplayers': '# Unique Players',
      'nplayers_solved': '# Players Solved Individually',
      'avetime': 'Average Time Spent(s)',
      'ninv_found': '# Invariants Found',
      'ninv_sound': '# Sound Invariants Found',
      'ninv_tried': '# Invariants Tried',
      'solved': 'Solved? (by any)'
    }
    header_str = "Level"
    for col in lvl_cols:
      header_str += ', ' + col_header[col]
    print(header_str)

    for k in sorted(players.keys()):
      line_str = k
      for col in lvl_cols:
        line_str += ', '
        if col == 'nplays':
          num_plays = len(playsPerLvl[k])
          line_str += str(num_plays)
        elif col == 'nplay_solved':
          num_plays_solved = len([_f for _f in [really_verified_by_play(lvls[k], assignment(play), worker(play), 'new-benchmarks', play, args.timeout) for play in playsPerLvl[k]] if _f])
          line_str += str(num_plays_solved)
        elif col == 'nfinish':
          finished_plays = finishes.get(k, 0)
          line_str += str(finished_plays)
        elif col == 'ninterrupt':
          interrupted_plays = interrupts.get(k, 0)
          line_str += str(interrupted_plays)
        elif col == 'nplayers':
          unique_players = len(set(players[k]))
          line_str += str(unique_players)
        elif col == 'nplayers_solved':
          unique_players_solved = len([_f for _f in [verified_by_worker(k, workerId, args.experiment)\
            for workerId in set(players[k])] if _f])
          line_str += str(unique_players_solved)
        elif col == 'avetime':
          line_str += str(total_time[k] / num_plays)
        elif col == 'ninv_found':
          num_invs_found = len(set(found_invs[k]))
          line_str += str(num_invs_found)
        elif col == 'ninv_sound':
          num_invs_found = len(set(sound_invs(k)))
          line_str += str(num_invs_found)
        elif col == 'ninv_tried':
          num_invs_tried = len(set(tried_invs[k]))
          line_str += str(num_invs_tried)
        elif col == 'solved':
          line_str += str(verified(k))

      print(line_str)
  elif args.stat in ['math_exp_stats', 'prog_exp_stats', 'ave_exp_stats', 'max_exp_stats', 'sum_exp_stats']:
    exp_f = {
      'math_exp_stats':   math_exp,
      'prog_exp_stats':   prog_exp,
      'ave_exp_stats':    ave_exp,
      'max_exp_stats':    max_exp,
      'sum_exp_stats':    sum_exp,
    }[args.stat]

    exp_range = {
      'math_exp_stats':   (1, 6),
      'prog_exp_stats':   (1, 6),
      'ave_exp_stats':    (1, 6),
      'max_exp_stats':    (1, 6),
      'sum_exp_stats':    (2, 12),
    }[args.stat]
    experiences = list(range(*exp_range))

    players = {exp: [] for exp in experiences}
    playsPerExp = {exp: [] for exp in experiences}
    interrupts = {exp: 0 for exp in experiences}
    finishes = {exp: 0 for exp in experiences}
    total_time = {exp: 0.0 for exp in experiences}
    found_invs = {exp: [] for exp in experiences}
    tried_invs = {exp: [] for exp in experiences}
    lvls_solved = {exp: [] for exp in experiences}
    lvls_solved_cum = {exp: set() for exp in experiences}

    if (args.stat in ['math_exp_stats', 'prog_exp_stats']):
        typ = 'math' if args.stat == 'math_exp_stats' else 'prog'

        for l in lvlids:
          for exp in range(1, 6):
              if (verified_up_to_exp(l, exp, typ, args.experiment)):
                lvls_solved_cum[exp].add(l)

        # Some levels appear unsolved at higher levels due to timeouts
        for l in lvlids:
          for exp in experiences[1:]:
            lvls_solved_cum[exp] = lvls_solved_cum[exp].union(lvls_solved_cum[exp-1])


    for (assignmentId, workerId, (lvlset, lvlid)) in plays:
      exp = exp_f(workerId)
      if exp is None:
        print("Worker without self-reported experience: ", workerId)
        continue

      play = plays[(assignmentId, workerId, (lvlset, lvlid))]
      _add(players, exp, workerId)
      _add(playsPerExp, exp, play)

      assert interrupted(play) or finished(play), _typs(play)
      if interrupted(play):
        interrupts[exp] = interrupts.get(exp, 0) + 1
      else:
        finishes[exp] = finishes.get(exp, 0) + 1

      time_spent = (play[-1].time - play[0].time).total_seconds()
      total_time[exp] = total_time.get(exp, 0.0) + time_spent
      for e in play:
        if e.type == 'FoundInvariant':
          _add(found_invs, exp, e.payl()['canonical'])
        if e.type == 'TriedInvariant':
          _add(tried_invs, exp, e.payl()['canonical'])

      if verified_by_play(lvlid, assignmentId, workerId, args.experiment):
        _add(lvls_solved, exp, lvlid)

    col_header = {
      'nplays': '# Plays',
      'nplay_solved': '# Solving Plays',
      'nfinish': '# Finishes',
      'ninterrupt': '#Interrupts',
      'nplayers': '# Unique Players',
      'ave_levels_solved_per_player': 'Ave # lvls solved per player',
      'avetime': 'Average Time Spent(s)',
      'ninv_found': '# Invariants Found',
      'ninv_tried': '# Invariants Tried',
      'nlevels_solved_ind': '# of lvls solved individually',
      'nlevels_solved_cum': '# of lvls solved combined'
    }
    header_str = "Level"
    for col in exp_cols:
      header_str += ', ' + col_header[col]
    print(header_str)

    for k in sorted(players.keys()):
      line_str = str(k)
      for col in exp_cols:
        line_str += ', '
        if col == 'nplays':
          num_plays = len(playsPerExp[k])
          line_str += str(num_plays)
        elif col == 'nplay_solved':
          line_str += str(len(lvls_solved[k]))
        elif col == 'nfinish':
          finished_plays = finishes.get(k, 0)
          line_str += str(finished_plays)
        elif col == 'ninterrupt':
          interrupted_plays = interrupts.get(k, 0)
          line_str += str(interrupted_plays)
        elif col == 'nplayers':
          unique_players = len(set(players[k]))
          line_str += str(unique_players)
        elif col == 'ave_levels_solved_per_player':
          if unique_players > 0:
              line_str += str(len(set(lvls_solved[k])) * 1.0 / unique_players)
          else:
              line_str += '-'
        elif col == 'avetime':
          if (num_plays > 0):
              line_str += str(total_time[k] / num_plays)
          else:
              line_str += '-'
        elif col == 'ninv_found':
          num_invs_found = len(set(found_invs[k]))
          line_str += str(num_invs_found)
        elif col == 'ninv_tried':
          num_invs_tried = len(set(tried_invs[k]))
          line_str += str(num_invs_tried)
        elif col == 'nlevels_solved_ind':
          line_str += str(len(set(lvls_solved[k])))
        elif col == 'nlevels_solved_cum':
          assert args.stat in ['math_exp_stat', 'prog_exp_stat']
          line_str += str(len(set(lvls_solved_cum[k])))

      print(line_str)
  elif args.stat in ['lvl_solved_stacked_math', 'lvl_solved_stacked_prog']:
    exp_f = math_exp if args.stat == 'lvl_solved_stacked_math' else prog_exp
    nsolved_bench_explvl = {lvlid: [0 for x in range(1, 6)] for lvlid in lvlids}

    for (assignmentId, workerId, (lvlset, lvlid)) in plays:
      play = plays[(assignmentId, workerId, (lvlset, lvlid))]
      if verified_by_play(lvlid, assignmentId, workerId, args.experiment):
          nsolved_bench_explvl[lvlid][exp_f(workerId)-1] += 1

    print("Level, " + ",".join(map(str, list(range(1, 6)))) + ", Num Total Plays")
    for lvl in lvlids:
        print(lvl + ',' + ','.join([str(nsolved_bench_explvl[lvl][i]) for i in range(5)]) + ", {}".format(str(len(playsPerLvl[lvl]))))
  elif args.stat in ['lvl_solved_stacked_ave', 'lvl_solved_stacked_max', 'lvl_solved_stacked_sum']:
    exp_f = {
      'lvl_solved_stacked_ave': ave_exp,
      'lvl_solved_stacked_max': max_exp,
      'lvl_solved_stacked_sum': sum_exp
    }[args.stat]
    rng = {
      'lvl_solved_stacked_ave': (1, 6),
      'lvl_solved_stacked_max': (1, 6),
      'lvl_solved_stacked_sum': (2, 11)
    }[args.stat]

    experiences = list(range(*rng))
    nsolved_bench_explvl = {lvlid: [0 for x in experiences] for lvlid in lvlids}

    for (assignmentId, workerId, (lvlset, lvlid)) in plays:
      play = plays[(assignmentId, workerId, (lvlset, lvlid))]
      if verified_by_play(lvlid, assignmentId, workerId, args.experiment):
          nsolved_bench_explvl[lvlid][exp_f(workerId)-1] += 1

    print("Level, " + ",".join(map(str, experiences)) + ",Num Total Plays")
    for lvl in lvlids:
        print(lvl + ',' + ','.join([str(nsolved_bench_explvl[lvl][i]) for i in range(len(experiences))]) + ", {}".format(str(len(playsPerLvl[lvl]))))
  elif args.stat == 'viewed_before_solve':
    timePlaysPerLvl = {}

    for (assignmentId, workerId, (lvlset, lvlid)) in plays:
      play = plays[(assignmentId, workerId, (lvlset, lvlid))]
      _add(timePlaysPerLvl, lvlid, (play[0].time, assignmentId, workerId))

    for lvl in timePlaysPerLvl:
        timePlaysPerLvl[lvl].sort(key=lambda x: x[0])
        timePlaysPerLvl[lvl] = [(x[1], x[2]) for x in timePlaysPerLvl[lvl]]

    for (assignmentId, workerId, (lvlset, lvlid)) in plays:
      if (verified_by_play(lvlid, assignmentId, workerId, args.experiment)):
          nplay = timePlaysPerLvl[lvlid].index((assignmentId, workerId))
          previous_plays_by_same_user = [x for x in timePlaysPerLvl[lvlid][:nplay] if x[1] == workerId]
          previous_solved_plays_by_same_user = [x for x in previous_plays_by_same_user if verified_by_play(lvlid, x[0], x[1], args.experiment)]
          if (len(previous_plays_by_same_user) > 0):
              print("Solving play {}, {}, {}: seen {}({} solving) times by {} beforehand and {} times total.".format(lvlid, assignmentId, workerId, len(previous_plays_by_same_user), len(previous_solved_plays_by_same_user), workerId, nplay))
  elif args.stat == 'first_soln_cost':
    firstSoln = {}

    for (assignmentId, workerId, (lvlset, lvlid)) in plays:
      if (verified_by_play(lvlid, assignmentId, workerId, args.experiment)):
          play = plays[(assignmentId, workerId, (lvlset, lvlid))]
          if lvlid not in firstSoln or start_time(play) < start_time(firstSoln[lvlid]):
              firstSoln[lvlid] = play

    print("Level, Person Seconds, Num Plays, Num Unique Users, Cost")
    for lvl in lvlids:
        if lvl not in firstSoln:
            print("{}, -, -, -, -".format(lvl))
            continue

        sol = firstSoln[lvl]
        num_plays = 0
        users = set()
        total_time = 0.0
        cost = 0

        for play in playsPerLvl[lvl]:
            if start_time(play) > start_time(sol):
                continue

            num_plays += 1
            users.add(worker(play))
            total_time += duration(play)
            cost += 0.75

        print("{}, {}, {}, {}, {}".format(lvl, total_time, num_plays, len(users), cost))
