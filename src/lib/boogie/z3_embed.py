# pylint: disable=global-variable-not-assigned,no-self-argument
from typing import Union, Tuple, Dict, Callable, Optional, Any, List, cast, Type
import lib.boogie.ast as ast
import lib.boogie.bb as bb
from lib.boogie.interp import BoogieVal, OpaqueVal, Store
import z3

from threading import Condition, local
from time import time
from random import randint
from multiprocessing import Process, Queue as PQueue
from ..common.util import error
import Pyro4
from Pyro4.util import SerializerBase
import sys
import atexit
from signal import signal, SIGTERM, SIGINT
from functools import reduce
from copy import copy
from os import kill
from signal import SIGINT, SIGKILL

ctxHolder = local()

Z3ValFactory_T = Callable[[str], z3.ExprRef]
TypeEnv_T = Dict[str, Z3ValFactory_T]

def fi_deserialize(classname: str, d: Dict[Any, Any]) -> OpaqueVal:
    return OpaqueVal.from_dict(d)

def fi_serialize(obj: OpaqueVal) -> Dict[Any, Any]:
    d=OpaqueVal.to_dict(obj)
    assert "__class__" not in d
    d["__class__"] = "OpaqueVal"
    return d

SerializerBase.register_dict_to_class("OpaqueVal", fi_deserialize)
SerializerBase.register_class_to_dict(OpaqueVal, fi_serialize)

def type_to_z3sort(ast_typ: ast.AstType) -> z3.SortRef:
    if isinstance(ast_typ, ast.AstIntType):
        return IntSort()
    elif isinstance(ast_typ, ast.AstBoolType):
        return BoolSort()
    else:
        assert isinstance(ast_typ, ast.AstMapType)
        return z3.ArraySort(type_to_z3sort(ast_typ.domain), type_to_z3sort(ast_typ.range))

def type_to_z3(ast_typ: ast.AstType) -> Z3ValFactory_T:
    if isinstance(ast_typ, ast.AstIntType):
        return Int
    elif isinstance(ast_typ, ast.AstBoolType):
        return Bool
    else:
        assert isinstance(ast_typ, ast.AstMapType)
        def array_fac(name: str) -> z3.ArrayRef:
            return z3.Array(name, type_to_z3sort(ast_typ.domainT), type_to_z3sort(ast_typ.rangeT))
        return array_fac
def get_typeenv(f: bb.Function) -> TypeEnv_T:
    return dict((name, type_to_z3(ast_typ)) for (name, ast_typ) in list(f.parameters) + list(f.locals) + list(f.returns))

def z3val_to_boogie(v: Union[z3.ExprRef, z3.FuncInterp]) -> BoogieVal:
    if isinstance(v, z3.IntNumRef):
        return v.as_long()
    elif isinstance(v, z3.BoolRef):
        return bool(v)
    else:
        print ("Func {} -> OpaqueVal".format(v))
        return OpaqueVal()

def model_to_store(m: z3.ModelRef) -> Store:
    return { str(x): z3val_to_boogie(m[x]) for x in m}

def getCtx() -> z3.Context:
    global ctxHolder
    ctx = getattr(ctxHolder, "ctx", None)
    if (ctx == None):
        ctx = z3.Context()
        ctxHolder.ctx = ctx
    return ctx


class WrappedZ3Exception(BaseException):
    def __init__(s, value: Any) -> None:
        BaseException.__init__(s)
        s._value = value


def wrapZ3Exc(f: Callable) -> Callable:
    def wrapped(*args: Any, **kwargs: Any) -> Any:
        try:
            return f(*args, **kwargs)
        except z3.z3types.Z3Exception as e:
            raise WrappedZ3Exception(e.value)

    return wrapped


