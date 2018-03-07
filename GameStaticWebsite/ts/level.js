class Level {
    constructor(id, variables, data, goal, hint, colSwap, startingInvs) {
        this.id = id;
        this.variables = variables;
        this.data = data;
        this.goal = goal;
        this.hint = hint;
        this.colSwap = colSwap;
        this.startingInvs = startingInvs;
    }
    static load(lvlSet, id, cb) {
        rpc_loadLvlBasic(lvlSet, id, function (data) {
            cb(new Level(id, data.variables, data.data, data.goal, data.hint, data.colSwap, data.startingInvs));
        });
    }
    isReplay() {
        return this.startingInvs.length > 0;
    }
}
class DynamicLevel extends Level {
    constructor(id, variables, data, goal, hint, colSwap, startingInvs, exploration_state) {
        super(id, variables, data, goal, hint, colSwap, startingInvs);
        this.id = id;
        this.variables = variables;
        this.data = data;
        this.goal = goal;
        this.hint = hint;
        this.colSwap = colSwap;
        this.startingInvs = startingInvs;
        this.exploration_state = exploration_state;
    }
    static load(lvlSet, id, cb) {
        rpc_loadLvlDynamic(lvlSet, id, function (data) {
            cb(new DynamicLevel(id, data.variables, data.data, data.goal, data.hint, data.colSwap, data.startingInvs, data.exploration_state));
        });
    }
    static loadNext(cb) {
        rpc_loadNextLvlDynamic(Args.get_worker_id(), function (data) {
            if (data === null)
                cb(null);
            else {
                let lvl = new DynamicLevel(data.id, data.variables, data.data, data.goal, data.hint, data.colSwap, data.startingInvs, data.exploration_state);
                cb([data.lvlSet, lvl]);
            }
        });
    }
}
//# sourceMappingURL=level.js.map