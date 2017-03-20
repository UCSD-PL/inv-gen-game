import ast
import z3;
from threading import Condition
from time import sleep, time
from random import randint
from multiprocessing import Process, Queue as PQueue
from ..common.util import eprint
import Pyro4
import sys
import atexit
from atexit import register

class WrappedZ3Exception(BaseException):
  def __init__(s, value):
    s._value = value;

def wrapZ3Exc(f):
  def wrapped(*args, **kwargs):
    try:
      return f(*args, **kwargs);
    except z3.z3types.Z3Exception as e:
      raise WrappedZ3Exception(e.value);
  return wrapped

class Z3ServerInstance(object):
  def __init__(s):
    s._solver = z3.Solver();

  @Pyro4.expose
  @wrapZ3Exc
  def add(s, sPred):
    pred = z3.parse_smt2_string(sPred)
    s._solver.add(pred)
    return 0;

  @Pyro4.expose
  @wrapZ3Exc
  def check(s):
    return str(s._solver.check());

  @Pyro4.expose
  @wrapZ3Exc
  def model(s):
    m = s._solver.model()
    return { x.name(): m[x].as_long() for x in m }

  @Pyro4.expose
  @wrapZ3Exc
  def push(s):
    s._solver.push();
    return 0;

  @Pyro4.expose
  @wrapZ3Exc
  def pop(s):
    s._solver.pop();
    return 0;


def startAndWaitForZ3Instance():
  q = PQueue();
  def runDaemon(q):
    import os

    out = "z3_child.%d.out" % os.getpid()
    err = "z3_child.%d.err" % os.getpid()

    eprint("Redirecting child", os.getpid(), "streams to", out, err)

    sys.stdout.close();
    sys.stderr.close();

    sys.stdout = open(out, "w")
    sys.stderr = open(err, "w")

    daemon = Pyro4.Daemon();
    uri = daemon.register(Z3ServerInstance)
    sys.stderr.write( "Notify parent of my uri: " + str(uri) )
    sys.stderr.flush();
    q.put(uri)
    # Small window for racing
    daemon.requestLoop();

  p = Process(target=runDaemon, args=(q,))
  p.start();
  uri = q.get();
  return p, uri

class Unknown(Exception):
  def __init__(s, q):
    Exception.__init__(s, str(q) + " returned unknown.")
    s.query = q;

class Crashed(Exception): pass;

class Z3ProxySolver:
    def __init__(s, uri, proc):
      s._uri = uri;
      s._proc = proc;
      s._remote = Pyro4.Proxy(uri);
      s._timeout = None

    def add(s, p):
      dummy = z3.Solver();
      dummy.add(p);
      strP = dummy.to_smt2();
      strP = strP.replace("(check-sat)\n", "");
      s._remote.add(strP)
      return None;

    def push(s):
      s._remote.push();
      return None

    def pop(s):
      s._remote.pop();
      return None

    def check(s, timeout = None):
      old_timeout = s._timeout
      s._remote._pyroTimeout = timeout;
      try:
        r = s._remote.check()
      except Pyro4.errors.TimeoutError:
        print "Child ", s._proc.pid, "Timedout. Restarting."
        r = "unknown"
        s._restartRemote();
      except Exception,e:
        sys.stdout.write("Got exception: " + str(e) + "\n")
        ecode = s._proc.exitcode
        s._restartRemote();
          
        if (ecode == -11): # Retry Z3 segfaults
          r = "crashed"
        else:
          r = "unknown"
      finally:
        s._remote._pyroTimeout = old_timeout;

      if (r=="sat"):
        return z3.sat;
      elif (r =="unsat"):
        return z3.unsat;
      elif (r == "unknown"):
        raise Unknown("storing query NYI in proxy solver")
      elif (r == "crashed"):
        raise Crashed()
      else:
        raise Exception("bad reply to check: " + str(r));

    def model(s):
      return s._remote.model();

    def _restartRemote(s):
        # Kill Old Process
        s._proc.terminate();
        s._proc.join();
        # Restart
        s._proc, s._uri = startAndWaitForZ3Instance()
        s._remote = Pyro4.Proxy(s._uri);
        s.push();

