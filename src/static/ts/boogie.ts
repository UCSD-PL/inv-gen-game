import {single, entries, assert} from "./util"

export type Stmt_T = string;
export type Expr_T = string;

export interface BB {
  label: string;
  predecessors: string[];
  successors: string[];
  stmts: Stmt_T[];
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

  entry(): string {
    let entryBbs: string[] = entries(this.bbs).filter(
      (lbl:string) => this.bbs[lbl].predecessors.length == 0);
    return single<string>(entryBbs);
  }

  exit(): string {
    let exitBbs: string[] = entries(this.bbs).filter(
      (lbl:string) => this.bbs[lbl].successors.length == 0);
    return single<string>(exitBbs);
  }

  static from_json(json: any): Fun {
    let bbs : {[label: string] : BB } = {}

    for (let json_bb of json[4]) {
      let label: string = json_bb[0]
      bbs[label] = {
        label: label,
        predecessors: json_bb[1] as string[],
        stmts: json_bb[2] as string[],
        successors: json_bb[3] as string[],
      }
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
    this.bbs[fromLbl].successors.push(toLbl);
    this.bbs[toLbl].predecessors.push(fromLbl);
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

    this.bbs[lbl] = {
      label: lbl,
      predecessors: [],
      stmts: stmts,
      successors: [],
    }

    for (let pred of predecessors) {
      this.addEdge(pred, lbl);
    }

    for (let succ of successors) {
      this.addEdge(lbl, succ);
    }

    return this.bbs[lbl];
  }
}
