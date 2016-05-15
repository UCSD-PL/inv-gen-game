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
