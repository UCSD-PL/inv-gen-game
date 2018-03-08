import {unique} from "./util"

export interface BB {
  label: string;
  predecessors: string[];
  successors: string[];
  stmts: string[];
}

export interface Binding {
  name: string;
  typ: string;
}

export interface Fun {
  name: string;
  parameters: Binding[];
  locals: Binding[];
  returns: Binding[];
  bbs: {[label: string] : BB };
  entry: string;
  exit: string;
}

export function from_json(json: any): Fun {
  let bbs : {[label: string] : BB } = {}
  let entry, exit: string = null;

  for (let json_bb of json[4]) {
    let label: string = json_bb[0]
    bbs[label] = {
      label: label,
      predecessors: json_bb[1] as string[],
      stmts: json_bb[2] as string[],
      successors: json_bb[3] as string[],
    }

    if (json_bb[1].length == 0) {
      entry = label;
    }

    if (json_bb[3].length == 0) {
      exit = label;
    }
  }

  return {
    name: json[0] as string,
    parameters: json[1] as Binding[],
    locals: json[2] as Binding[],
    returns: json[3] as Binding[],
    bbs: bbs,
    entry: entry,
    exit: exit
  }
}
