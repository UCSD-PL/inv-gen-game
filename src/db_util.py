from models import Source, Event
from json import loads,dumps
from datetime import datetime
from js import esprimaToBoogie

def playersWhoStartedLevel(lvlset, lvl, session):
  return set([ e.source.name for e in session.query(Event).all() if e.type == "StartLevel" and e.payl()["lvlset"] == lvlset and e.payl()["lvlid"] == lvl ])

def enteredInvsForLevel(lvlset, lvl, session):
  invM = { p["canonical"]: p["raw"] for p in
            [ e.payl() for e in session.query(Event).all()
              if e.type == "FoundInvariant"] 
            if p["lvlset"] == lvlset and p["lvlid"] == lvl }

  return set(invM.iteritems())

def getOrAddSource(name, session):
  srcs = session.query(Source).filter(Source.name == name).all()
  if (len(srcs) != 0):
    assert len(srcs) == 1
    return srcs[0]

  s = Source(name = name)
  session.add(s)
  session.commit();
  return s


def addEvent(sourceName, type, time, ename,  addr, data, session):
  src = getOrAddSource(sourceName, session);

  if (type == "TutorialStart" or type == "ReplayTutorialAll"):
    payl = { }
  elif (type == "TutorialDone"):
    payl = { }
  elif (type == "StartLevel" or type == "FinishLevel" or type == "SkipToNextLevel"):
    payl = { "lvlset" : data[0], "lvlid" : data[1] }
    if type == "FinishLevel":
      payl["verified"] = data[2]
      invs = zip(data[3], [ str(esprimaToBoogie(x, {})) for x in data[4] ])
      payl["all_found"] = invs;
  elif (type == "FoundInvariant" or type == "TriedInvariant"):
    payl = { "lvlset" : data[0], "lvlid" : data[1],
              "raw": data[2], "canonical": str(esprimaToBoogie(data[3], { }))}
  elif (type == "PowerupsActivated"):
    payl = { "lvlset" : data[0], "lvlid" : data[1],
              "raw": str(esprimaToBoogie(data[2], { })), "powerups": data[3] }
  elif (type == "GameDone"):
    payl = { "numLvlsPassed" : data[0] }
  elif (type == "VerifyAttempt"):
    payl = data;
  else:
    print "Unknown event: ", e
    payl = { }

  e = Event(type=type, source=src, addr=addr, experiment=ename, time=datetime.fromtimestamp(time), payload=dumps(payl))
 
  session.add(e)
  session.commit();

def levelSolved(session, lvlset, lvlid):
  verifys = [ x.payl() for x in session.query(Event).filter(Event.type == "VerifyAttempt").all() ]
  solved_events = [ x for x in verifys if \
      x["lvlset"] == lvlset and x["lvlid"] == lvlid and len(x["post_ctrex"]) == 0 ]
  # We can't just look for a successfull "FinishEvent", since sometimes the solver takes a while,
  # and finishes successfully only after the user has gotten impatient and clicked next. So look for
  # At least 1 successful VerifyAttempt
  return len(solved_events) > 0

def levelFinishedBy(session, lvlset, lvlid, userId):
  fls = [ x.payl() for x in session.query(Event).filter(Event.type == "FinishLevel").filter(Event.src == userId).all() ]
  fls = [ x for x in fls if x["lvlset"] == lvlset and x["lvlid"] == lvlid]
  return len(fls) > 0
