from flask import Flask
from flask_jsonrpc import JSONRPC as rpc
from os.path import *
from os import listdir
from json import load
from z3 import *
from js import invJSToZ3, addAllIntEnv, esprimaToZ3
import traceback

MYDIR=dirname(abspath(realpath(__file__)))
z3s = Solver()

def readTrace(fname):
    rows = []
    first = True
    for l in open(fname):
        l = l.strip();
        if (l == ''):   continue
        row = {}
        for (n,v) in [x.split('=') for x in l.split(' ')]:
            row[n] = v

        if (first):
          vs = [x.split('=')[0] for x in l.split(' ')]
          first = False;
        rows.append(row)

    hint = None
    goal = None
    try:
        goal = load(open(fname[:-4] + '.goal'))
        hint = open(fname[:-4] + '.hint').read()
    except: pass

    return { 'variables': vs,
             'data': [[ row.get(n, None) for n in vs  ]  for row in rows ],
             'hint': hint,
             'goal' : goal
    }

def loadTraces(dirN):
    return { name[:-4] : readTrace(dirN + '/' + name) for name in listdir(dirN)
                if name.endswith('.out') }

introTraces = loadTraces(MYDIR + '/../intro-benchmarks')
testTraces = loadTraces(MYDIR + '/../test-benchmarks')

traces = {
    "intro-benchmarks": introTraces,
    "test-benchmarks": testTraces,
    "old-dilig-traces": {
      '15-c': {
          'variables': ['n', 'k', 'j'],
          'data': [
              [7, 9, 0],
              [7, 8, 1],
              [7, 7, 2],
              [7, 6, 3],
              [7, 5, 4],
              [7, 4, 5],
              [7, 3, 6],
              [7, 2, 7]
          ]
      },

      '19-c': {
          'variables': ['n', 'm', 'x', 'y'],
          'data': [
              [7, 3, 0, 3],
              [7, 3, 1, 3],
              [7, 3, 2, 3],
              [7, 3, 3, 3],
              [7, 3, 4, 4],
              [7, 3, 5, 5],
              [7, 3, 6, 6],
          ]
      },

      '25-c outer loop': {
          'variables': ['x', 'y', 'i', 'j'],
          'data': [
              [0, 0, 0, 0],
              [1, 1, 4, 0],
              [2, 2, 8, 0],
              [3, 3, 12, 0],
          ]
      },

      '25-c inner loop': {
          'variables': ['x', 'y', 'i', 'j'],
          'data': [
              [0, 0, 0, 0],
              [0, 0, 1, 0],
              [0, 0, 2, 0],
              [0, 0, 3, 0],
              [1, 1, 4, 0],
              [1, 1, 5, 0],
              [1, 1, 6, 0],
              [1, 1, 7, 0],
              [2, 2, 8, 0],
              [2, 2, 9, 0],
              [2, 2, 10, 0],
              [2, 2, 11, 0],
              [3, 3, 12, 0],
              [3, 3, 13, 0],
              [3, 3, 14, 0],
              [3, 3, 15, 0],
          ]
      },
  }
}

class Server(Flask):
    def get_send_file_max_age(self, name):
        if (name in [ 'jquery-1.12.0.min.js', 'jquery-migrate-1.2.1.min.js', 'jquery.jsonrpcclient.js']):
            return 100000

        return 0

app = Server(__name__, static_folder='static/', static_url_path='')
api = rpc(app, '/api')

@api.method("App.listData")
def listData(levelSet):
    res = traces[levelSet].keys();
    res.sort()
    return res

@api.method("App.getData")
def getData(levelSet, traceId):
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + levelSet)

    if (traceId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + traceId + " in levels " + levelSet)

    return traces[levelSet][traceId]

def implies(inv1, inv2):
    print "Are implies ", inv1, inv2
    s = Solver();
    s.add(inv1)
    s.add(Not(inv2))
    return unsat == s.check();

def equivalent(inv1, inv2):
    print "Are equivalent: ", inv1, inv2
    s = Solver();
    s.push();
    s.add(inv1)
    s.add(Not(inv2))
    impl = s.check();
    s.pop();

    if (impl != unsat):
      return False;

    s.push();
    s.add(Not(inv1))
    s.add(inv2)
    impl = s.check();
    s.pop();

    if (impl != unsat):
      return False;

    return True

def tautology(inv):
    s = Solver();
    s.add(Not(inv))
    return (unsat == s.check())

@api.method("App.equivalentPairs")
def equivalentPairs(invL1, invL2):
    try:
      z3InvL1 = list(enumerate([esprimaToZ3(x, {}) for x in invL1]))
      z3InvL2 = list(enumerate([esprimaToZ3(x, {}) for x in invL2]))

      res = [(x,y) for x in z3InvL1 for y in z3InvL2 if equivalent(x[1], y[1])]
      res = [(x[0], y[0]) for x,y in res]
      return res
    except:
      traceback.print_exc();
      traceback.print_tb(e);
      raise Exception(":(")

@api.method("App.impliedPairs")
def impliedPairs(invL1, invL2):
    try:
      z3InvL1 = list(enumerate([esprimaToZ3(x, {}) for x in invL1]))
      z3InvL2 = list(enumerate([esprimaToZ3(x, {}) for x in invL2]))

      res = [(x,y) for x in z3InvL1 for y in z3InvL2 if implies(x[1], y[1])]
      res = [(x[0], y[0]) for x,y in res]
      print res
      return res
    except:
      traceback.print_exc();
      traceback.print_tb(e);
      raise Exception(":(")

@api.method("App.isTautology")
def isTautology(inv):
    return (tautology(esprimaToZ3(inv, {})))

if __name__ == "__main__":
    app.run(host='0.0.0.0')
