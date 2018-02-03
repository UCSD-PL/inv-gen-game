from lib.boogie.ast import parseAst, AstImplementation, AstLabel, \
        AstAssert, AstAssume, AstHavoc, AstAssignment, AstGoto, \
        AstReturn, AstNode
from collections import namedtuple
from ..common.util import unique
from typing import Dict, List

BB = namedtuple("BB", ["predecessors", "stmts", "successors"])
Label_T = str
BBs_T = Dict[Label_T, BB]

def get_bbs(filename: str) -> BBs_T:
    ast = parseAst(open(filename).read())
    fun = ast._children[0][0] #type: AstNode
    assert (isinstance(fun, AstImplementation))
    # Step 1: Break statements into basic blocks
    bbs = {}
    curLbl = None
    for stmt in fun.body.stmts:
        # A BB starts with a labeled statment
        if (isinstance(stmt, AstLabel)):
            curLbl = str(stmt.label)
            bbs[curLbl] = BB([], [], [])
            stmt = stmt.stmt

        if (isinstance(stmt, AstAssert) or
            isinstance(stmt, AstAssume) or
            isinstance(stmt, AstHavoc) or
            isinstance(stmt, AstAssignment)):
            bbs[curLbl].stmts.append(stmt)
        elif (isinstance(stmt, AstGoto)):
            bbs[curLbl].successors.extend(list(map(str, stmt.labels)))
            curLbl = None
        elif (isinstance(stmt, AstReturn)):
            curLbl = None
        else:
            raise Exception("Unknown statement : " + str(stmt))

    for bb in bbs:
        for succ in bbs[bb].successors:
            bbs[succ].predecessors.append(bb)

    return bbs

def is_internal_bb(bb: Label_T) -> bool:
    return bb.startswith("_union_") or bb == "_tmp_header_pred_"

def bbEntry(bbs: BBs_T) -> Label_T:
    e = [x for x in bbs
           if (not is_internal_bb(x) and len(bbs[x].predecessors) == 0)]
    assert (len(e) == 1)
    return e[0]

def bbExits(bbs: BBs_T) -> List[Label_T]:
    return [x for x in bbs
              if not is_internal_bb(x) and len(bbs[x].successors) == 0]

def bbExit(bbs: BBs_T) -> Label_T:
    return unique(bbExits(bbs))

def ensureSingleExit(bbs: BBs_T) -> None:
    e = bbExits(bbs)
    if (len(e) == 1):
      return

    bbs["_exit_"] = BB(e, [ ], [])
    
    for bb_lbl in e:
      bbs[bb_lbl].successors.append("_exit_")
