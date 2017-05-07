#pylint: disable=no-self-argument
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey, \
        create_engine, DateTime, Sequence
from sqlalchemy.orm import relationship, sessionmaker
import json
import re

Base = declarative_base();

local_sources = [ "server" ]
workerIDhashRE = re.compile("^[A-Z0-9]{5,}$")

class Source(Base):
  __tablename__ = "sources"
  name = Column(String, primary_key=True)
  events = relationship("Event", backref="source", lazy="dynamic")


class Event(Base):
  __tablename__ = "events"
  id = Column(Integer, Sequence('user_id_seq'), primary_key=True)
  type = Column(String)
  experiment = Column(String)
  src = Column(String, ForeignKey("sources.name"))
  addr = Column(String) # For mturk users this is the ip of the access
  time = Column(DateTime)
  payload = Column(String(16536))

  def payl(s):
    return json.loads(s.payload)


def open_sqlite_db(path):
    engine = create_engine("sqlite:///" + path, echo=False,
      connect_args={'check_same_thread':False});
    Session = sessionmaker(bind=engine)
    Base.metadata.create_all(engine);
    return Session;

def workers(s):
    return [x for x in s.query(Source).all() if workerIDhashRE.match(x.name)]

def _has_evt_type(src, evttype):
    return len([x for x in src.events if x.type == evttype]) > 0

def done_tutorial(src):
    return _has_evt_type(src, "TutorialDone")

def started_tutorial(src):
    return _has_evt_type(src, "TutorialStarted")

def finished_levels(src):
    return [ e.payl() for e in src.events if e.type == "FinishLevel"]

def started_levels(src):
    return [ e.payl() for e in src.events if e.type == "StartLevel"]

def found_invs(src):
    return [ e.payl() for e in src.events if e.type == "FoundInvariant"]

def experiments(src):
    return list(set([e.experiment for e in src.events]))