class Z3ServerInstance(object):
    def __init__(s) -> None:
        s._solver = z3.Solver(ctx=getCtx())

    @Pyro4.expose
    @wrapZ3Exc
    def add(s, sPred: str) -> int:
        pred = z3.parse_smt2_string(sPred, ctx=s._solver.ctx)
        s._solver.add(pred)
        return 0

    @Pyro4.expose
    @wrapZ3Exc
    def check(s, sComm: str) -> str:
        sys.stderr.write("check(" + sComm + "):" + s._solver.to_smt2() + "\n")
        return str(s._solver.check())

    @Pyro4.expose
    @wrapZ3Exc
    def model(s) -> Store:
        m = s._solver.model()
        print (m)
        return model_to_store(m)

    @Pyro4.expose
    @wrapZ3Exc
    def push(s) -> int:
        s._solver.push()
        return 0

    @Pyro4.expose
    @wrapZ3Exc
    def pop(s) -> int:
        s._solver.pop()
        return 0


def startAndWaitForZ3Instance() -> Tuple[Process, Pyro4.URI]:
    q = PQueue() # type: PQueue 

    def runDaemon(q: PQueue) -> None:
        import os

        out = "z3_child.%d.out" % os.getpid()
        err = "z3_child.%d.err" % os.getpid()

        error("Redirecting child", os.getpid(), "streams to", out, err)

        sys.stdout.close()
        sys.stderr.close()

        sys.stdout = open(out, "w")
        sys.stderr = open(err, "w")

        daemon = Pyro4.Daemon()
        uri = daemon.register(Z3ServerInstance)
        sys.stderr.write("Notify parent of my uri: " + str(uri) + "\n")
        sys.stderr.flush()
        q.put(uri)
        # Small window for racing
        daemon.requestLoop()

    p = Process(target=runDaemon, args=(q,))
    p.start()
    uri = q.get()
    return p, uri


class Unknown(Exception):
    def __init__(s, q: str) -> None:
        Exception.__init__(s, str(q) + " returned unknown.")
        s.query = q


class Crashed(Exception):
    pass


class Z3ProxySolver:
    def __init__(s, uri: Pyro4.URI, proc: Process) -> None:
        s._uri = uri
        s._proc = proc
        s._remote = Pyro4.Proxy(uri)
        s._timeout = None

    def add(s, p: z3.ExprRef) -> None:
        dummy = z3.Solver(ctx=getCtx())
        dummy.add(p)
        strP = dummy.to_smt2()
        strP = strP.replace("(check-sat)\n", "")
        s._remote.add(strP)
        return None
 
    def push(s) -> None:
        s._remote.push()
        return None

    def pop(s) -> None:
        s._remote.pop()
        return None

    def check(s, timeout: Optional[int] = None, comm: str ="") -> z3.CheckSatResult:
        old_timeout = s._timeout
        s._remote._pyroTimeout = timeout
        try:
            r = s._remote.check(comm)
        except Pyro4.errors.TimeoutError:
            sys.stderr.write("Child " + str(s._proc.pid) + \
                             "Timedout. Restarting.\n")
            r = "unknown"
            s._restartRemote()
        except Exception as e:
            sys.stdout.write("Got exception: " + str(e) + "\n")
            ecode = s._proc.exitcode
            s._restartRemote()

            if (ecode == -11):  # Retry Z3 segfaults
                r = "crashed"
            else:
                r = "unknown"
        finally:
            s._remote._pyroTimeout = old_timeout

        if (r == "sat"):
            return z3.sat
        elif (r == "unsat"):
            return z3.unsat
        elif (r == "unknown"):
            raise Unknown("storing query NYI in proxy solver")
        elif (r == "crashed"):
            raise Crashed()
        else:
            raise Exception("bad reply to check: " + str(r))

    def model(s) -> Store:
        return s._remote.model()

    def to_smt2(s, p: z3.ExprRef) -> str:
        dummy = z3.Solver(ctx=getCtx())
        dummy.add(p)
        strP = dummy.to_smt2()
        strP = strP.replace("(check-sat)\n", "")
        strP = strP.replace(
            "; benchmark generated from python API\n" + \
            "(set-info :status unknown)\n", "")
        return strP

    def _restartRemote(s) -> None:
        # Kill Old Process
        s._shutdownRemote()
        # Restart
        s._proc, s._uri = startAndWaitForZ3Instance()
        s._remote = Pyro4.Proxy(s._uri)
        s.push()

    def _shutdownRemote(s) -> None:
        if s._proc.exitcode is not None:
            return

        # First interrupt politely
        kill(s._proc.pid, SIGINT)
        s._proc.join(1)

        if s._proc.exitcode is not None:
            return

        # Next a bit more insistantly
        s._proc.terminate()
        s._proc.join(1)

        if s._proc.exitcode is not None:
            return

        # And now we ran out of patience
        kill(s._proc.pid, SIGKILL)
        s._proc.join()


