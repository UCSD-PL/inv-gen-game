from boogie_ast import *;
from collections import namedtuple

BB = namedtuple("BB", ["predecessors", "stmts", "successors"])

def get_bbs(filename):
    ast = parseAst(open(filename).read())
    fun = ast[0]._children[0][0]
    assert (isinstance(fun, AstImplementation))
    # Step 1: Break statements into basic blocks
    bbs = {}
    curLbl = None
    for stmt in fun.body.stmts:
        # A BB starts with a labeled statment
        if (isinstance(stmt, AstLabel)):
            curLbl = str(stmt.label);
            bbs[curLbl] = BB([], [], [])
            stmt = stmt.stmt;

        if (isinstance(stmt, AstAssert) or
            isinstance(stmt, AstAssume) or
            isinstance(stmt, AstAssignment)):
            bbs[curLbl].stmts.append(stmt)
        elif (isinstance(stmt, AstGoto)):
            bbs[curLbl].successors.extend(map(str, stmt.labels))
            curLbl = None;
        elif (isinstance(stmt, AstReturn)):
            curLbl = None;
        else:
            raise Exception("Unknown statement : " + str(stmt))

    for bb in bbs:
        for succ in bbs[bb].successors:
            bbs[succ].predecessors.append(bb)

    return bbs

def entry(bbs):
    e = [x for x in bbs if len(bbs[x].predecessors) == 0]
    assert (len(e) == 1)
    return e[0]

def exit(bbs):
    e = [x for x in bbs if len(bbs[x].successors) == 0]
    assert (len(e) == 1)
    return e[0]

def bbpath_to_stmts(bb_path, bbs):
    r = []
    for b in bb_path:   
        if (isinstance(b, BB)):
            r.extend(bbs[b].stmts)
        else:
            r.append([ bbpath_to_stmts(x, bbs) for x in b ])
    return r
