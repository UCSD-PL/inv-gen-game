import traceback
from itertools import chain, combinations
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
            raise
    return decorated

def powerset(s):
  for subS in chain.from_iterable(combinations(s, l) for l in range(len(s) + 1)):
    yield set(subS)

def average(vals):
    return sum(vals) / (1.0 * len(vals))

def split(pred, itr):
    yes,no = [], []
    for i in itr:
        if (pred(i)):
            yes.append(i);
        else:
            no.append(i);

    return (yes, no)

def nonempty(lst):
    return filter(lambda x: len(x) > 0, lst)
