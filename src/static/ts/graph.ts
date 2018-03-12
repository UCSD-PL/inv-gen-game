import {assert, StrMap} from "./util"

export interface HasId {
  id: string;
}

export abstract class DiGraph {
  predecessors: this[];
  successors: this[];

  constructor() {
    this.predecessors = [];
    this.successors = [];
  }

  addSuccessor(n: this): void {
    this.successors.push(n);
    n.predecessors.push(this);
  }

  removeSuccessor(n: this): void {
    this.successors.splice(this.successors.indexOf(n), 1);
    n.predecessors.splice(n.predecessors.indexOf(this), 1);
  }

  addPredecessor(n: this): void {
    n.addSuccessor(this);
  }

  removePredecessor(n: this): void {
    n.removeSuccessor(this);
  }

  snip(): void {
    assert(this.successors.length == 1);
    let succ = this.successors[0];
    assert(succ.predecessors.length == 1);

    for (let pred of this.predecessors) {
      pred.successors[pred.successors.indexOf(this)] = succ;
    }

    succ.predecessors = this.predecessors;
  }

  reachable(): Set<this> {
    let res: Set<this> = new Set();
    function discover(prev, next) { res.add(next); }
    bfs(this, discover, null);
    return res;
  }
}

export function bfs<T extends DiGraph>(
  node: T,
  discover: (f:T,t:T)=>any,
  backedge: (f:T,t:T)=>any): void
{
  let visited: Set<T> = new Set();
  let workQ: [T, T][] = [[null, node]];

  while (workQ.length > 0) {
    let [prev, next]: [T,T] = workQ.shift();
    if (visited.has(next)) {
      if (backedge !== null) {
        backedge(prev, next)
      }
      continue;
    }
    visited.add(next);
    if (discover != null)
      discover(prev, next);
    workQ = workQ.concat(next.successors.map((succ): [T,T] => [next, succ]));
  }
}

export function topo_sort<T extends (HasId & DiGraph)>(node: T): StrMap<number> {
  let m: StrMap<number> = {};
  function discover(prev: T, next: T) {
    if (prev == null) {
      m[next.id] = 0;
    } else {
      m[next.id] = m[prev.id] + 1;
    }
  }
  bfs(node, discover, null);
  return m;
}

// Find all leaves reachable from n
export function leaves<T extends DiGraph>(n: T): T[] {
  let res: T[] = [];

  function addLeaf(prev: T, next: T) {
    if (next.successors.length == 0) {
      res.push(next);
    }
  }

  bfs(n, addLeaf, null);
  return res;
}