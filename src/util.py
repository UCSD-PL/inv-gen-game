import traceback
from sys import exc_info

def unique(iterable, msg=""):
  l = list(iterable)
  assert len(l) == 1, msg
  return l[0]

def pp_exc(f):
    def decorated(*args, **kwargs):
        try:
            return f(*args, **kwargs)
        except Exception,e:
            traceback.print_exception(*exc_info())
            raise e
    return decorated