z3ProcessPoolCond = Condition();
MAX_Z3_INSTANCES=100;
ports = set(range(8100, 8100 + MAX_Z3_INSTANCES))
z3ProcessPool = { }

def _cleanupChildProcesses():
  for proxy in z3ProcessPool:
    proxy._proc.terminate();
atexit.register(_cleanupChildProcesses)

def getSolver():
    try:
        z3ProcessPoolCond.acquire();
        # Repeatedly GC dead processes and see what free context we have
        # If we have none wait on the condition variable for request to
        # finish or processes to timeout and die.
        while True:
          free = [ (proxy, busy) for (proxy, busy) in z3ProcessPool.iteritems()
                      if (not busy) ]

          if (len(free) == 0 and len(ports) == 0):
            print "No free instances and no ports for new instances..."
            z3ProcessPoolCond.wait();
          else:
            break;

        # We either have a free z3 solver or a process died and freed
        # up a port for us to launch a new solver with.
        if (len(free) > 0):
          #print "Assigning existing z3 proxy"
          solver = free[randint(0, len(free)-1)][0]
        else:
          portN = ports.pop();
          #print "Creating new z3 proxy"
          p, uri = startAndWaitForZ3Instance()
          solver = Z3ProxySolver(uri, p)

        z3ProcessPool[solver] = (True, False);
        #print "z3ProcessPool has ", len(z3ProcessPool), "entries"
    finally:
        z3ProcessPoolCond.release();

    solver.push();
    return solver;

def releaseSolver(solver):
    try:
        z3ProcessPoolCond.acquire();
        solver.pop();
        z3ProcessPool[solver] = False
        z3ProcessPoolCond.notify();
    finally:
        z3ProcessPoolCond.release();

def Int(n): return z3.Int(n);
def Bool(b):  return z3.BoolVal(b);
def Or(*args):  return z3.Or(*args)
def And(*args): return z3.And(*args)
def Not(pred):  return z3.Not(pred)
def Implies(a,b): return z3.Implies(a,b)

z3Cache = { }
z3CacheStats = { }

def printZ3CacheStats():
  global z3CacheStats;
  for (func, (hit, miss)) in z3CacheStats.iteritems():
    total = hit + miss;
    hitP = 100.0*hit/total
    missP = 100.0*miss/total
    print func, "hit:", hit, "(", hitP, "%)", "miss:", miss, "(", missP, "%)"

register(printZ3CacheStats);

def memoize(keyF):
  def decorator(f):
    def decorated(*args, **kwargs):
      global z3Cache
      fname = f.func_code.co_name
      hit,miss = z3CacheStats.get(fname, (0,0))

      try:
        key = keyF(*args, **kwargs)
        if (key in z3Cache):
          z3CacheStats[fname] = (hit+1, miss)
          return z3Cache[key];
        else:
          z3CacheStats[fname] = (hit, miss+1)

        res = f(*args, **kwargs)
        z3Cache[keyF(*args, **kwargs)] = res;
        return res;
      except Unknown, e:
        assert keyF(*args, **kwargs) not in z3Cache
        raise e;
      except Crashed, e:
        assert keyF(*args, **kwargs) not in z3Cache
        raise e;
    return decorated
  return decorator

@memoize(lambda pred, timeout=None:  pred)
def counterex(pred, timeout=None):
    s = None
    try:
      s = getSolver()
      while True:
        try:
          s.add(Not(pred))
          res = s.check(timeout)
          m = None if res == z3.unsat else s.model()
        except Crashed:
          continue;
        break;

      return m;
    finally:
      if (s): releaseSolver(s);

