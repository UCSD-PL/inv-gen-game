from copy import copy
from lib.boogie.bb import bbEntry, get_bbs, bbExit, BBs_T, Label_T
from lib.boogie.ast import AstAssert, AstAssume, AstHavoc, \
        AstAssignment, stmt_read, stmt_changed, AstBinExpr, expr_read,\
        AstStmt, AstExpr
from functools import reduce
from typing import TypeVar, Callable, Dict, Iterable, Set, Optional

T=TypeVar("T")
Transformer_T = Dict[type, Callable[[AstStmt, Set[T]], Set[T]]]
Union_T = Callable[[Iterable[Set[T]]], Set[T]]
DFlowState_T = Dict[Label_T, Set[T]]

#TODO: Need to introduce a separation between top and bottom
def forwarddflow(bbs: BBs_T, transformer_m: Transformer_T, union_f: Union_T, initial_vals: Set[T], start_val: Set[T]) -> DFlowState_T:
    state = { bb: copy(initial_vals) for bb in bbs.keys() } # type: DFlowState_T
    state[bbEntry(bbs)] = start_val
    wlist = [ bbEntry(bbs) ]
    while len(wlist) > 0:
        curBB = wlist.pop()

        if (len(bbs[curBB].predecessors) > 0):
          inS = union_f([state[bb] for bb in bbs[curBB].predecessors])
        else:
          inS = start_val

        for stmt in bbs[curBB].stmts:
            ninS = transformer_m[stmt.__class__](stmt, inS)
            inS = ninS
        outS = inS
        if state[curBB] != outS:
            wlist.extend(bbs[curBB].successors)
            state[curBB] = outS
    return state

# TODO: How does this work without one node starting with less than maximal?
# What is Top and Bottom in my current use caes (livevars)?
def backdflow(bbs: BBs_T, transformer_m: Transformer_T, union_f: Union_T, initial_vals: Set[T]) -> DFlowState_T:
    state = { bb: copy(initial_vals) for bb in bbs.keys() } # type: DFlowState_T
    wlist = [ bbExit(bbs) ]
    while len(wlist) > 0:
        curBB = wlist.pop()
        inS = union_f([state[bb] for bb in bbs[curBB].successors])
        for stmt in reversed(bbs[curBB].stmts):
            inS = transformer_m[stmt.__class__](stmt, inS)
        outS = inS
        if state[curBB] != outS:
            wlist.extend(bbs[curBB].predecessors)
            state[curBB] = outS
    return state

def livevars(bbs: BBs_T) -> DFlowState_T[str]:
    transformer_m = {
        AstAssert:  lambda stmt, inS: inS.union(stmt_read(stmt)),
        AstAssume:  lambda stmt, inS: inS.union(stmt_read(stmt)),
        AstHavoc:  lambda stmt, inS: inS - stmt_changed(stmt),
        AstAssignment:  lambda stmt, inS:   \
            (inS - stmt_changed(stmt)).union(stmt_read(stmt))
    }
    def union_f(sets: Iterable[Set[str]]) -> Set[str]:
        sets = [x for x in sets if x != None]
        return reduce(lambda x,y:   x.union(y), sets, set([]))
    return backdflow(bbs, transformer_m, union_f, None)

def propagate_sp(bbs: BBs_T) -> DFlowState_T[AstExpr]:
    # Propagate sps involving variable not changed through the loop
    def untouched(preds: Set[AstExpr], clobbered_vars: Set[str]) -> Set[AstExpr]:
      return set([x for x in preds \
                    if len(clobbered_vars.intersection(expr_read(x))) == 0])

    def assignment_preds(stmt: AstAssignment) -> Set[AstExpr]:
      return set([AstBinExpr(stmt.lhs, "==", stmt.rhs)]) \
        if str(stmt.lhs) not in expr_read(stmt.rhs) else set()

    transformer_m = {
        AstAssert:  lambda stmt, inS: inS,
        AstAssume:  lambda stmt, inS: inS.union(set([stmt.expr])),
        AstHavoc:  lambda stmt, inS: untouched(inS, stmt_changed(stmt)),
        AstAssignment:  lambda stmt, inS:
            untouched(inS, set([str(stmt.lhs)])).union(assignment_preds(stmt))
    }

    # TODO: Types seem weird here. Not clear why I need None. Needs TLC
    def union_f(sets: Iterable[Set[AstExpr]]) -> Optional[Set[AstExpr]]:
        something_sets = [x for x in sets if x != None]
        if (len(something_sets)) == 0:
            return None
        base = something_sets[0]
        rest = something_sets[1:]
        return reduce(lambda x,y:   x.intersection(y), rest, base)

    return forwarddflow(bbs, transformer_m, union_f, None, set([]))

if __name__ == "__main__":
    bbm = get_bbs("desugared3_no_inv.bpl")
    print(livevars(bbm))
    bbm = get_bbs("desugared-boogie-benchmarks/02.bpl")
    print(livevars(bbm))
