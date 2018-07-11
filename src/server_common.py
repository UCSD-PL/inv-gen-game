from json import dumps
from pp import pp_mturkId
from colorama import Fore,Back,Style, init as colorama_init
from time import time
from sys import exc_info, stdout
from flask import request
import traceback
# Profiling import
from cProfile import Profile
from io import StringIO
from pstats import Stats

from typing import Dict, Any, Callable, TypeVar, cast
T=TypeVar("T")

colorama_init();

# Logging stuff
logF = None;
def openLog(fname: str) -> None:
    global logF;
    logF = open(fname, 'w');

def log(action: Dict[str, Any], *pps: Callable[..., str]) -> None:
    action['time'] = time()
    action['ip'] = request.remote_addr;
    if (logF):
        logF.write(dumps(action) + '\n')
        logF.flush()
    else:
        if (len(pps) == 0):
          print(dumps(action) + "\n");
        else:
          assert('kwargs' not in action or len(action['kwargs']) == 0);
          assert(len(pps) >= len(action['args']));
          ppArgs = [pps[ind](arg) for (ind, arg) in enumerate(action["args"])]
          # See if one of the ppArgs is a mturkId
          hitId, assignmentId, workerId = (None, None, None)
          mturkArgInd = None
          for (i, _) in enumerate(ppArgs):
            if (pps[i] == pp_mturkId):
              workerId, hitId, assignmentId = action["args"][i]
              mturkArgInd = i

          if (mturkArgInd is not None):
            ppArgs.pop(mturkArgInd)

          reset = Style.RESET_ALL
          red = Fore.RED
          green = Fore.GREEN

          prompt = "[" + green + str(action['ip']) + reset + \
              red + ":" + green + str(hitId) + reset + \
              red + ":" + green + str(assignmentId) + reset + \
              red + ":" + green + str(workerId) + reset + \
              '] ' + \
              Style.DIM + str(action['time']) + reset + ':'

          call = red + action['method'] + "(" + reset \
              + (red + "," + reset).join(map(str, ppArgs)) + \
               red + ")" + reset

          if (len(action['args']) + 1 == len(pps) and 'res' in action):
            call += "=" + pps[len(action['args'])](action['res']);

          print(prompt + call);
        stdout.flush();

def pp_exc(f: Callable) -> Callable:
    """ Wrap a function to catch, pretty print the exception and re-raise it.
    """
    def decorated(*args):
        try:
            return f(*args)
        except Exception:
            traceback.print_exception(*exc_info())
            raise
    return decorated

def log_d(*pps: Callable[..., str]) -> Callable[[T], T]:
    def decorator(f: T) -> T:
        def decorated(*pargs):
            try:
                res = f(*pargs)
                log({ "method": f.__name__, "args": pargs,
                      "res": res }, *pps)
                return res;
            except Exception:
                strTrace = ''.join(traceback.format_exception(*exc_info()))
                log({ "method": f.__name__, "args": pargs,
                      "exception": strTrace})
                raise
        return cast(T, decorated)
    return decorator

# Profiling stuff
def prof_d(f: T) -> T:
    def decorated(*pargs, **kwargs):
        try:
            pr = Profile()
            pr.enable()
            res = f(*pargs, **kwargs)
            pr.disable()
            return res;
        except Exception:
            raise
        finally:
            # Print results
            s = StringIO()
            ps = Stats(pr, stream=s).sort_stats('cumulative')
            ps.print_stats()
            print(s.getvalue())
    return cast(T, decorated)

