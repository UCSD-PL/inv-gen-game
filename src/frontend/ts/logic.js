define(["require", "exports", "./rpc"], function (require, exports, rpc_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    function equivalentPairs(invL1, invL2, cb) {
        rpc_1.rpc_equivalentPairs(invL1, invL2, cb);
    }
    exports.equivalentPairs = equivalentPairs;
    function equivalent(inv1, inv2, cb) {
        equivalentPairs([inv1], [inv2], function (res) { cb(res.length > 0); });
    }
    function impliedPairs(invL1, invL2, cb) {
        rpc_1.rpc_impliedPairs(invL1, invL2, cb);
    }
    exports.impliedPairs = impliedPairs;
    function implied(invL1, inv, cb) {
        impliedPairs(invL1, [inv], function (res) { cb(res.length > 0); });
    }
    function impliedBy(invL1, inv, cb) {
        impliedPairs(invL1, [inv], function (res) {
            cb(res.map((([inv1, inv2]) => inv1)));
        });
    }
    exports.impliedBy = impliedBy;
    function isTautology(inv, cb) {
        rpc_1.rpc_isTautology(inv, cb);
    }
    exports.isTautology = isTautology;
    function simplify(inv, cb) {
        rpc_1.rpc_simplify(inv, cb);
    }
    exports.simplify = simplify;
    /*
     *  Given a list of candidate invariants invs tryAndVerify will
     *  return:
     *    - the subset of inv that is overfitted (+ counterexample for each)
     *    - the subset of inv that is non-inductive (+ counterexample for each)
     *    - the subset of inv that is sound
     *    - any counterexamples if the sound subset doesn't imply the postcondition
     *
     */
    function tryAndVerify(lvlSet, lvlId, invs, cb) {
        rpc_1.rpc_tryAndVerify(lvlSet, lvlId, invs, cb);
    }
    exports.tryAndVerify = tryAndVerify;
    function instantiate(templates, lvlVars, // TODO: Should eventually not need this argument. Convert 
        data, //       data to a dictionary containing variable names.
        cb) {
        rpc_1.rpc_instantiate(templates, lvlVars, data, cb);
    }
});
//# sourceMappingURL=logic.js.map