@memoize(lambda pred, timeout=None:  pred)
def satisfiable(pred, timeout=None):
    s = None
    try:
      s = getSolver()
      s.add(pred);
      res = s.check(timeout)
      return res == z3.sat;
    finally:
      if (s): releaseSolver(s)

@memoize(lambda pred, timeout=None:  pred)
def unsatisfiable(pred, timeout=None):
    s = None
    try:
      s = getSolver()
      s.add(pred);
      res = s.check(timeout)
      return res == z3.unsat;
    finally:
      if (s): releaseSolver(s)

@memoize(lambda pred:  pred)
def model(pred):
    s = None
    try:
      s = getSolver();
      s.add(pred);
      assert s.check() == z3.sat
      m = s.model();
      return m;
    finally:
      if (s): releaseSolver(s);

@memoize(lambda pred:  pred)
def maybeModel(pred):
    s = None
    try:
      s = getSolver();
      s.add(pred);
      res = s.check();
      m = s.model() if res == z3.sat else None
      return m
    finally:
      if (s): releaseSolver(s);

def simplify(pred, *args, **kwargs):
    return z3.simplify(pred, *args, **kwargs)

@memoize(lambda inv1, inv2:  (inv1, inv2))
def implies(inv1, inv2):
    return unsatisfiable(And(inv1, Not(inv2)))

@memoize(lambda inv1, inv2:  (inv1, inv2))
def equivalent(inv1, inv2):
    return implies(inv1,inv2) and implies(inv2, inv1)

@memoize(lambda inv:  inv)
def tautology(inv):
    return unsatisfiable(Not(inv))

class AllIntTypeEnv:
    def __getitem__(s, i):  return Int

def expr_to_z3(expr, typeEnv):
    if isinstance(expr, ast.AstNumber):
        return expr.num
    elif isinstance(expr, ast.AstId):
        return typeEnv[expr.name](expr.name)
    elif isinstance(expr, ast.AstTrue):
        return Bool(True);
    elif isinstance(expr, ast.AstFalse):
        return Bool(False);
    elif isinstance(expr, ast.AstUnExpr):
        z3_inner = expr_to_z3(expr.expr, typeEnv)
        if expr.op == '-':
            return -z3_inner
        elif expr.op == '!':
            return Not(z3_inner)
        else:
            raise Exception("Unknown unary operator " + str(expr.op))
    elif isinstance(expr, ast.AstBinExpr):
        e1 = expr_to_z3(expr.lhs, typeEnv)
        e2 = expr_to_z3(expr.rhs, typeEnv)
        if expr.op == "<==>":
            return And(Implies(e1, e2), Implies(e2,e1))
        elif expr.op == "==>":
            return Implies(e1, e2)
        elif expr.op == "||":
            return Or(e1, e2)
        elif expr.op == "&&":
            return And(e1, e2)
        elif expr.op == "==":
            return e1 == e2
        elif expr.op == "!=":
            return e1 != e2
        elif expr.op == "<":
            return e1 < e2
        elif expr.op == ">":
            return e1 > e2
        elif expr.op == "<=":
            return e1 <= e2
        elif expr.op == ">=":
            return e1 >= e2
        elif expr.op == "+":
            return e1 + e2
        elif expr.op == "-":
            return e1 - e2
        elif expr.op == "*":
            return e1 * e2
        elif expr.op == "div":
            return e1 / e2
        elif expr.op == "mod":
            return e1 % e2
        else:
            raise Exception("Unknown binary operator " + str(expr.op))
    else:
        raise Exception("Unknown expression " + str(expr))

def stmt_to_z3(stmt, typeEnv):
    if (isinstance(stmt, ast.AstLabel)):
        stmt = stmt.stmt

    if (isinstance(stmt, ast.AstAssignment)):
        return (typeEnv[stmt.lhs](str(stmt.lhs)) == expr_to_z3(stmt.rhs, typeEnv))
    elif (isinstance(stmt, ast.AstAssert)):
        return (expr_to_z3(stmt.expr, typeEnv))
    elif (isinstance(stmt, ast.AstAssume)):
        return (expr_to_z3(stmt.expr, typeEnv))
    else:
        raise Exception("Can't convert " + str(stmt))

