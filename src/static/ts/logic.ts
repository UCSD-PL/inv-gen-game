/* Requires Epsrima.js */
declare var rpc: JsonRpcClient;
type cbT = (result: any) => void

function invToEsp(inv: string): ESTree.Node {
  return esprima.parse(inv);
}

function equivalentPairs(invL1: string[], invL2: string[], cb: cbT): void {
  rpc.call("App.equivalentPairs",
    [$.map(invL1, invToEsp), invL2.map(esprima.parse)], cb, log);
}

function equivalent(inv1: string, inv2: string, cb: (res: boolean) => void): void {
  equivalentPairs([inv1], [inv2], function(res) { cb(res.length > 0); });
}

function impliedPairs(invL1: string[], invL2: string[], cb: cbT): void {
  rpc.call("App.impliedPairs",
    [$.map(invL1, esprima.parse), invL2.map(esprima.parse)], cb, log);
}

function implied(invL1: string[], inv: string, cb: (res: boolean) => void): void {
  impliedPairs(invL1, [inv], function(res) { cb(res.length > 0); });
}

function impliedBy(invL1: string[], inv: string, cb: (res: number|void) => void): void {
  impliedPairs(invL1, [inv], function(res) {
    if (res.length > 0)
      cb(res[0][0]);
    else
      cb(null);
  });
}

function equivalentToAny(invL1: string[], inv: string, cb: (res: number|void) => void): void {
  equivalentPairs(invL1, [inv], function(res) {
    if (res.length > 0)
      cb(res[0][0]);
    else
      cb(null);
  });
}

function isTautology(inv: string, cb: (res: boolean) => void): void {
  rpc.call("App.isTautology", [esprima.parse(inv)], cb, log);
}

function counterexamples(lvlSet: string, lvlId: string, invs: string[], cb: (res: dataT) => void) {
  return rpc.call("App.verifyInvariants", [lvlSet, lvlId, invs.map(esprima.parse)], cb, log);
}

function pre_vc_ctrex(lvlSet: string, lvlId: string, invs: string[], cb: (res: [number[]]) => void) {
  return rpc.call("App.checkPreVC", [lvlSet, lvlId, invs.map(esprima.parse)], cb, log);
}

function ind_vc_ctrex(lvlSet: string, lvlId: string, invs: string[], cb: (res: [number[]]) => void) {
  return rpc.call("App.checkIndVC", [lvlSet, lvlId, invs.map(esprima.parse)], cb, log);
}