z3ProcessPoolCond = Condition()
MAX_Z3_INSTANCES = 100
ports = set(range(8100, 8100 + MAX_Z3_INSTANCES))
z3ProcessPool = {} # type: Dict[Z3ProxySolver, bool]


def _cleanupChildProcesses() -> None:
    global z3ProcessPool
    for proxy in z3ProcessPool:
        proxy._shutdownRemote()
    z3ProcessPool = {}


atexit.register(_cleanupChildProcesses)

# atexit handlers don't get called on SIGTERM.
# cleanup child z3 processes explicitly on SIGTERM
def handler(signum: int, frame: Any) -> None:
  _cleanupChildProcesses()
  sys.exit(-1)

for signum in [SIGTERM, SIGINT]:
  signal(signum, handler)


def getSolver() -> Z3ProxySolver:
    try:
        z3ProcessPoolCond.acquire()
        # Repeatedly GC dead processes and see what free context we have
        # If we have none wait on the condition variable for request to
        # finish or processes to timeout and die.
        while True:
            free = [(proxy, busy) for (proxy, busy) in z3ProcessPool.items()
                    if (not busy)]

            if (len(free) == 0 and len(ports) == 0):
                print("No free instances and no ports for new instances...")
                z3ProcessPoolCond.wait()
            else:
                break

        # We either have a free z3 solver or a process died and freed
        # up a port for us to launch a new solver with.
        if (len(free) > 0):
            # print "Assigning existing z3 proxy"
            solver = free[randint(0, len(free) - 1)][0]
        else:
            # print "Creating new z3 proxy"
            p, uri = startAndWaitForZ3Instance()
            solver = Z3ProxySolver(uri, p)

        z3ProcessPool[solver] = True
        # print "z3ProcessPool has ", len(z3ProcessPool), "entries"
    finally:
        z3ProcessPoolCond.release()

    solver.push()
    return solver


def releaseSolver(solver: Optional[Z3ProxySolver]) -> None:
    if (solver == None):
        return
    try:
        z3ProcessPoolCond.acquire()
        solver.pop()
        z3ProcessPool[solver] = False
        z3ProcessPoolCond.notify()
    finally:
        z3ProcessPoolCond.release()


def IntSort() -> z3.ArithSortRef:
    return z3.IntSort(ctx=getCtx())

def Int(n: str) -> z3.ArithRef:
    return z3.Int(n, ctx=getCtx())


def BoolSort() -> z3.BoolSortRef:
    return z3.BoolSort(ctx=getCtx())

def Bool(n: str) -> z3.BoolRef:
    return z3.Bool(n, ctx=getCtx())

def Array(n: str, domain: z3.SortRef, range: z3.SortRef) -> z3.ArrayRef:
    return z3.Array(n, domain, range)

def Or(*args: Any) -> z3.ExprRef:
    #TODO: Make args ExprRef and cast it for the + below
    return z3.Or(*(args + (getCtx(),)))


def And(*args: Any) -> z3.ExprRef:
    #TODO: Make args ExprRef and cast it for the + below
    return z3.And(*(args + (getCtx(),)))


def Not(pred: z3.ExprRef) -> z3.ExprRef:
    return z3.Not(pred, ctx=getCtx())


