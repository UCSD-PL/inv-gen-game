from lib.boogie.ast import parseAst, AstImplementation, AstLabel, \
        AstAssert, AstAssume, AstHavoc, AstAssignment, AstGoto, \
        AstReturn, AstNode, AstStmt, AstType, AstProgram, AstMapIndex,\
        AstMapUpdate
from collections import namedtuple
from ..common.util import unique
from typing import Dict, List, Iterable, Tuple, Iterator, Any

Label_T = str
Bindings_T = Iterable[Tuple[str, AstType]]

class BB(List[AstStmt]):
    def __init__(self, label: Label_T, predecessors: Iterable["BB"], stmts: Iterable[AstStmt], successors: Iterable["BB"], internal: bool = False) -> None:
        super().__init__(stmts)
        self.label = label
        self._predecessors = list(predecessors)
        self._successors = list(successors)
        self._internal = internal

    def isInternal(self) -> bool:
        return self._internal

    def predecessors(self) -> List["BB"]:
        return self._predecessors

    def successors(self) -> List["BB"]:
        return self._successors

    def stmts(self) -> List[AstStmt]:
        return list(self)

    def addSuccessor(self, bb: "BB") -> None:
        self._successors.append(bb)
        bb._predecessors.append(self)

    def addPredecessor(self, bb: "BB") -> None:
        bb.addSuccessor(self)

    def isEntry(self) -> bool:
        return len(self._predecessors) == 0

    def isExit(self) -> bool:
        return len(self._successors) == 0

    def __hash__(self) -> int:
        return object.__hash__(self)

    def __str__(self) -> str:
        return self.label + "<[" + ";".join(str(x) for x in self.stmts()) + "]>"

    def __eq__(self, other: Any) -> bool:
        if not isinstance(other, BB):
            return False

        return object.__eq__(self, other)

    def to_json(self) -> Any:
        return [self.label,
                [bb.label for bb in self._predecessors],
                [str(stmt) for stmt in self],
                [bb.label for bb in self._successors]]

class Function(object):
    @staticmethod
    def load(filename: str) -> Iterable["Function"]:
        funcs = [] # type: List[Function]
        f = open(filename)
        txt = f.read()
        prog = parseAst(txt) # type: AstProgram
        for decl in prog.decls:
            assert isinstance(decl, AstImplementation)
            funcs.append(Function.build(decl))
        return funcs

    @staticmethod
    def build(fun: AstImplementation) -> "Function":
        # Step 1: Break statements into basic blocks
        bbs = {}
        curLbl = None
        successors = {}  # type: Dict[str, List[str]]
        for stmt in fun.body.stmts:
            # A BB starts with a labeled statment
            if (isinstance(stmt, AstLabel)):
                curLbl = str(stmt.label)
                bbs[curLbl] = BB(curLbl, [], [], [])
                stmt = stmt.stmt

            if (isinstance(stmt, AstAssert) or
                isinstance(stmt, AstAssume) or
                isinstance(stmt, AstHavoc) or
                isinstance(stmt, AstAssignment)):
                bbs[curLbl].append(stmt)
            elif (isinstance(stmt, AstGoto)):
                successors[curLbl] = successors.get(curLbl, []) + list(map(str, stmt.labels))
                curLbl = None
            elif (isinstance(stmt, AstReturn)):
                curLbl = None
            else:
                raise Exception("Unknown statement : " + str(stmt))

        for (lbl, succs) in successors.items():
            bbs[lbl]._successors = [bbs[x] for x in succs]

        for bb in bbs.values():
            for succ in bb.successors():
                succ._predecessors.append(bb)

        parameters = [(name, binding.typ) for binding in fun.signature[0] for name in binding.names ] # type: Bindings_T
        local_vars = [(name, binding.typ) for binding in fun.body.bindings for name in binding.names ] # type: Bindings_T
        returns = [(name, binding.typ) for binding in fun.signature[1] for name in binding.names ] # type: Bindings_T
        f = Function(fun.name, bbs.values(), parameters, local_vars, returns)

        if len(list(f.exits())) != 1:
            exitBB = BB("__dummy_exit__", [], [], [])

            for bb in f.exits():
                bb.addSuccessor(exitBB)

            f._bbs[exitBB.label] = exitBB

        return f
    
    def __init__(self, name: str, bbs: Iterable[BB], parameters: Bindings_T, local_vars: Bindings_T, returns: Bindings_T) -> None:
        self.name = name
        self._bbs = {bb.label: bb for bb in bbs}
        self.parameters = parameters
        self.locals = local_vars 
        self.returns = returns
        self._rewrite_assingments()

    def entry(self) -> BB:
        return unique([bb for bb in self._bbs.values() if not bb.isInternal() and bb.isEntry()])

    def exits(self) -> Iterator[BB]:
        return iter([bb for bb in self._bbs.values() if not bb.isInternal() and bb.isExit()])

    def exit(self) -> BB:
        return unique(self.exits())

    def bbs(self) -> Iterable[BB]:
        return self._bbs.values()

    def get_bb(self, label: Label_T) -> BB:
        return self._bbs[label]

    def _rewrite_assingments(self) -> None:
        """ Rewrite all assignments of the form:
            a[i] := v;
            to:
            a = a[i:=v];
        """
        for bb in self.bbs():
            for stmt_idx in range(len(bb)):
                stmt = bb[stmt_idx]
                if not (isinstance(stmt, AstAssignment) and
                    isinstance(stmt.lhs, AstMapIndex)):
                    continue

                bb[stmt_idx] = AstAssignment(stmt.lhs.map, AstMapUpdate(stmt.lhs.map, stmt.lhs.index, stmt.rhs))

    def to_json(self) -> Any:
        return [
                self.name,
                [(name, str(typ)) for (name, typ) in self.parameters],
                [(name, str(typ)) for (name, typ) in self.locals],
                [(name, str(typ)) for (name, typ) in self.returns],
                [bb.to_json() for bb in self._bbs.values()],
        ]
