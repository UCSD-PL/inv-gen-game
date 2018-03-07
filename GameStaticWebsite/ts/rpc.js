/* This file defines the RPC interface between server and client */
function mturkId() {
    return [Args.get_worker_id(), Args.get_hit_id(), Args.get_assignment_id()];
}
function rpc_loadLvlBasic(lvlSet, id, cb) {
    rpc.call("App.loadLvl", [lvlSet, id, mturkId()], (data) => cb(data), log);
}
function rpc_loadLvlDynamic(lvlSet, id, cb) {
    rpc.call("App.loadLvl", [lvlSet, id, mturkId()], (data) => cb(data), log);
}
function rpc_loadNextLvlDynamic(workerkId, cb) {
    rpc.call("App.loadNextLvl", [workerkId, mturkId(), Args.get_individual_mode()], (data) => cb(data), log);
}
function rpc_genNextLvlDynamic(workerkId, lvlSet, lvlId, invs, cb) {
    rpc.call("App.genNextLvl", [workerkId, mturkId(), lvlSet, lvlId, invs, Args.get_individual_mode()], (data) => cb(data), log);
}
function rpc_equivalentPairs(invL1, invL2, cb) {
    rpc.call("App.equivalentPairs", [invL1, invL2, mturkId()], cb, log);
}
function rpc_impliedPairs(invL1, invL2, cb) {
    rpc.call("App.impliedPairs", [invL1, invL2, mturkId()], cb, log);
}
function rpc_isTautology(inv, cb) {
    rpc.call("App.isTautology", [inv, mturkId()], cb, log);
}
function rpc_simplify(inv, cb) {
    rpc.call("App.simplifyInv", [esprima.parse(inv), mturkId()], cb, log);
}
function rpc_tryAndVerify(lvlSet, lvlId, invs, cb) {
    rpc.call("App.tryAndVerify", [lvlSet, lvlId, invs, mturkId(), Args.get_individual_mode()], cb, log);
}
function rpc_instantiate(templates, lvlVars, // TODO: Should eventually not need this argument. Convert
    data, //       data to a dictionary containing variable names.
    cb) {
    let uniq_templates = unique(templates, (x) => esprimaToStr(x[0]));
    console.log("Instantiating " + templates.length + " templates " +
        uniq_templates.length + " unique ones.");
    rpc.call("App.instantiate", [uniq_templates, lvlVars, data, mturkId()], cb, log);
}
function rpc_logEvent(workerId, name, data) {
    return rpc.call("App.logEvent", [workerId, name, data, mturkId()], (res) => { }, log);
}
//# sourceMappingURL=rpc.js.map