def Implies(a: z3.ExprRef, b: z3.ExprRef) -> z3.ExprRef:
    return z3.Implies(a, b, ctx=getCtx())

def Function(name: str, *params: z3.SortRef) -> z3.FuncDeclRef:
    return z3.Function(name, *params)

def IntVal(v: int) -> z3.IntNumRef:
    return z3.IntVal(v, ctx=getCtx())


def BoolVal(v: bool) -> z3.BoolRef:
    return z3.BoolVal(v, ctx=getCtx())


def counterex(pred: z3.ExprRef, timeout: Optional[int]=None, comm: str ="") -> Store:
    s = None
    try:
        s = getSolver()
        while True:
            try:
                s.add(Not(pred))
                res = s.check(timeout, comm)
                m = None if res == z3.unsat else s.model()
            except Crashed:
                continue
            break

        return m
    finally:
        if (s):
            releaseSolver(s)


def satisfiable(pred: z3.ExprRef, timeout: Optional[int] = None) -> bool:
    s = None
    try:
        s = getSolver()
        s.add(pred)
        res = s.check(timeout)
        return res == z3.sat
    finally:
        releaseSolver(s)


def unsatisfiable(pred: z3.ExprRef, timeout: Optional[int] =None) -> bool:
    s = None
    try:
        s = getSolver()
        s.add(pred)
        res = s.check(timeout)
        return res == z3.unsat
    finally:
        releaseSolver(s)


def model(pred: z3.ExprRef) -> Store:
    s = None
    try:
        s = getSolver()
        s.add(pred)
        assert s.check() == z3.sat
        m = s.model()
        return m
    finally:
        releaseSolver(s)


def maybeModel(pred: z3.ExprRef) -> Optional[Store]:
    s = None
    try:
        s = getSolver()
        s.add(pred)
        res = s.check()
        m = s.model() if res == z3.sat else None
        return m
    finally:
        releaseSolver(s)


def simplify(pred: z3.AstRef, *args: Any, **kwargs: Any) -> z3.AstRef:
    # No need to explicitly specify ctx here since z3.simplify gets it from pred
    return z3.simplify(pred, *args, **kwargs)


def implies(inv1: z3.ExprRef, inv2: z3.ExprRef) -> bool:
    return unsatisfiable(And(inv1, Not(inv2)))


def equivalent(inv1: z3.ExprRef, inv2: z3.ExprRef) -> bool:
    return implies(inv1, inv2) and implies(inv2, inv1)


def tautology(inv: z3.ExprRef) -> bool:
    return unsatisfiable(Not(inv))


def _force_expr(a: Any) -> z3.ExprRef:
    assert isinstance(a, z3.ExprRef)
    return a

