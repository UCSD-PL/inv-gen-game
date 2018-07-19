/* This file defines the RPC interface between server and client */
import {Args, log, unique} from "./util";
import {invariantT, templateT, dataT, TypeEnv} from "./types";
import {esprimaToStr} from "./eval";
import {parse} from "esprima";
import {Node as ESNode} from "estree";
import { JsonRpcClient } from "../js/jquery.jsonrpcclient"

export let rpc: JsonRpcClient = new $.JsonRpcClient({ ajaxUrl: "/api" });

interface loadLvlRes {
  id: string;
  variables: string[];
  data: dataT;
  hint: any;
  colSwap: any;
  goal: any;
  typeEnv: TypeEnv
  startingInvs: [string, invariantT][];
  lvlSet: string;
  ShowQuestionaire: boolean;
}

let errorFunc: (err: any) => void = log;
export function setErrorFeedback(cb: (err: any) => void) {
    errorFunc = cb;
}

export function mturkId(): [string, string, string] {
  return [Args.get_worker_id(), Args.get_hit_id(), Args.get_assignment_id()];
}

export function rpc_loadLvl(lvlSet: string, id: string, cb:(res: loadLvlRes) => void) {
    rpc.call("App.loadLvl", [lvlSet, id, mturkId()], (data: any) => cb(<loadLvlRes>data), errorFunc);
}

export function rpc_loadNextLvl(workerkId: string, cb:(res: loadLvlRes) => void) {
    rpc.call("App.loadNextLvlFacebook", [workerkId, mturkId(), Args.get_individual_mode()], (data: any) => cb(<loadLvlRes>data), errorFunc);
}

export function rpc_equivalentPairs(invL1: invariantT[], invL2: invariantT[], typeEnv: TypeEnv,
                             cb: (arg:[ESNode, ESNode][])=>void): void {
    rpc.call("App.equivalentPairs", [invL1, invL2, typeEnv, mturkId()], cb, errorFunc);
}

export function rpc_impliedPairs(invL1: invariantT[], invL2: invariantT[], typeEnv: TypeEnv,
                             cb: (arg:[ESNode, ESNode][])=>void): void {
    rpc.call("App.impliedPairs", [invL1, invL2, typeEnv, mturkId()], cb, errorFunc);
}

export function rpc_isTautology(inv: invariantT, typeEnv: TypeEnv, cb:(res:boolean)=>void): void {
    rpc.call("App.isTautology", [inv, typeEnv, mturkId()], cb, errorFunc);
}

export function rpc_simplify(inv:string, typeEnv: TypeEnv, cb:(res:ESNode)=>void): void {
    rpc.call("App.simplifyInv", [parse(inv), typeEnv, mturkId()], cb, errorFunc);
}

export function rpc_tryAndVerify(lvlSet: string, lvlId: string, invs: invariantT[],
                              cb: (res: [ [ESNode, any[]][], // Overfitted invs & counterexample
                                     [ESNode, [any[], any[]]][], // Nonind. invs & counterexample
                                     ESNode[], // Sound Invariants
                                     any[],// Post cond. counterexample to sound invariants
                                     any[]]) => void) {  // Post-cond counterexample to all invariants
    rpc.call("App.tryAndVerify", [lvlSet, lvlId, invs, mturkId(), Args.get_individual_mode()], cb, errorFunc);
}

export function rpc_logEvent(workerId: string, name: string, data: any, cb?: (res: any) => void): any {
    if (cb === undefined)
        cb = (res) => { }
    return rpc.call("App.logEvent", [workerId, name, data, mturkId()], cb, errorFunc);
}

export function logEvent(name: string, data: any, cb?: (res: any) => void): any {
  return rpc_logEvent(Args.get_worker_id(), name, data, cb);
}
