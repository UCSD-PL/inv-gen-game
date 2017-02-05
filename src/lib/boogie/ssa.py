from ast import *;
from copy import copy, deepcopy;

class SSAEnv:
    def __init__(s, parent = None, prefix = "."):
        s._cnt = {}
        parent_pfix = parent._prefix if parent else ""
        s._prefix = parent_pfix + prefix
        s._parent = deepcopy(parent)

    def _lookup_cnt(s, v):
        if v in s._cnt:
            return s._cnt[v]
        else:
            if (s._parent):
                return s._parent._lookup_cnt(v)
            else:
                return 0 

    def lookup(s, v):
        if v in s._cnt:
            return str(v) + "_ssa_" + s._prefix + str(s._cnt[v])
        else:
            if (s._parent):
                return s._parent.lookup(v)
            else:
                return v

    def contains(s, v):
        return v in s._cnt

    def update(s, v):
        s._cnt[v] = s._lookup_cnt(v) + 1

    def remove(s, v):
        del s._cnt[v]

    def changed(s):
        return s._cnt.keys()

    def replm(s):
        replm = copy(s._parent.replm()) if (s._parent) else {}
        for k in s._cnt:
            replm[AstId(k)] = AstId(s.lookup(k))
        return replm

def is_ssa_str(s):
    # TODO The _split_ string must be kept in sync with boogie_paths's ssa code.
    return "_ssa_" in s or s.startswith("_split_")

def unssa_str(s):
    return s[:s.rfind("_ssa_")]