def expr_to_z3(expr: ast.AstExpr, typeEnv: TypeEnv_T) -> z3.ExprRef:
    if isinstance(expr, ast.AstNumber):
        return IntVal(expr.num)
    elif isinstance(expr, ast.AstId):
        return typeEnv[expr.name](expr.name)
    elif isinstance(expr, ast.AstTrue):
        return BoolVal(True)
    elif isinstance(expr, ast.AstFalse):
        return BoolVal(False)
    elif isinstance(expr, ast.AstFuncExpr):
        params = list(map((lambda p : expr_to_z3(p, typeEnv)), expr.ops))
        intsort = list(map((lambda p : z3.IntSort(ctx=getCtx())), expr.ops)) + [z3.IntSort(ctx=getCtx())]
        f = Function(expr.funcName.name, *intsort)
        return f(*params)
    elif isinstance(expr, ast.AstUnExpr):
        z3_inner = expr_to_z3(expr.expr, typeEnv)
        if expr.op == '-':
            assert isinstance(z3_inner, z3.ArithRef)
            return -z3_inner
        elif expr.op == '!':
            return Not(z3_inner)
        else:
            raise Exception("Unknown unary operator " + str(expr.op))
    elif isinstance(expr, ast.AstBinExpr):
        e1 = expr_to_z3(expr.lhs, typeEnv)
        e2 = expr_to_z3(expr.rhs, typeEnv)
        if expr.op == "<==>":
            return And(Implies(e1, e2), Implies(e2, e1))
        elif expr.op == "==>":
            return Implies(e1, e2)
        elif expr.op == "||":
            return Or(e1, e2)
        elif expr.op == "&&":
            return And(e1, e2)
        elif expr.op == "==":
            return _force_expr(e1 == e2)
        elif expr.op == "!=":
            return _force_expr(e1 != e2)
        elif expr.op == "<":
            assert isinstance(e1, z3.ArithRef) and isinstance(e2, z3.ArithRef)
            return e1 < e2
        elif expr.op == ">":
            assert isinstance(e1, z3.ArithRef) and isinstance(e2, z3.ArithRef)
            return e1 > e2
        elif expr.op == "<=":
            assert isinstance(e1, z3.ArithRef) and isinstance(e2, z3.ArithRef)
            return e1 <= e2
        elif expr.op == ">=":
            assert isinstance(e1, z3.ArithRef) and isinstance(e2, z3.ArithRef)
            return e1 >= e2
        elif expr.op == "+":
            assert isinstance(e1, z3.ArithRef) and isinstance(e2, z3.ArithRef)
            return e1 + e2
        elif expr.op == "-":
            assert isinstance(e1, z3.ArithRef) and isinstance(e2, z3.ArithRef)
            return e1 - e2
        elif expr.op == "*":
            assert isinstance(e1, z3.ArithRef) and isinstance(e2, z3.ArithRef)
            return e1 * e2
        elif expr.op == "div":
            assert isinstance(e1, z3.ArithRef) and isinstance(e2, z3.ArithRef)
            return e1 / e2
        elif expr.op == "mod":
            assert isinstance(e1, z3.ArithRef) and isinstance(e2, z3.ArithRef)
            return e1 % e2
        else:
            raise Exception("Unknown binary operator " + str(expr.op))
    elif isinstance(expr, ast.AstForallExpr):
        inner_tenv = copy(typeEnv)
        vs = []  # type: List[z3.ExprRef]

        for binding in expr.bindings:
            typ = binding.typ
            for name in binding.names:
                inner_tenv[name] = type_to_z3(typ)
                vs.append(inner_tenv[name](name))
        return z3.ForAll(vs, expr_to_z3(expr.expr, inner_tenv))
    elif isinstance(expr, ast.AstMapIndex):
        arr = expr_to_z3(expr.map, typeEnv)
        ind = expr_to_z3(expr.index, typeEnv)
        return z3.Select(arr, ind)
    elif isinstance(expr, ast.AstMapUpdate):
        arr = expr_to_z3(expr.map, typeEnv)
        ind = expr_to_z3(expr.index, typeEnv)
        new_val = expr_to_z3(expr.newVal, typeEnv)
        return z3.Update(arr, ind, new_val)
    else:
        raise Exception("Unknown expression " + str(expr))


def stmt_to_z3(stmt: ast.AstNode, typeEnv: TypeEnv_T) -> z3.ExprRef:
    if (isinstance(stmt, ast.AstLabel)):
        stmt = stmt.stmt

    if (isinstance(stmt, ast.AstAssignment)):
        lvalue = typeEnv[stmt.lhs](str(stmt.lhs))
        rhs = expr_to_z3(stmt.rhs, typeEnv)
        return _force_bool(lvalue == rhs)
    elif (isinstance(stmt, ast.AstAssert)):
        return (expr_to_z3(stmt.expr, typeEnv))
    elif (isinstance(stmt, ast.AstAssume)):
        return (expr_to_z3(stmt.expr, typeEnv))
    else:
        raise Exception("Can't convert " + str(stmt))


def isnum(s: Any) -> bool:
    try:
        _ = int(s)
        return True
    except ValueError:
        return False


