import {Fun, BB, Stmt_T, Expr_T} from "./boogie";
import {getUid, assert, single} from "./util"
import {HasId, DiGraph, leaves} from "./graph"

export abstract class Node extends DiGraph implements HasId {
  id: string;

  constructor(id: string) {
    super()
    this.id = id;
  }
}

export abstract class ExprNode extends Node {
  expr: Expr_T;
  constructor(id: string, expr: Expr_T) {
    super(id);
    this.expr = expr;
  }
}

export class AssignNode extends Node {
  stmts: Stmt_T[];
  constructor(id: string, stmts: Stmt_T[]) {
    super(id);
    this.stmts = stmts;
  }
}

export class IfNode extends ExprNode { }
export class AssumeNode extends ExprNode { }
export class AssertNode extends ExprNode { }
export class EmptyNode extends Node { }

let assumeRE = / *assume *(.*);/;
let assertRE = / *assume *(.*);/;

function split_assumes(stmts: Stmt_T[]): [Stmt_T[], Stmt_T[]] {
  let assumes: Stmt_T[] = [];
  let rest: Stmt_T[] = [];
  for (let stmt of stmts) {
    if (stmt.match(assumeRE)) {
      assumes.push(stmt)
    } else {
      rest.push(stmt)
    }
  }

  return [assumes, rest];
}


function assume_expr(stmt: Stmt_T): Expr_T {
  // Extract the expression inside an assume
  return stmt.match(assumeRE)[1]
}

function assert_expr(stmt: Stmt_T): Expr_T {
  // Extract the expression inside an assert
  return stmt.match(assertRE)[1]
}

function and(exprs: Expr_T[]): Expr_T {
  if (exprs.length == 0) {
    return "true";
  } else if (exprs.length == 1) {
    return exprs[0];
  } else {
    return "(" + exprs.join(") and (") + ")"
  }
}

function is_assert(stmt: Stmt_T): boolean {
  return stmt.match(assertRE) !== null
}

type NodeMap ={ [label: string]: Node };

export function buildGraph(f: Fun): [Node, NodeMap] {
  let bbMap: NodeMap = {};
  let entry: Node = null;

  // Build entry node. (a sequence of assume -> assign)
  let entryBB = f.bbs[f.entry()];
  let [assumes, rest] = split_assumes(entryBB.stmts);
  entry = new AssumeNode(getUid("nd"), and(assumes.map(assume_expr)));

  function mkNode(stmts: Stmt_T[]): Node {
      if (stmts.length == 0) {
        return new EmptyNode(getUid("nd"))
      } else if (is_assert(stmts[0])) {
        return new AssertNode(getUid("nd"), and(stmts.map(assert_expr)))
      } else {
        return new AssignNode(getUid("nd"), stmts)
      }
  }

  let workQ: [BB, Node][] = [[entryBB, entry]];
  while (workQ.length > 0) {
    let [bb, pred] = workQ.shift();
    let node : Node;
    let [assumes, rest] = split_assumes(bb.stmts);

    if (bb.label in bbMap) {
      pred.addSuccessor(bbMap[bb.label])
      continue;
    }

    node = mkNode(rest);
    bbMap[bb.label] = node;
    pred.addSuccessor(node);

    if (bb.successors.length == 0) {
      // Exit node
    } else if (bb.successors.length == 1) {
      let nextBB = f.bbs[bb.successors[0]];
      let [assumes, rest] = split_assumes(nextBB.stmts);
      // No assumes(only branches have assumes) and non-empty node
      assert(assumes.length == 0);
      workQ.push([nextBB, node])
    } else if (bb.successors.length == 2) {
      let [lhsBB, rhsBB]: BB[] = bb.successors.map((x:string) => f.bbs[x]);
      let [lhsAssume, lhsRest] = split_assumes(lhsBB.stmts);
      let [rhsAssume, rhsRest] = split_assumes(rhsBB.stmts);

      assert(lhsAssume.length > 0);
      assert(rhsAssume.length > 0);

      let lhsExpr: Expr_T = and(lhsAssume.map(assume_expr));
      let rhsExpr: Expr_T = and(rhsAssume.map(assume_expr));
      // TODO: Check lhsExpr/rhsExpr disjoint and complete
      // TODO: Pick if expr intelligently
      let ifExpr = lhsExpr;
      let ifNode = new IfNode(getUid("nd"), ifExpr);
      if (!(bb.label in bbMap)) {
        bbMap[bb.label] = ifNode;
      }
      node.addSuccessor(ifNode);
      workQ.push([lhsBB, ifNode])
      workQ.push([rhsBB, ifNode])
    } else {
      assert(false, "Too many successors for bb " + bb);
    }
  }

  return [entry, bbMap];
}

export function removeEmptyNodes(entry: Node, m: NodeMap): [Node, NodeMap] {
  let res: Node = entry;
  let workQ: Node[] = [entry];
  let visited: { [key: string]: boolean } = {};

  while (workQ.length > 0) {
    let nd = workQ.shift();
    if (nd.id in visited)
      continue;
    visited[nd.id] = true;

    if (nd instanceof EmptyNode) {
      nd.snip();

      for (let k in m) {
        if (m[k] == nd) {
          m[k] = nd.successors[0];
        }
      }

      if (res == nd) {
        res = nd.successors[0];
      }
    }
    workQ = workQ.concat(nd.successors);
  }

  return [res, m];
}

export function max(a: number[]): number {
  let max = a[0];
  for (let v of a) {
    if (v>max)  max=v;
  }

  return max;
}

// Return the single exit node reachable from n
export function exit(n: Node): Node {
  return single<Node>(leaves(n));
}