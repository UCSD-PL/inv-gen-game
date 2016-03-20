from boogie_ast import *;
from collections import namedtuple

BB = namedtuple("BB", ["stmts", "successors"])

def get_bbs(filename):
    ast = parseAst(open(filename).read())
    fun = ast[0]._children[0]
    assert (isinstance(fun, AstImplementation))
    # Step 1: Break statements into basic blocks
    bbs = {}
    curLbl = None
    for stmt in fun._body._stmts:
        # A BB starts with a labeled statment
        if (isinstance(stmt, AstLabel)):
            curLbl = stmt._label;
            bbs[curLbl] = BB([], [])
            stmt = stmt._stmt;

        if (isinstance(stmt, AstAssert) or
            isinstance(stmt, AstAssume) or
            isinstance(stmt, AstAssignment)):
            bbs[curLbl].stmts.append(stmt)
        elif (isinstance(stmt, AstGoto)):
            bbs[curLbl].successors.extend(stmt._labels)
            curLbl = None;
        elif (isinstance(stmt, AstReturn)):
            curLbl = None;
        else:
            raise Exception("Unknown statement : " + str(stmt))

    return bbs
        
    # Step 2: Build CFG amongst blocks
    # Step 3: Build VCs along each edge


if __name__ == "__main__":
    bbs = get_bbs("desugared2.bpl")