def ids(z3expr: z3.AstRef) -> List[str]:
    if len(z3expr.children()) == 0:
        return [str(z3expr)] if not isnum(str(z3expr)) else []
    else:
        base = [] # type: List[str]
        childIds = reduce(lambda x, y: x + y, list(map(ids, z3expr.children())), base)
        tmp = {str(x): x for x in childIds}
        return list(tmp.keys())


def z3_expr_to_boogie(expr: z3.ExprRef) -> ast.AstExpr:
    d = expr.decl()
    if (d.arity() == 0):
        # Literals and Identifiers
        if (isinstance(expr, z3.BoolRef)):
            if (z3.is_true(expr)):  # No need for explicit ctx
                return ast.AstTrue()
            elif (z3.is_false(expr)):  # No need for explicit ctx
                return ast.AstFalse()
            else:
                return ast.AstId(d.name())
        else:
            assert isinstance(expr.sort(), z3.ArithSortRef), \
                "For now only handle bools and ints"
            if (z3.is_int_value(expr)):  # No need for explicit ctx
                return ast.AstNumber(int(str(expr)))
            else:
                return ast.AstId(d.name())
    elif (d.arity() == 1):
        # Unary operators
        arg = z3_expr_to_boogie(cast(z3.ExprRef, expr.children()[0]))
        boogie_op = {
            '-': '-',
            'not': '!',
        }[d.name()]
        return ast.AstUnExpr(boogie_op, arg)
    elif (d.name() == "if" and d.arity() == 2):
        c = cast(List[z3.ExprRef], expr.children())
        cond = z3_expr_to_boogie(c[0])
        thenB = z3_expr_to_boogie(c[1])
        return ast.AstBinExpr(cond, "==>", thenB)
    elif (d.arity() == 2):
        # Binary operators
        try:
            boogie_op, assoc = {
                "+": ("+", "left"),
                "-": ("-", "left"),
                "*": ("*", "left"),
                "div": ("div", "left"),
                "mod": ("mod", "none"),
                "=": ("==", "none"),
                "distinct": ("!=", "none"),
                "<": ("<", "none"),
                ">": (">", "none"),
                "<=": ("<=", "none"),
                ">=": (">=", "none"),
                "and": ("&&", "left"),
                "or": ("||", "left"),
                "=>": ("==>", "none"),
                "Implies": ("==>", "none"),
            }[d.name()]
        except:
            boogie_op, assoc = d.name(), "func"
        c = cast(List[z3.ExprRef], expr.children())
        if assoc == "func":
            try:
                pars = list(map(z3_expr_to_boogie, c))
                func = ast.AstId(boogie_op)
                fun = ast.AstFuncExpr(func, *pars)
            except Exception as ex:
                error(str(ex))
            return fun
        elif (assoc == "left"):
            return reduce(
                    lambda acc, x:    ast.AstBinExpr(acc, boogie_op, z3_expr_to_boogie(x)),
                    c[1:],
                    z3_expr_to_boogie(c[0]))
        elif (assoc == "none" or assoc == "right"):
            assert len(c) == 2, "NYI otherwise"
            lhs = z3_expr_to_boogie(c[0])
            rhs = z3_expr_to_boogie(c[1])
            return ast.AstBinExpr(lhs, boogie_op, rhs)
        else:
            raise Exception("NYI")
    elif (d.name() == "if"):
        c = cast(List[z3.ExprRef], expr.children())
        cond = z3_expr_to_boogie(c[0])
        thenB = z3_expr_to_boogie(c[1])
        elseB = z3_expr_to_boogie(c[2])
        return ast.AstBinExpr(
            ast.AstBinExpr(cond, "==>", thenB),
            "&&",
            ast.AstBinExpr(ast.AstUnExpr("!", cond), "==>", elseB))
    else:
        raise Exception("Can't translate z3 expression " + str(expr) +
                        " to boogie.")


def to_smt2(p: z3.ExprRef) -> str:
    s = getSolver()
    res = s.to_smt2(p)
    releaseSolver(s)
    return res
