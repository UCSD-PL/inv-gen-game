from lib.boogie.ast import parseAst, AstImplementation, AstLabel, \
        AstAssert, AstAssume, AstHavoc, AstAssignment, AstGoto, \
        AstReturn, AstNode, AstStmt, AstType, AstProgram, AstMapIndex,\
        AstMapUpdate
from collections import namedtuple
from ..common.util import unique, get_uid
from typing import Dict, List, Iterable, Tuple, Iterator, Any, Set

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

    def is_gcl(self) -> bool:
        """ A BB is in GCL form if all the assumes come first in the statement
        list, and all of the asserts come last. """
        def stmt_weight(stmt: AstStmt) -> int:
            if isinstance(stmt, AstAssume):
                return 0
            else:
                return 1

        stmt_weights = [stmt_weight(stmt) for stmt in self]
        return stmt_weights == sorted(stmt_weights)

    def pp(self) -> str:
        goto_str = "" if len(self.successors()) == 0 else \
            "\n    goto {};".format(",".join(bb.label for bb in self.successors()))

        return self.label + ":\n" + \
            "\n".join("    " + str(x) for x in self) + goto_str

    def reachable(self) -> Iterable["BB"]:
        reachable = set()  # type: Set[BB]
        workQ = [self]  # type: List[BB]
        while len(workQ) > 0:
            bb = workQ.pop()
            if bb in reachable:
                continue

            reachable.add(bb)
            workQ.extend(bb.successors())

        return reachable


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
        return iter([bb for bb in self._bbs.values() if bb.isExit()])

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

    def is_gcl(self) -> bool:
        return all(bb.is_gcl() for bb in self._bbs.values())

    def split_asserts(self) -> Tuple["Function", Dict[BB, BB]]:
        workQ = [(None, self.entry())]  # type: List[Tuple[BB, BB]]
        bbMap = {}  # type: Dict[BB, BB]

        while len(workQ) > 0:
            (from_bb, cur_bb) = workQ.pop()
            if cur_bb in bbMap: # already visited cur_bb and created a copy
                if from_bb is not None:
                    from_bb._successors.append(bbMap[cur_bb])
                    bbMap[cur_bb]._predecessors.append(from_bb)
                continue

            new_bb = BB(
                cur_bb.label,
                [bbMap[x] for x in cur_bb.predecessors() if x in bbMap],
                [],
                [],
                False,
            )

            for pred in cur_bb.predecessors():
                if pred not in bbMap:
                    continue

                bbMap[pred]._successors.append(new_bb)

            bbMap[cur_bb] = new_bb

            for stmt in cur_bb.stmts():
                if isinstance(stmt, AstAssert):
                    if new_bb.isInternal() and new_bb.label.startswith("_assert_"):
                        new_bb.append(stmt)
                    else:
                        tmp_bb = BB(
                            get_uid("_assert"),
                            [new_bb],
                            [stmt],
                            [],
                            True
                        )
                        new_bb._successors.append(tmp_bb)
                        new_bb = tmp_bb
                else:
                    if new_bb.isInternal() and new_bb.label.startswith("_assert_"):
                        tmp_bb = BB(
                            get_uid("_assign"),
                            [new_bb],
                            [stmt],
                            [],
                            True
                        )
                        new_bb._successors.append(tmp_bb)
                        new_bb = tmp_bb
                    else:
                        new_bb.append(stmt)

            for succ in cur_bb.successors():
                workQ.append((new_bb, succ))

        return (Function(self.name, bbMap[self.entry()].reachable(),
                         self.parameters, self.locals, self.returns), bbMap)

    def pp(self) -> str:
        def pp_bindings(b: Bindings_T) -> str:
            return ",".join("{}:{}".format(str(id), str(typ)) for (id, typ) in self.parameters)

        def pp_locals(b: Bindings_T) -> str:
            return "\n".join("    var {}: {};".format(str(id), str(typ)) for (id, typ) in self.parameters)

        return "implementation {}({}) returns ({})\n{{\n{}\n{}\n}}".format(
            self.name,
            pp_bindings(self.parameters),
            pp_bindings(self.returns),
            pp_locals(self.locals),
            "\n\n".join(bb.pp() for bb in self._bbs.values()))
