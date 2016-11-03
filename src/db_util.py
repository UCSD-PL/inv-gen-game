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
  elif (type == "StartLevel" or type == "FinishLevel"):
    payl = { "lvlset" : data[0], "lvlid" : data[1] }
    if type == "FinishLevel":
      payl["verified"] = data[2]
      invs = zip(data[3], [ str(esprimaToBoogie(x, {})) for x in data[4] ])
      payl["all_found"] = invs;
  elif (type == "FoundInvariant" or type == "TriedInvariant"):
    payl = { "lvlset" : data[0], "lvlid" : data[1],
              "raw": data[2], "canonical": str(esprimaToBoogie(data[3], { }))}
  elif (type == "GameDone"):
    payl = { "numLvlsPassed" : data[0] }
  else:
    print "Unknown event: ", e
    payl = { }

  e = Event(type=type, source=src, addr=addr, experiment=ename, time=datetime.fromtimestamp(time), payload=dumps(payl))
 
  session.add(e)
  session.commit();
