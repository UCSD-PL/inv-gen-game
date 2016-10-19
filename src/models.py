from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey, create_engine, DateTime, Sequence
from sqlalchemy.orm import relationship, sessionmaker
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
