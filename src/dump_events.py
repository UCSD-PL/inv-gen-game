#!/usr/bin/env python

from argparse import ArgumentParser
from sqlalchemy import func

from lib.invgame_server.models import Event
from lib.invgame_server.db_util import open_db

if __name__ == "__main__":
  p = ArgumentParser(description="Build graphs from database")
  p.add_argument("db", help="Database path")
  p.add_argument('--assignmentId', help="Assignment id")

  args = p.parse_args()

  sessionF = open_db(args.db)
  session = sessionF()
  query = session.query(Event)

  if args.assignmentId:
    query = query.filter(func.json_extract(Event.payload, "$.assignmentId") == args.assignmentId)

  for evt in query.all():
    print(evt.time, evt.type, evt.experiment, evt.src, evt.payl())
