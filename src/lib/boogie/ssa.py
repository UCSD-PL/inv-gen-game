#pylint: disable=no-self-argument
from lib.boogie.ast import AstId, AstNode, ReplMap_T
from copy import copy, deepcopy
from frozendict import frozendict
from typing import Optional, Dict, List, TYPE_CHECKING
from lib.boogie.z3_embed import TypeEnv_T, Z3ValFactory_T
from lib.boogie.interp import Store

class SSAEnv:
    def __init__(s, parent : Optional["SSAEnv"] = None, prefix: str = ".") -> None:
        s._cnt = {} #type: Dict[str, int]
        parent_pfix = parent._prefix if parent else ""
        s._prefix = parent_pfix + prefix #type: str
        s._parent = deepcopy(parent) #type: Optional[SSAEnv]

    def _lookup_cnt(s, v: str) -> int:
        if v in s._cnt:
            return s._cnt[v]
        else:
            if (s._parent):
                return s._parent._lookup_cnt(v)
            else:
                return 0

    def lookup(s, v: str) -> str:
        if v in s._cnt:
            return str(v) + "_ssa_" + s._prefix + str(s._cnt[v])
        else:
            if (s._parent):
                return s._parent.lookup(v)
            else:
                return v

    def contains(s, v: str) -> bool:
        return v in s._cnt

    def update(s, v: str) -> None:
        s._cnt[v] = s._lookup_cnt(v) + 1

    def remove(s, v: str) -> None:
        del s._cnt[v]

    def changed(s) -> List[str]:
        return list(s._cnt.keys())

    def replm(s) -> ReplMap_T:
        replm = copy(s._parent.replm()) if (s._parent) else {}
        for k in s._cnt:
            replm[AstId(k)] = AstId(s.lookup(k))
        return replm

def is_ssa_str(s: str) -> bool:
    # TODO The _split_ string must be kept in sync with boogie_paths's ssa code.
    return "_ssa_" in s or s.startswith("_split_")

def unssa_str(s: str) -> str:
    return s[:s.rfind("_ssa_")]

def unssa_z3_model(m: Store, repl_m: ReplMap_T) -> Store:
    updated = list(map(str, iter(repl_m.keys())))
    original = [ x for x in m.keys() if not is_ssa_str(x) and x not in updated ]
    res = { (unssa_str(x) if is_ssa_str(x) else x) : m.get(x, None)
                for x in original + list(map(str, iter(repl_m.values())))
          }
    return frozendict(res)

def get_ssa_tenv(tenv: TypeEnv_T) -> TypeEnv_T:
    class SSATEnv(TypeEnv_T):
        def __init__(self, inner: TypeEnv_T) -> None:
            self._inner_env = inner
        def __getitem__(self, k: str) -> Z3ValFactory_T:
            if is_ssa_str(k):
                k = unssa_str(k)
            return self._inner_env[k]

        def __setitem__(self, k: str, typ: Z3ValFactory_T) -> None:
            self._inner_env[k] = typ

        def __copy__(self) -> "SSATEnv":
            new = SSATEnv({})
            new._inner_env.update(self._inner_env)
            return new

        def __str__(self) -> str:
            return str(self._inner_env)
    return SSATEnv(tenv)