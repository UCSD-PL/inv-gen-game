from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey, create_engine, DateTime, Sequence
from sqlalchemy.orm import relationship, sessionmaker
from json import loads, dumps
from js import esprimaToBoogie
from datetime import datetime

import json

Base = declarative_base();

class Source(Base):
  __tablename__ = "sources"
  name = Column(String, primary_key=True)
  events = relationship("Event", backref="source", lazy="dynamic")


class Event(Base):
  __tablename__ = "events"
  id = Column(Integer, Sequence('user_id_seq'), primary_key=True)
  type = Column(String)
  src = Column(String, ForeignKey("sources.name"))
  addr = Column(String) # For mturk users this is the ip of the access
  time = Column(DateTime)
  payload = Column(String(16536))

if __name__ == "__main__":
  import sys;

  engine = create_engine('sqlite:///test.db', echo=True)
  Session = sessionmaker(bind=engine)

  s = Session()

  Base.metadata.create_all(engine);

  srcs = {
    s.name : s for s in s.query(Source).all()
  }

  with open(sys.argv[1], 'r') as f:
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
      if (evt_type == "TutorialStart"):
        payl = { }
      elif (evt_type == "TutorialDone"):
        payl = { }
      elif (evt_type == "StartLevel" or evt_type == "FinishLevel"):
        payl = { "lvlset" : rest[0], "lvlid" : rest[1] }
        if evt_type == "FinishLevel":
          payl["verified"] = rest[2]
          invs = zip(rest[3], [ str(esprimaToBoogie(x, {})) for x in rest[4] ])
          payl["all_found"] = invs;
      elif (evt_type == "FoundInvariant"):
        payl = [ rest[2], str(esprimaToBoogie(rest[3], { })) ]
      else:
        print "Unknown event: ", e
  
      t = datetime.fromtimestamp(time)
      evt = Event(type=evt_type, src=src.name, addr=ip, time=t, payload=dumps(payl))
      s.add(evt);

s.commit();
