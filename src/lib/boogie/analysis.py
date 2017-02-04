from copy import copy
from bb import *
from ast import *

def backdflow(bbs, transformer_m, union_f, initial_vals):
    state = { bb: copy(initial_vals) for bb in bbs.keys() }
    wlist = [ exit(bbs) ]
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

def livevars(bbs):
    transformer_m = {
        AstAssert:  lambda stmt, inS: inS.union(stmt_read(stmt)),
        AstAssume:  lambda stmt, inS: inS.union(stmt_read(stmt)),
        AstHavoc:  lambda stmt, inS: inS - stmt_changed(stmt),
        AstAssignment:  lambda stmt, inS:   (inS - stmt_changed(stmt)).union(stmt_read(stmt)) 
    }
    def union_f(sets):
        return reduce(lambda x,y:   x.union(y), filter(lambda x:  x != None, sets), set([]))
    return backdflow(bbs, transformer_m, union_f, None)
    
if __name__ == "__main__":
    bbs = get_bbs("desugared3_no_inv.bpl")
    print livevars(bbs)
    bbs = get_bbs("desugared-boogie-benchmarks/02.bpl")
    print livevars(bbs)
