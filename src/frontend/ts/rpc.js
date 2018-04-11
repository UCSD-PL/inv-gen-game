define(["require", "exports", "./util", "./eval", "esprima"], function (require, exports, util_1, eval_1, esprima_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.rpc = new $.JsonRpcClient({ ajaxUrl: "/api" });
    function mturkId() {
        return [util_1.Args.get_worker_id(), util_1.Args.get_hit_id(), util_1.Args.get_assignment_id()];
    }
    exports.mturkId = mturkId;
    function rpc_loadLvlBasic(lvlSet, id, cb) {
        exports.rpc.call("App.loadLvl", [lvlSet, id, mturkId()], (data) => cb(data), util_1.log);
    }
    exports.rpc_loadLvlBasic = rpc_loadLvlBasic;
    function rpc_loadLvlDynamic(lvlSet, id, cb) {
        exports.rpc.call("App.loadLvl", [lvlSet, id, mturkId()], (data) => cb(data), util_1.log);
    }
    exports.rpc_loadLvlDynamic = rpc_loadLvlDynamic;
    function rpc_loadNextLvlDynamic(workerkId, cb) {
        exports.rpc.call("App.loadNextLvl", [workerkId, mturkId(), util_1.Args.get_individual_mode()], (data) => cb(data), util_1.log);
    }
    exports.rpc_loadNextLvlDynamic = rpc_loadNextLvlDynamic;
    function rpc_genNextLvlDynamic(workerkId, lvlSet, lvlId, invs, cb) {
        exports.rpc.call("App.genNextLvl", [workerkId, mturkId(), lvlSet, lvlId, invs, util_1.Args.get_individual_mode()], (data) => cb(data), util_1.log);
    }
    function rpc_equivalentPairs(invL1, invL2, cb) {
        exports.rpc.call("App.equivalentPairs", [invL1, invL2, mturkId()], cb, util_1.log);
    }
    exports.rpc_equivalentPairs = rpc_equivalentPairs;
    function rpc_impliedPairs(invL1, invL2, cb) {
        exports.rpc.call("App.impliedPairs", [invL1, invL2, mturkId()], cb, util_1.log);
    }
    exports.rpc_impliedPairs = rpc_impliedPairs;
    function rpc_isTautology(inv, cb) {
        exports.rpc.call("App.isTautology", [inv, mturkId()], cb, util_1.log);
    }
    exports.rpc_isTautology = rpc_isTautology;
    function rpc_simplify(inv, cb) {
        exports.rpc.call("App.simplifyInv", [esprima_1.parse(inv), mturkId()], cb, util_1.log);
    }
    exports.rpc_simplify = rpc_simplify;
    function rpc_tryAndVerify(lvlSet, lvlId, invs, cb) {
        exports.rpc.call("App.tryAndVerify", [lvlSet, lvlId, invs, mturkId(), util_1.Args.get_individual_mode()], cb, util_1.log);
    }
    exports.rpc_tryAndVerify = rpc_tryAndVerify;
    function rpc_instantiate(templates, lvlVars, // TODO: Should eventually not need this argument. Convert
        data, //       data to a dictionary containing variable names.
        cb) {
        let uniq_templates = util_1.unique(templates, (x) => eval_1.esprimaToStr(x[0]));
        console.log("Instantiating " + templates.length + " templates " +
            uniq_templates.length + " unique ones.");
        exports.rpc.call("App.instantiate", [uniq_templates, lvlVars, data, mturkId()], cb, util_1.log);
    }
    exports.rpc_instantiate = rpc_instantiate;
    function rpc_logEvent(workerId, name, data) {
        return exports.rpc.call("App.logEvent", [workerId, name, data, mturkId()], (res) => { }, util_1.log);
    }
    exports.rpc_logEvent = rpc_logEvent;
    function logEvent(name, data) {
        return rpc_logEvent(util_1.Args.get_worker_id(), name, data);
    }
    exports.logEvent = logEvent;
});
//# sourceMappingURL=rpc.js.map