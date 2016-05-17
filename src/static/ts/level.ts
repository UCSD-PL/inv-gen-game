class Level {
  constructor(public id: string,
    public variables: string[],
    public data:  dataT,
    public goal:  any,
    public hint:  string) {
  }
  static load(lvlSet: string, id: string, cb: (lvl: Level)=>void) {
    rpc.call('App.loadLvl', [lvlSet, id], function(data) {
      cb(new Level(id, data.variables, data.data, data.goal, data.hint))
    }, log)
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
    rpc.call('App.loadLvl', [lvlSet, id], function(data) {
      cb(new DynamicLevel(id, data.variables, data.data, data.goal, data.hint, data.exploration_state))
    }, log)
  }
}

class PrepopulatedDynamicLevel extends DynamicLevel {
  constructor(public id: string,
    variables: string[],
    data:  dataT,
    goal:  any,
    hint:  string,
    exploration_state: any,
    public startingInvs: [invariantT[], invariantT[], invariantT[]]) {
    super(id, variables, data, goal, hint, exploration_state);
  }

  static load(lvlSet: string, id: string, cb: (lvl: Level)=>void) {
    rpc.call('App.loadLvl', [lvlSet, id], function(data) {
      cb(new PrepopulatedDynamicLevel(id, data.variables, data.data, data.goal, data.hint, data.exploration_state, [[], [], []]))
    }, log)
  }
}