def isnum(s):
    try:
        x = int(s)
        return True
    except:
        return False

def ids(z3expr):
    if len(z3expr.children()) == 0:
        return [z3expr] if not isnum(str(z3expr)) else []
    else:
        tmp = { str(x): x for x in reduce(lambda x,y: x+y, map(ids, z3expr.children()), []) }
        return list(tmp.keys())

def z3_expr_to_boogie(expr):
    d = expr.decl();
    if (d.arity() == 0):
        #Literals and Identifiers
        if (isinstance(expr.sort(), z3.BoolSortRef)):
            if (z3.is_true(expr)):
                return ast.AstTrue()
            elif (z3.is_false(expr)):
                return ast.AstFalse()
            else:
                return ast.AstId(d.name())
        else:
            assert isinstance(expr.sort(), z3.ArithSortRef), "For now only handle bools and ints"
            if (z3.is_int_value(expr)):
                return ast.AstNumber(int(str(expr)))
            else:
                return ast.AstId(d.name())
    elif (d.arity() == 1):
        # Unary operators 
        arg = z3_expr_to_boogie(expr.children()[0])
        boogie_op = {
            '-': '-',
            'not': '!',
        }[d.name()]
        return ast.AstUnExpr(boogie_op, arg);
    elif (d.arity() == 2):
        # Binary operators
        boogie_op, assoc = {
            "+": ("+","left"),
            "-": ("-","left"),
            "*": ("*","left"),
            "div": ("div","left"),
            "mod": ("mod","none"),
            "=": ("==","none"),
            "distinct":("!=","none"),
            "<": ("<","none"),
            ">": (">","none"),
            "<=": ("<=","none"),
            ">=": (">=","none"),
            "and": ("&&","left"),
            "or": ("||","left"),
            "=>": ("==>", "none"),
            "Implies": ("==>", "none"),
        }[d.name()]

        c = expr.children();
        while (len(c) > 2):
            if (assoc == "none"):
                raise Exception("Error: Expression " + str(expr) + " has " +\
                    len(c) + " children: " + c + " but root operator " + \
                    d.name() + " is non-associative.")
            
            if (assoc == "left"):
                lhs = z3_expr_to_boogie(c[0]) if (not isinstance(c[0], ast.AstNode)) else c[0]
                rhs = z3_expr_to_boogie(c[1])
                c[0:2] = [ ast.AstBinExpr(lhs, boogie_op, rhs) ]
            else:
                raise Exception("NYI")

        lhs = z3_expr_to_boogie(c[0]) if (not isinstance(c[0], ast.AstNode)) else c[0]
        rhs = z3_expr_to_boogie(c[1])
        return ast.AstBinExpr(lhs, boogie_op, rhs)
    elif (d.name() == "if"):
        # TODO: Check types of branches are bool
        c = expr.children();
        cond = z3_expr_to_boogie(c[0])
        thenB = z3_expr_to_boogie(c[1]);
        elseB = z3_expr_to_boogie(c[2]);
        return ast.AstBinExpr(ast.AstBinExpr(cond, "==>", thenB),
                              "&&",
                              ast.AstBinExpr(ast.AstUnExpr("!", cond), "==>", elseB));
    else:
        raise Exception("Can't translate z3 expression " + str(expr) +
            " to boogie.") 

if (__name__ == "__main__"):
    a = z3_expr_to_boogie(Int('a') + Int("b"))
    print a
    a = z3_expr_to_boogie(Int('a') * 2)
    print a
    a = z3_expr_to_boogie(Or((Bool('x'), Bool('y'))))
    print a
    a = z3_expr_to_boogie(And(Or(Bool('x'), True), ((Int('a') - 1) >= Int('b'))))
    print a
