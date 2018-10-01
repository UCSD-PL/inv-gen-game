import {rpc_loadLvl, rpc_loadNextLvl, rpc_loadNextLvlAnon } from "./rpc";
import {Args} from "./util";
import {dataT, invariantT, TypeEnv} from "./types";

export class Level {
  constructor(public id: string,
    public variables: string[],
    public data: dataT,
    public hint: any,
    public colSwap: any,
    public goal: any,
    public typeEnv: TypeEnv,
      public startingInvs: [string, invariantT][]) {
  }
  static load(lvlSet: string, id: string, cb: (lvl: Level) => void) {
    rpc_loadLvl(lvlSet, id, function(data) {
      cb(new Level(id, data.variables, data.data, data.hint, data.colSwap, data.goal, data.typeEnv, data.startingInvs));
    });
  }

    static localLevelPosition:number = 1;

    static loadNextAnon(cb: (res: [string, Level, boolean]) => void) {
        rpc_loadNextLvlAnon(Args.get_worker_id(), Level.localLevelPosition, function (data) {
        if (data === null)
            cb(null);
        else {
            Level.localLevelPosition = Level.localLevelPosition + 1;
            let lvl = new Level(data.id, data.variables, data.data, data.hint, data.colSwap, data.goal, data.typeEnv, data.startingInvs);
            if (data.ShowQuestionaire === true) {
                cb([data.lvlSet, lvl, true]);
            } else {
                cb([data.lvlSet, lvl, false]);
            }
        }
    });
}


  static loadNext(cb: (res: [string, Level, boolean])=>void) {
    rpc_loadNextLvl(Args.get_worker_id(), function(data) {
      if (data === null)
        cb(null);
      else {
        let lvl = new Level(data.id, data.variables, data.data, data.hint, data.colSwap, data.goal, data.typeEnv, data.startingInvs);
          if (data.ShowQuestionaire === true) {
              cb([data.lvlSet, lvl, true]);
          } else {
              cb([data.lvlSet, lvl, false]);
          }
      }
    });
  }

  isReplay(): boolean {
    return this.startingInvs.length > 0;
  }
}