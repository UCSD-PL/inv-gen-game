#! /usr/bin/env python
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey, create_engine, DateTime, Sequence
from sqlalchemy.orm import relationship, sessionmaker
from json import loads, dumps
from js import esprimaToBoogie
from datetime import datetime
from models import open_sqlite_db, Source, Event
from db_util import *

import json
import sys;

if len(sys.argv) != 4:
    print "Usage: <db_file> <log_file> <ename>"
    sys.exit(-1)

s = open_sqlite_db(sys.argv[1])()
f = open(sys.argv[2], 'r')
ename = sys.argv[3]

for l in f:
  e = json.loads(l)

  if e["method"] != "logEvent":
    continue;

  time = e["time"]
  ip = e['ip']
  (worker_id, evt_type, rest) = e["args"]
  addEvent(worker_id, evt_type, time, ename, ip, rest, s)
