from models import Source, Event
from json import loads,dumps
from datetime import datetime
from js import esprimaToBoogie

def playersWhoStartedLevel(lvlset, lvl, session):
  return set([ e.source.name for e in session.query(Event).all()
                             if (e.type == "StartLevel" and
                                 e.payl()["lvlset"] == lvlset and
                                 e.payl()["lvlid"] == lvl) ])

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


def addEvent(sourceName, typ, time, ename,  addr, data, session, mturkId):
  src = getOrAddSource(sourceName, session);

  payl = { "workerId": mturkId[0],
           "hitId": mturkId[1],
           "assignmentId": mturkId[2] }

  if (typ == "TutorialStart" or typ == "ReplayTutorialAll"):
    pass
  elif (typ == "TutorialDone"):
    pass
  elif (typ == "StartLevel" or
        typ == "FinishLevel" or
        typ == "SkipToNextLevel"):
    payl["lvlset"] = data[0]
    payl["lvlid"] = data[1]
    if typ == "FinishLevel":
      payl["verified"] = data[2]
      invs = zip(data[3], [ str(esprimaToBoogie(x, {})) for x in data[4] ])
      payl["all_found"] = invs;
  elif (typ == "FoundInvariant" or typ == "TriedInvariant"):
    payl["lvlset"] = data[0]
    payl["lvlid"] = data[1]
    payl["raw"] = data[2]
    payl["canonical"] = str(esprimaToBoogie(data[3], { }))
  elif (typ == "PowerupsActivated"):
    payl["lvlset"] = data[0]
    payl["lvlid"] = data[1]
    payl["raw"] = str(esprimaToBoogie(data[2], { }))
    payl["powerups"] = data[3]
  elif (typ == "GameDone"):
    payl["numLvlsPassed"] = data[0]
  elif (typ == "VerifyAttempt"):
    for k in data:
      payl[k] = data[k];
  elif (typ == "GenNext.Solved" or typ == "GenNext.NoNewRows"):
    payl = data
  else:
    print "Unknown event type: ", typ

  e = Event(type=typ,\
            source=src,\
            addr=addr,\
            experiment=ename,\
            time=datetime.fromtimestamp(time),\
            payload=dumps(payl))

  session.add(e)
  session.commit();

def levelSolved(session, lvlset, lvlid, workerId=None):
  verifys = session.query(Event).filter(Event.type == "VerifyAttempt").all()
  verifyPayls = [ x.payl() for x in verifys ]
  solved_events = [ x for x in verifyPayls
                      if (x["lvlset"] == lvlset and
                          x["lvlid"] == lvlid and
                          len(x["post_ctrex"]) == 0 and
                          (workerId is None or x["workerId"] == workerId)) ]
  # We can't just look for a successfull "FinishEvent", since sometimes the
  # solver takes a while, and finishes successfully only after the user has
  # gotten impatient and clicked next. So look for At least 1 successful
  # VerifyAttempt
  return len(solved_events) > 0

def levelFinishedBy(session, lvlset, lvlid, userId):
  finishLevels = session.query(Event)\
                    .filter(Event.type == "FinishLevel")\
                    .filter(Event.src == userId).all()
  finishLevelPayls = [ x.payl() for x in finishLevels ]
  finishLevelPayls = [ x for x in finishLevelPayls\
                         if x["lvlset"] == lvlset and x["lvlid"] == lvlid]
  return len(finishLevelPayls) > 0
