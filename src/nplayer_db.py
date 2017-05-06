from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey, create_engine, DateTime, Sequence, func, desc
from sqlalchemy.orm import relationship, sessionmaker
import json
import re

Base = declarative_base()


class Login(Base):
    __tablename__ = "login"
    playerId = Column('player_id', String, primary_key=True)
    password = Column('password', String)

    def toJSON(self):
        json.dumps({"playerId": self.playerId})


class Scores(Base):
    __tablename__ = "scores"
    rowId = Column('id', Integer, primary_key=True, autoincrement=True)
    playerId = Column('player_id', String)
    gameId = Column('game_id', String)
    score = Column('score', Integer)


class Feedback(Base):
    __tablename__ = "feedback"
    rowId = Column('id', Integer, primary_key=True, autoincrement=True)
    playerId = Column('player_id', String)
    fun = Column('fun', Integer)
    challenging = Column('challenging', Integer)
    prog_experience = Column('prog_experience', Integer)
    math_experience = Column('math_experience', Integer)
    comments = Column('comments', String)


def open_db(path):
    engine = create_engine("sqlite:///" + path, echo=False,
      connect_args={'check_same_thread':False})
    Session = sessionmaker(bind=engine)
    Base.metadata.create_all(engine)
    return Session


def clearLogins(session):
    try:
        session.query(Login).delete()
        session.commit()
    except:
        session.rollback()


def addPlayerLogin(id, pwd, session):
    if checkPlayerId(id, session):
        player = Login(playerId=id, password=pwd)
        session.add(player)
        session.commit()
    else:
        session.rollback()
        raise Exception("Could not add " + id)


def checkPlayerId(id, session):
    players = len([ p for p in session.query(Login).filter(Login.playerId == id).all() ])
    return players == 0


def checkPlayerLogin(id, pwd, session):
    players = len([ p for p in session.query(Login).filter(Login.playerId == id, Login.password == pwd).all() ])
    return players == 1


def newPlayerScore(id, gameId, session):
    scoreRow = Scores(playerId=id, gameId=gameId, score=0)
    session.add(scoreRow)
    session.commit()


def updatePlayerScore(id, gameId, score, session):
    session.query(Scores).filter(Scores.playerId == id, Scores.gameId == gameId).update({"score": score})
    session.commit()


def getPlayerTotalScore(id, session):
    total = sum([ row.score for row in session.query(Scores).filter(Scores.playerId == id).all() ])
    return total


def getAllPlayerScores(session):
    scores = session.query(Scores.playerId, func.sum(Scores.score).label('total')).group_by(Scores.playerId).order_by(desc('total')).all()
    return scores


def addFeedback(id, fun, challenge, prog, math, comments, session):
    feedback = Feedback(playerId=id, fun=fun, challenging=challenge, prog_experience=prog, math_experience=math, comments=comments)
    session.add(feedback)
    session.commit()


def getFeedback(session):
    feedback = session.query(Feedback)
    return feedback