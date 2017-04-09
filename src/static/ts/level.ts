class Level {
  constructor(public id: string,
    public variables: string[],
    public data: dataT,
    public goal: any,
    public hint: string) {
  }
  static load(lvlSet: string, id: string, cb: (lvl: Level) => void) {
    rpc_loadLvlBasic(lvlSet, id, function(data) {
      cb(new Level(id, data.variables, data.data, data.goal, data.hint));
    });
  }
}

class DynamicLevel extends Level{
  constructor(public id: string,
    public variables: string[],
    public data:  dataT,
    public goal:  any,
    public hint:  string,
    public exploration_state: any) {
    super(id, variables, data, goal, hint);
  }

  static load(lvlSet: string, id: string, cb: (lvl: Level)=>void) {
    rpc_loadLvlDynamic(lvlSet, id, function(data) {
      cb(new DynamicLevel(id, data.variables, data.data, data.goal, data.hint, data.exploration_state))
    })
  }
}

class PrepopulatedDynamicLevel extends DynamicLevel {
  constructor(public id: string,
    variables: string[],
    data:  dataT,
    goal:  any,
    hint:  string,
    exploration_state: any,
    public startingInvs: [[invariantT, any[]][], [invariantT, [any[], any[]]][], invariantT[]]) {
    super(id, variables, data, goal, hint, exploration_state);
  }

  static load(lvlSet: string, id: string, cb: (lvl: Level)=>void) {
    rpc_loadLvlDynamic(lvlSet, id, function(data) {
      cb(new PrepopulatedDynamicLevel(id, data.variables, data.data, data.goal, data.hint, data.exploration_state, [[], [], []]))
    })
  }

  static loadNext(cb: (res: [string, Level])=>void) {
    rpc_loadNextLvlDynamic(Args.get_worker_id(), function(data) {
      if (data === null)
        cb(null)
      else {
        let lvl = new PrepopulatedDynamicLevel(data.id, data.variables, data.data, data.goal, data.hint, data.exploration_state, [[], [], []]);
        cb([data.lvlSet, lvl]);
      }
    })
  }

}
