#! /usr/bin/env python
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey, create_engine, DateTime, Sequence
from sqlalchemy.orm import relationship, sessionmaker
from json import loads, dumps
from js import esprimaToBoogie
from datetime import datetime
from models import open_sqlite_db, Source, Event

import json
import sys;

if len(sys.argv) != 4:
    print "Usage: <db_file> <log_file> <ename>"
    sys.exit(-1)

s = open_sqlite_db(sys.argv[1])
f = open(sys.argv[2], 'r')
ename = sys.argv[3]

srcs = {
    s.name : s for s in s.query(Source).all()
}

for l in f:
  e = json.loads(l)

  if e["method"] != "logEvent":
    continue;

  time = e["time"]
  ip = e['ip']
  (worker_id, evt_type, rest) = e["args"]

  if worker_id not in srcs:
    src = Source(name=worker_id)
    s.add(src);
    srcs[worker_id] = src;

  src = srcs[worker_id]
  if (evt_type == "TutorialStart" or evt_type == "ReplayTutorialAll"):
    payl = { }
  elif (evt_type == "TutorialDone"):
    payl = { }
  elif (evt_type == "StartLevel" or evt_type == "FinishLevel"):
    payl = { "lvlset" : rest[0], "lvlid" : rest[1] }
    if evt_type == "FinishLevel":
      payl["verified"] = rest[2]
      invs = zip(rest[3], [ str(esprimaToBoogie(x, {})) for x in rest[4] ])
      payl["all_found"] = invs;
  elif (evt_type == "FoundInvariant" or evt_type == "TriedInvariant"):
    payl = { "lvlset" : rest[0], "lvlid" : rest[1],
              "raw": rest[2], "canonical": str(esprimaToBoogie(rest[3], { }))}
  elif (evt_type == "GameDone"):
    payl = { "numLvlsPassed" : rest[0] }
  else:
    print "Unknown event: ", e
  t = datetime.fromtimestamp(time)
  evt = Event(type=evt_type, src=src.name, addr=ip, experiment=ename, time=t, payload=dumps(payl))
  s.add(evt);

s.commit();
