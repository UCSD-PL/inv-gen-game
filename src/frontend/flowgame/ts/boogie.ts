import {single, entries, assert} from "../../ts/util"
import {HasId, DiGraph} from "./graph"
import {TypeEnv} from "../../ts/types"

export type Stmt_T = string;
export type Expr_T = string;

export class BB extends DiGraph implements HasId {
  id: string;
  stmts: Stmt_T[];
  constructor(label: string, stmts: Stmt_T[]) {
    super();
    this.id = label;
    this.stmts = stmts;
  }
}

export interface Binding {
  name: string;
  typ: string;
}

export class Fun {
  name: string;
  parameters: Binding[];
  locals: Binding[];
  returns: Binding[];
  bbs: {[label: string] : BB };

  constructor(name: string,
              parameters: Binding[],
              returns: Binding[],
              locals?: Binding[],
              bbs?: {[label: string] : BB }) {
    if (locals === undefined) {
      locals = [];
    }

    if (bbs === undefined) {
      bbs = {};
    }

    this.name = name;
    this.parameters = parameters;
    this.returns = returns;
    this.locals = locals;
    this.bbs = bbs;
  }

  entry(): BB {
    let entries: BB[] = [];
    for (let lbl in this.bbs) {
      let bb = this.bbs[lbl];
      if (bb.predecessors.length == 0) {
        entries.push(bb)
      }
    }
    return single<BB>(entries);
  }

  exit(): BB {
    let exits: BB[] = [];
    for (let lbl in this.bbs) {
      let bb = this.bbs[lbl];
      if (bb.successors.length == 0) {
        exits.push(bb)
      }
    }
    return single<BB>(exits);
  }

  static from_json(json: any): Fun {
    let bbs : {[label: string] : BB } = {}

    for (let json_bb of json[4]) {
      let label: string = json_bb[0]
      bbs[label] = new BB(label, json_bb[2] as string[]);
    }

    for (let json_bb of json[4]) {
      let label: string = json_bb[0]
      bbs[label].predecessors = json_bb[1].map((x:string): BB => bbs[x]);
      bbs[label].successors = json_bb[3].map((x:string): BB => bbs[x]);
    }

    return new Fun(
      json[0] as string,    // Names
      json[1] as Binding[], // Parameters
      json[3] as Binding[], // Returns
      json[2] as Binding[], // Locals
      bbs
    )
  }

  addEdge(fromLbl: string, toLbl: string): void {
    assert((fromLbl in this.bbs), "Unknown from BB " + fromLbl);
    assert((toLbl in this.bbs), "Unknown to BB " + toLbl);
    this.bbs[fromLbl].successors.push(this.bbs[toLbl]);
    this.bbs[toLbl].predecessors.push(this.bbs[fromLbl]);
  }

  addNewBB(lbl: string,
           predecessors?: string[],
           successors?: string[],
           stmts?: string[]): BB {
    assert(!(lbl in this.bbs), "Overwriting BB " + lbl);

    if (predecessors === undefined) {
      predecessors = [];
    }

    if (successors === undefined) {
      successors = [];
    }

    if (stmts === undefined) {
      stmts = [];
    }

    this.bbs[lbl] = new BB(lbl, stmts);

    for (let pred of predecessors) {
      this.addEdge(pred, lbl);
    }

    for (let succ of successors) {
      this.addEdge(lbl, succ);
    }

    return this.bbs[lbl];
  }

  getTypeEnv(): TypeEnv {
    let t: TypeEnv = {};
    for (let binding of this.parameters.concat(this.locals, this.returns)) {
      t[binding.name] = binding.typ
    }
    return t
  }
}
