import {Args, log} from "../../ts/util";
import {dataT, TypeEnv} from "../../ts/types";
import {Node as ESNode} from "estree";
import {rpc, mturkId} from "../../ts/rpc";
import {Violation, InvNetwork} from "./invgraph_game"

interface loadLvlRes {
  id: string;
  variables: string[];
  data: dataT;
  typeEnv: TypeEnv;
  fun: any;
}

export function rpc_loadLvl(lvlSet: string, id: string, cb:(res: loadLvlRes) => void) {
  rpc.call("App.loadLvl", [lvlSet, id, mturkId()], (data:any) => cb(<loadLvlRes>data), log);
}

export function rpc_checkSoundness(lvlSet: string, lvlId: string, invs: InvNetwork,
    cb: (res: Violation[]) => void) {  // Post-cond counterexample to all invariants
    rpc.call("App.checkSoundness", [ lvlSet, lvlId, invs, mturkId() ], cb, log);
}