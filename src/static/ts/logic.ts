/* Requires Epsrima.js */
declare var rpc: JsonRpcClient;
type cbT = (result: any) => void

function equivalentPairs(invL1: invariantT[], invL2: invariantT[], cb: cbT): void {
  rpc.call("App.equivalentPairs",
    [ invL1, invL2 ], cb, log)
}

function equivalent(inv1:invariantT, inv2:invariantT, cb:(res:boolean)=>void): void {
  equivalentPairs([inv1], [inv2], function (res) { cb(res.length > 0) });
}

function impliedPairs(invL1:invariantT[], invL2:invariantT[],
                      cb:(arg:[ESTree.Node, ESTree.Node][])=>void): void {
  rpc.call("App.impliedPairs", [ invL1, invL2 ], cb, log)
}

function implied(invL1:invariantT[], inv:invariantT , cb:(res:boolean)=>void): void {
  impliedPairs(invL1, [inv], function (res) { cb(res.length > 0) });
}

function impliedBy(invL1:invariantT[], inv:invariantT, cb:(res:ESTree.Node[])=>void): void {
  impliedPairs(invL1, [inv], function (res) {
    cb(res.map((([inv1,inv2])=>inv1)))
  });
}

function equivalentToAny(invL1:invariantT[], inv:invariantT, cb:(res:number|void)=>void): void {
  equivalentPairs(invL1, [inv], function (res) {
    if (res.length > 0)
      cb(res[0][0]);
    else
      cb(null);
  });
}

function isTautology(inv:invariantT, cb:(res:boolean)=>void): void {
  rpc.call("App.isTautology", [ inv ], cb, log)
}

function simplify(inv:string, cb:(res:ESTree.Node)=>void): void {
  rpc.call("App.simplifyInv", [ esprima.parse(inv) ], cb, log)
}

function counterexamples(lvlSet: string, lvlId: string, invs: invariantT[],
                         cb: (res: [ [ESTree.Node, any[]][], // Overfitted invs & counterexample
                                     [ESTree.Node, [any[], any[]]][], // Nonind. invs & counterexample
                                     ESTree.Node[], // Sound Invariants
                                     any[]]) => void) {  // Post cond. counterexample to sound invariants
  return rpc.call("App.verifyInvariants", [ lvlSet, lvlId, invs ], cb, log)
}

function checkInvs(lvlSet: string, lvlId: string, invs: invariantT[],
                  cb: (res: [ [ESTree.Node, any[]][],
                              [ESTree.Node, [any[], any[]]][],
                              ESTree.Node[] ]) => void) {
  return rpc.call("App.checkInvs", [ lvlSet, lvlId, invs ], cb, log)
}
