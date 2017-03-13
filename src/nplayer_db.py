from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey, create_engine, DateTime, Sequence
from sqlalchemy.orm import relationship, sessionmaker
import json
import re

Base = declarative_base();

class Login(Base):
    __tablename__ = "login"
    playerId = Column('player_id', String, primary_key=True)
    password = Column('password', String)

class Scores(Base):
    __tablename__ = "scores"
    playerId = Column('player_id', String, primary_key=True)
    score = Column('score', Integer)
    numInvFound = Column('num_inv_found', Integer)

class Badges(Base):
    __tablename__ = "badges"
    playerId = Column('player_id', String, primary_key=True)
    badge = Column('badge', String)


def open_db(path):
    engine = create_engine("sqlite:///" + path, echo=False,
      connect_args={'check_same_thread':False});
    Session = sessionmaker(bind=engine)
    Base.metadata.create_all(engine);
    return Session


def addPlayerLogin(id, pwd, session):
    if checkPlayerId(id, session) == 0:
        player = Login(playerId=id, password=pwd)
        session.add(player)
        session.commit()
        return player
    else:
        return None


def checkPlayerId(id, session):
    players = [ p for p in session.query(Login).filter(Login.playerId == id).all() ]
    return players == 0


def checkPlayerLogin(id, pwd, session):
    players = [ p for p in session.query(Login).filter(Login.playerId == id, Login.password == pwd).all() ]
    return players == 1
