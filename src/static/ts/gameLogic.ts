type voidCb = () => void
type boolCb = (res: boolean) => void
type invSoundnessResT = { ctrex: [any[], any[], any[]] }
declare var curLvlSet: string; // TODO: Remove hack
declare var progW: any;
declare var progW2: any;
declare var traceW: any;
declare var traceW2: any;
declare var allowBonus: boolean;

interface IGameLogic {
  clear(): void;
  loadLvl(lvl: Level): void;

  userInput(commit: boolean): void;
  goalSatisfied(cb: (sat: boolean, feedback: any) => void): void;

  onUserInput(cb: (inv: invariantT) => void): void;
  onLvlPassed(cb: () => void): void;
  onLvlLoaded(cb: () => void): void;
  onCommit(cb: () => void): void;
}

interface IDynGameLogic extends IGameLogic {
  clear(): void;
  loadLvl(lvl: Level): void;
  addData(data: dataT): void;
  invSound(inv: invariantT, cb: (sound: boolean, res: invSoundnessResT) => void): void;

  userInput(commit: boolean): void;
  goalSatisfied(cb: (sat: boolean, feedback: any) => void): void;

  onUserInput(cb: (inv: invariantT) => void): void;
  onLvlPassed(cb: () => void): void;
  onLvlLoaded(cb: () => void): void;
  onCommit(cb: () => void): void;
}

abstract class BaseGameLogic implements IGameLogic {
  curLvl: Level = null;
  lvlPassedCb: voidCb = null;
  lvlLoadedCb: voidCb = null;
  userInputCb: (inv: invariantT) => void = null;
  commitCb: voidCb = null;
  pwupSuggestion: IPowerupSuggestion = null;
  score: number = 0;

  constructor(public tracesW: ITracesWindow,
    public progressW: IProgressWindow,
    public scoreW: ScoreWindow,
    public stickyW: StickyWindow) {
    this.clear();
    let gl = this;
    this.tracesW.onChanged(function() {
      gl.userInput(false);
    });

    this.tracesW.onCommit(function() {
      gl.tracesW.msg("Trying out...");
      gl.tracesW.disable();
      gl.userInput(true);
      gl.tracesW.enable();
    });

    this.onUserInput(() => { });
    this.onLvlLoaded(() => { });
    this.onLvlPassed(() => { });
    this.onUserInput((x) => { });
  }

  clear(): void {
    this.tracesW.clearError();
    this.progressW.clear();
    this.stickyW.clear();
    // Leave score intact - don't clear score window
    this.curLvl = null;
  }

  loadLvl(lvl: Level): void {
    this.clear();
    this.curLvl = lvl;
    this.tracesW.setVariables(lvl);
    this.tracesW.addData(lvl.data);
    this.pwupSuggestion.clear(lvl);
    this.setPowerups(this.pwupSuggestion.getPwups());
    if (this.lvlLoadedCb)
      this.lvlLoadedCb();
  }

  protected computeScore(inv: string, s: number): number {
    let pwups = this.pwupSuggestion.getPwups();
    let hold = pwups.filter((pwup) => pwup.holds(inv));
    let newScore = hold.reduce((score, pwup) => pwup.transform(score), s);
    hold.forEach((pwup) => pwup.highlight(() => 0));
    return newScore;
  }

  protected setPowerups(new_pwups: IPowerup[]): void {
    let pwups = {};
    for (let i in new_pwups) {
      pwups[new_pwups[i].id] = new_pwups[i];
    }

    this.stickyW.set(new_pwups);
  }

  abstract userInput(commit: boolean): void
  abstract goalSatisfied(cb: (sat: boolean, feedback: any) => void): void;
  onUserInput(cb: (inv: invariantT) => void): void { this.userInputCb = cb; };
  onLvlPassed(cb: () => void): void { this.lvlPassedCb = cb; };
  onLvlLoaded(cb: () => void): void { this.lvlLoadedCb = cb; };
  onCommit(cb: () => void): void { this.commitCb = cb; };
}

class StaticGameLogic extends BaseGameLogic implements IGameLogic {
  foundJSInv: string[] = [];
  foundInv: string[] = [];
  lvlPassedF: boolean = false;

  constructor(public tracesW: ITracesWindow,
    public progressW: IProgressWindow,
    public scoreW: ScoreWindow,
    public stickyW: StickyWindow) {
    super(tracesW, progressW, scoreW, stickyW);
    this.pwupSuggestion = new PowerupSuggestionFullHistory(5, "lfu");
  }

  clear(): void {
    super.clear();
    this.foundJSInv = [];
    this.foundInv = [];
    this.lvlPassedF = false;
  }

  goalSatisfied(cb: (sat: boolean, feedback?: any) => void): void {
    let goal = this.curLvl.goal;
    if (goal == null) {
      cb(true);
    } else if (goal.manual) {
      cb(false);
    } else if (goal.find) {
      let numFound = 0;
      for (let i = 0; i < goal.find.length; i++) {
        let found = false;
        for (let j = 0; j < goal.find[i].length; j++) {
          if ($.inArray(goal.find[i][j], this.foundJSInv) !== -1) {
            found = true;
            break;
          }
        }

        if (found)
          numFound++;

      }

      cb(numFound === goal.find.length,
        { "find": { "found": numFound, "total": goal.find.length } });
    } else if (goal.equivalent) {
      equivalentPairs(goal.equivalent, this.foundJSInv, function(pairs) {
        let numFound = 0;
        let equiv = [];
        for (let i = 0; i < pairs.length; i++) {
          if (-1 === $.inArray(pairs[i][0], equiv))
            equiv.push(pairs[i][0]);
        }

        cb(equiv.length === goal.equivalent.length,
          { "equivalent": { "found": equiv.length, "total": goal.equivalent.length } });
      });
    } else if (goal.max_score) {
      cb(true, { "max_score": { "found": this.foundJSInv.length } });
    } else if (goal.none) {
      cb(false);
    } else if (goal.hasOwnProperty("atleast")) {
      cb(this.foundJSInv.length >= goal.atleast);
    } else {
      error("Unknown goal " + JSON.stringify(goal));
    }
  }

  userInput(commit: boolean): void {
    this.tracesW.disableSubmit();
    this.tracesW.clearError();
    this.progressW.clearMarks();

    let inv = invPP(this.tracesW.curExp().trim());
    let jsInv = invToJS(inv);

    this.userInputCb(inv);

    try {
      let parsedInv = esprima.parse(jsInv);
    } catch (err) {
      this.tracesW.delayedError(inv + " is not a valid expression.");
      return;
    }

    if (inv.length === 0) {
      this.tracesW.evalResult({ clear: true });
      return;
    }

    try {
      let pos_res = invEval(jsInv, this.curLvl.variables, this.curLvl.data[0]);
      let res: [any[], any[], [any, any][]] = [pos_res, [], []];
      this.tracesW.evalResult({ data: res });

      if (!evalResultBool(res))
        return;

      let redundant = this.progressW.contains(inv);
      if (redundant) {
        this.progressW.markInvariant(inv, "duplicate");
        this.tracesW.immediateError("Duplicate Invariant!");
        return;
      }

      let all = pos_res.length;
      let hold = pos_res.filter(function(x) { return x; }).length;

      if (hold < all)
        this.tracesW.error("Holds for " + hold + "/" + all + " cases.");
      else {
        this.tracesW.enableSubmit();
        if (!commit) {
          this.tracesW.msg("<span class='good'>Press Enter...</span>");
          return;
        }

        let gl = this;
        isTautology(invToJS(inv), function(res) {
          if (res) {
            gl.tracesW.error("This is a always true...");
            return;
          }

          impliedBy(gl.foundJSInv, jsInv, function(x: number) {
            if (x !== null) {
              gl.progressW.markInvariant(gl.foundInv[x], "implies");
              gl.tracesW.immediateError("This is weaker than a found expression!");
            } else {
              let addScore = gl.computeScore(jsInv, 1);

              gl.pwupSuggestion.invariantTried(jsInv);
              setTimeout(() => gl.setPowerups(gl.pwupSuggestion.getPwups()), 1000); // TODO: Remove hack

              gl.score += addScore;
              gl.scoreW.add(addScore);
              gl.foundInv.push(inv);
              gl.foundJSInv.push(jsInv);
              gl.progressW.addInvariant(inv);
              gl.tracesW.setExp("");
              if (!gl.lvlPassedF) {
                gl.goalSatisfied((sat, feedback) => {
                  let lvl = gl.curLvl;
                  if (sat) {
                    gl.lvlPassedF = true;
                    gl.lvlPassedCb();
                  }
                });
              }
            }
          });
        });
      }

    } catch (err) {
      this.tracesW.delayedError(<string>interpretError(err));
    }
  }
}

class CounterexampleGameLogic extends BaseGameLogic implements IDynGameLogic {
  foundJSInv: string[] = [];
  foundInv: string[] = [];
  soundInvs: string[] = [];
  overfittedInvs: string[] = [];
  nonindInvs: string[] = [];
  lvlPassedF: boolean = false;

  constructor(public tracesW: CounterExampleTracesWindow,
    public progressW: IProgressWindow,
    public scoreW: ScoreWindow,
    public stickyW: StickyWindow) {
    super(tracesW, progressW, scoreW, stickyW);
    this.pwupSuggestion = new PowerupSuggestionFullHistory(5, "lfu");
  }

  clear(): void {
    super.clear();
    this.tracesW.clearData(0);
    this.tracesW.clearData(1);
    this.tracesW.clearData(2);
    this.foundJSInv = [];
    this.foundInv = [];
    this.nonindInvs = [];
    this.overfittedInvs = [];
    this.soundInvs = [];
    this.lvlPassedF = false;
  }

  addData(data: dataT): void {
    for (let i in [0, 1]) {
      this.curLvl.data[i] = this.curLvl.data[i].concat(data[i]);
    }
    this.curLvl.data[2] = this.curLvl.data[2].concat(data[2].reduce((a, b) => a.concat(b), []));
    this.tracesW.addData(data);
  }

  invSound(inv: invariantT, cb: (sound: boolean, res: invSoundnessResT) => void): void {
    let invs = this.soundInvs.concat([inv]);
    let gl = this;
    pre_vc_ctrex(curLvlSet, this.curLvl.id, invs, function(pos_res) {
      if (pos_res.length !== 0) {
        cb(false, { ctrex: [pos_res, [], []] });
      } else {
        ind_vc_ctrex(curLvlSet, gl.curLvl.id, invs, function(ind_res) {
          cb(ind_res.length === 0, { ctrex: [[], [], ind_res] });
        });
      }
    });
  }

  goalSatisfied(cb: (sat: boolean, feedback: any) => void): void {
    if (this.soundInvs.length > 0) {
      counterexamples(curLvlSet, this.curLvl.id, this.soundInvs, (res: dataT) => {
        let pos = res[0], neg = res[1], ind = res[2];
        cb(pos.length === 0 && neg.length === 0 && ind.length === 0, res);
      });
    } else {
      cb(false, [[], [], []]);
    }
  }

  userInput(commit: boolean): void {
    this.tracesW.disableSubmit();
    this.tracesW.clearError();
    this.progressW.clearMarks();

    let inv = invPP(this.tracesW.curExp().trim());
    let jsInv = invToJS(inv);

    this.userInputCb(inv);

    try {
      let parsedInv = esprima.parse(jsInv);
    } catch (err) {
      this.tracesW.delayedError(inv + " is not a valid expression.");
      return;
    }

    if (inv.length === 0) {
      this.tracesW.evalResult({ clear: true });
      return;
    }

    try {
      let pos_res = invEval(jsInv, this.curLvl.variables, this.curLvl.data[0]);
      let neg_res = invEval(jsInv, this.curLvl.variables, this.curLvl.data[1]);
      let raw_ind_res = invEval(jsInv, this.curLvl.variables, this.curLvl.data[2]);

      // Pair the inductive results
      let ind_res = zip(raw_ind_res.filter((_, i) => i % 2 === 0), raw_ind_res.filter((_, i) => i % 2 === 1));
      let res: [any[], any[], [any, any][]] = [pos_res, neg_res, ind_res];
      this.tracesW.evalResult({ data: res });

      if (!evalResultBool(res))
        return;

      let redundant = this.progressW.contains(inv);
      if (redundant) {
        this.progressW.markInvariant(inv, "duplicate");
        this.tracesW.immediateError("Duplicate Invariant!");
        return;
      }

      let all = pos_res.length + neg_res.length + ind_res.length;
      let hold_pos = pos_res.filter(function(x) { return x; }).length;
      let hold_neg = neg_res.filter(function(x) { return !x; }).length;
      let ind_choices = this.tracesW.switches.map(x => x.pos);
      let hold_ind = zip(ind_choices, ind_res).filter(function(x) {
        if (x[0] === 0)
          return !x[1][0];
        else
          return x[1][0] && x[1][1];
      }).length;
      let hold = hold_pos + hold_neg + hold_ind;

      if (hold < all)
        this.tracesW.error("Holds for " + hold + "/" + all + " cases.");
      else {
        this.tracesW.enableSubmit();
        if (!commit) {
          this.tracesW.msg("<span class='good'>Press Enter...</span>");
          return;
        }

        let gl = this;
        isTautology(invToJS(inv), function(res) {
          if (res) {
            gl.tracesW.error("This is a always true...");
            return;
          }

          impliedBy(gl.foundJSInv, jsInv, function(x: number) {
            if (x !== null) {
              gl.progressW.markInvariant(gl.foundInv[x], "implies");
              gl.tracesW.immediateError("This is weaker than a found expression!");
            } else {
              gl.pwupSuggestion.invariantTried(jsInv);
              gl.setPowerups(gl.pwupSuggestion.getPwups());

              gl.invSound(jsInv, function(sound, res) {
                if (res.ctrex[0].length !== 0) {
                  gl.overfittedInvs.push(jsInv);
                } else if (res.ctrex[2].length !== 0) {
                  gl.nonindInvs.push(jsInv);
                } else {
                  gl.soundInvs.push(jsInv);
                }

                if (sound) {
                  let addScore = gl.computeScore(jsInv, 1);
                  gl.score += addScore;
                  gl.scoreW.add(addScore);
                  gl.foundInv.push(inv);
                  gl.foundJSInv.push(jsInv);
                  gl.progressW.addInvariant(inv);
                  gl.tracesW.setExp("");
                  if (!gl.lvlPassedF) {
                    gl.goalSatisfied((sat, feedback) => {
                      let lvl = gl.curLvl;
                      if (sat) {
                        gl.lvlPassedF = true;
                        gl.lvlPassedCb();
                      }
                    });
                  }
                } else {
                  gl.addData(res.ctrex);
                  gl.userInput(false);
                }
              });
            }
          });
        });
      }

    } catch (err) {
      this.tracesW.delayedError(<string>interpretError(err));
    }
  }
}

class TutorialCounterexampleGameLogic extends CounterexampleGameLogic {
  invSoundCb: (inv: invariantT, cb: (res: invSoundnessResT) => void) => void = null;
  onInvSound(cb: (inv: invariantT, cb: (res: invSoundnessResT) => void) => void) {
    this.invSoundCb = cb;
  }

  invSound(inv, cb) {
    if (this.invSoundCb)
      this.invSoundCb(inv, cb);
  }

  goalSatisfied(cb: (sat: boolean, feedback?: any) => void): void {
    let goal = this.curLvl.goal;
    if (goal.none) {
      cb(false);
    } else if (goal.hasOwnProperty("atleast")) {
      cb(this.foundJSInv.length >= goal.atleast);
    } else {
      error("Unknown goal " + JSON.stringify(goal));
    }
  }
}

class MultiroundGameLogic extends BaseGameLogic {
  foundJSInv: string[] = [];
  foundInv: string[] = [];
  soundInvs: string[] = [];
  overfittedInvs: string[] = [];
  nonindInvs: string[] = [];
  lvlPassedF: boolean = false;

  constructor(public tracesW: ITracesWindow,
    public progressW: IProgressWindow,
    public scoreW: ScoreWindow,
    public stickyW: StickyWindow) {
    super(tracesW, progressW, scoreW, stickyW);
    this.pwupSuggestion = new PowerupSuggestionFullHistory(5, "lfu");
  }

  clear(): void {
    super.clear();
    this.foundJSInv = [];
    this.foundInv = [];
    this.nonindInvs = [];
    this.overfittedInvs = [];
    this.soundInvs = [];
    this.lvlPassedF = false;
  }

  invSound(inv: invariantT, cb: (sound: boolean, res: invSoundnessResT) => void): void {
    let invs = this.soundInvs.concat([inv]);
    let gl = this;
    pre_vc_ctrex(curLvlSet, this.curLvl.id, invs, function(pos_res) {
      if (pos_res.length !== 0) {
        cb(false, { ctrex: [pos_res, [], []] });
      } else {
        ind_vc_ctrex(curLvlSet, gl.curLvl.id, invs, function(ind_res) {
          cb(ind_res.length === 0, { ctrex: [[], [], ind_res] });
        });
      }
    });
  }

  goalSatisfied(cb: (sat: boolean, feedback: any) => void): void {
    if (this.soundInvs.length > 0) {
      counterexamples(curLvlSet, this.curLvl.id, this.soundInvs, (res: dataT) => {
        let pos = res[0], neg = res[1], ind = res[2];
        cb(pos.length === 0 && neg.length === 0 && ind.length === 0, res);
      });
    } else {
      cb(false, [[], [], []]);
    }
  }

  userInput(commit: boolean): void {
    this.tracesW.disableSubmit();
    this.tracesW.clearError();
    this.progressW.clearMarks();

    let inv = invPP(this.tracesW.curExp().trim());
    let jsInv = invToJS(inv);

    this.userInputCb(inv);

    try {
      let parsedInv = esprima.parse(jsInv);
    } catch (err) {
      this.tracesW.delayedError(inv + " is not a valid expression.");
      return;
    }

    if (inv.length === 0) {
      this.tracesW.evalResult({ clear: true });
      return;
    }

    try {
      let pos_res = invEval(jsInv, this.curLvl.variables, this.curLvl.data[0]);
      let res: [any[], any[], [any, any][]] = [pos_res, [], []];
      this.tracesW.evalResult({ data: res });

      if (!evalResultBool(res))
        return;

      let redundant = this.progressW.contains(inv);
      if (redundant) {
        this.progressW.markInvariant(inv, "duplicate");
        this.tracesW.immediateError("Duplicate Invariant!");
        return;
      }

      let all = pos_res.length;
      let hold = pos_res.filter(function(x) { return x; }).length;

      if (hold < all)
        this.tracesW.error("Holds for " + hold + "/" + all + " cases.");
      else {
        this.tracesW.enableSubmit();
        if (!commit) {
          this.tracesW.msg("<span class='good'>Press Enter...</span>");
          return;
        }

        let gl = this;
        isTautology(invToJS(inv), function(res) {
          if (res) {
            gl.tracesW.error("This is a always true...");
            return;
          }

          impliedBy(gl.foundJSInv, jsInv, function(x: number) {
            if (x !== null) {
              gl.progressW.markInvariant(gl.foundInv[x], "implies");
              gl.tracesW.immediateError("This is weaker than a found expression!");
            } else {
              gl.pwupSuggestion.invariantTried(jsInv);
              gl.setPowerups(gl.pwupSuggestion.getPwups());

              gl.invSound(jsInv, function(sound, res) {
                if (res.ctrex[0].length !== 0) {
                  gl.overfittedInvs.push(jsInv);
                } else if (res.ctrex[2].length !== 0) {
                  gl.nonindInvs.push(jsInv);
                } else {
                  gl.soundInvs.push(jsInv);
                }

                if (sound) {
                  let addScore = gl.computeScore(jsInv, 1);
                  gl.score += addScore;
                  gl.scoreW.add(addScore);
                  gl.foundInv.push(inv);
                  gl.foundJSInv.push(jsInv);
                  gl.progressW.addInvariant(inv);
                  gl.tracesW.setExp("");
                  if (!gl.lvlPassedF) {
                    gl.goalSatisfied((sat, feedback) => {
                      let lvl = gl.curLvl;
                      if (sat) {
                        gl.lvlPassedF = true;
                        gl.lvlPassedCb();
                      } else {
                        let lvl = gl.curLvl;
                        rpc.call("App.getPositiveExamples", [curLvlSet,
                          lvl.id, /* lvl.exploration_state, */
                          gl.overfittedInvs.map(esprima.parse), 5], (data) => {
                            /*
                            let templates = foundJSInv.map(abstractLiterals)
                            rpc.call("App.instantiate", [templates, lvl.variables, data[1]],
                            (invs) => {
                              invs = invs.map((inv) => inv.substring(1, inv.length - 1))
                              invs = invs.filter( (item, ind) => invs.indexOf(item) == ind )
                              var newLvl = new Level(lvl.id,
                                lvl.variables, [data[1], [], []], data[0], lvl.goal,
                                lvl.hint,invs)
                              // TODO: CB for new level unlocked
                              gl.lvlPassedF = true;
                              gl.lvlPassed();
                            })
                            */
                          }, log);
                      }
                    });
                  }
                } else {
                }
              });
            }
          });
        });
      }

    } catch (err) {
      this.tracesW.delayedError(<string>interpretError(err));
    }
  }
}

abstract class TwoPlayerBaseGameLogic implements IGameLogic {
  curLvl: Level = null;
  lvlPassedCb: voidCb = null;
  lvlLoadedCb: voidCb = null;
  userInputCb: (inv: invariantT) => void = null;
  commitCb: voidCb = null;
  pwupSuggestion: IPowerupSuggestion = null;
  score: number = 0;
  player: number = null;

  constructor(public playerNum: number,
    public tracesW: ITracesWindow,
    public progressW: IProgressWindow,
    public scoreW: TwoPlayerScoreWindow,
    public stickyW: TwoPlayerStickyWindow) {
    this.clear();
    this.player = playerNum;
    let gl = this;
    this.tracesW.onChanged(function() {
      gl.userInput(false);
    });

    this.tracesW.onCommit(function() {
      gl.tracesW.msg("Trying out...");
      gl.tracesW.disable();
      gl.userInput(true);
      gl.tracesW.enable();
    });

    this.onUserInput(() => { });
    this.onLvlLoaded(() => { });
    this.onLvlPassed(() => { });
    this.onUserInput((x) => { });
  }

  clear(): void {
    this.tracesW.clearError();
    this.progressW.clear();
    this.stickyW.clear();
    // Leave score intact - don't clear score window
    this.curLvl = null;
  }

  loadLvl(lvl: Level): void {
    this.clear();
    this.curLvl = lvl;
    this.tracesW.setVariables(lvl);
    this.tracesW.addData(lvl.data);
    this.pwupSuggestion.clear(lvl);
    this.setPowerups(this.pwupSuggestion.getPwups());
    if (this.lvlLoadedCb)
      this.lvlLoadedCb();
  }

  protected computeScore(inv: string, s: number): number {
    let pwups = this.pwupSuggestion.getPwups();
    let hold = pwups.filter((pwup) => pwup.holds(inv));
    let newScore = hold.reduce((score, pwup) => pwup.transform(score), s);
    hold.forEach((pwup) => pwup.highlight(() => 0));
    return newScore;
  }

  protected setPowerups(new_pwups: IPowerup[]): void {
    let pwups = {};
    for (let i in new_pwups) {
      pwups[new_pwups[i].id] = new_pwups[i];
    }

    this.stickyW.set(new_pwups);
  }

  abstract userInput(commit: boolean): void
  abstract goalSatisfied(cb: (sat: boolean, feedback: any) => void): void;
  onUserInput(cb: (inv: invariantT) => void): void { this.userInputCb = cb; };
  onLvlPassed(cb: () => void): void { this.lvlPassedCb = cb; };
  onLvlLoaded(cb: () => void): void { this.lvlLoadedCb = cb; };
  onCommit(cb: () => void): void { this.commitCb = cb; };
}

class TwoPlayerGameLogic extends TwoPlayerBaseGameLogic implements IGameLogic {
  foundJSInv: string[] = [];
  foundInv: string[] = [];
  lvlPassedF: boolean = false;

  constructor(public playerNum: number,
    public tracesW: ITracesWindow,
    public progressW: IProgressWindow,
    public scoreW: TwoPlayerScoreWindow,
    public stickyW: TwoPlayerStickyWindow) {
    super(playerNum, tracesW, progressW, scoreW, stickyW);
    this.pwupSuggestion = new TwoPlayerPowerupSuggestionFullHistory(playerNum, 5, "lfu");
    // this.tracesW = tracesW;
  }

  clear(): void {
    super.clear();
    this.foundJSInv = [];
    this.foundInv = [];
    this.lvlPassedF = false;
  }

  showNext(lvl): boolean {
    let goal = lvl.goal;
    if (goal == null) {
      return true;
    }
    else if (goal.manual) {
      return true;
    }
    return false;
  }

  goalSatisfied(cb: (sat: boolean, feedback?: any) => void): void {
    let goal = this.curLvl.goal;

    let player1Invs: string[] = getAllPlayer1Inv();
    let player2Invs: string[] = getAllPlayer2Inv();

    let allInvs = player1Invs.concat(player2Invs);

    if (goal == null) {
      cb(true);
    } else if (goal.manual) {
      cb(false);
    } else if (goal.find) {
      let numFound = 0;
      for (let i = 0; i < goal.find.length; i++) {
        let found = false;
        for (let j = 0; j < goal.find[i].length; j++) {
          // check for the union of both players' invariants
          // if ($.inArray(goal.find[i][j], this.foundJSInv) !== -1) {
          if ($.inArray(goal.find[i][j], allInvs) !== -1) {
            found = true;
            break;
          }
        }

        if (found)
          numFound++;

      }

      cb(numFound === goal.find.length,
        { "find": { "found": numFound, "total": goal.find.length } });
    } else if (goal.equivalent) {
      // check for the union of both players' invariants
      // equivalentPairs(goal.equivalent, this.foundJSInv, function(pairs) {
      equivalentPairs(goal.equivalent, allInvs, function(pairs) {
        let numFound = 0;
        let equiv = [];
        for (let i = 0; i < pairs.length; i++) {
          if (-1 === $.inArray(pairs[i][0], equiv))
            equiv.push(pairs[i][0]);
        }

        cb(equiv.length === goal.equivalent.length,
          { "equivalent": { "found": equiv.length, "total": goal.equivalent.length } });
      });
    } else if (goal.max_score) {
      cb(true, { "max_score": { "found": this.foundJSInv.length } });
    } else if (goal.none) {
      cb(false);
    } else if (goal.hasOwnProperty("atleast")) {
      // check for the union of both players' invariants
      // cb(this.foundJSInv.length >= goal.atleast);
      cb(allInvs.length >= goal.atleast);
    } else {
      error("Unknown goal " + JSON.stringify(goal));
    }
  }

  userInput(commit: boolean): void {
    this.tracesW.disableSubmit();
    this.tracesW.clearError();
    this.progressW.clearMarks();

    traceW.clearError();
    traceW2.clearError();

    progW.clearMarks();
    progW2.clearMarks();

    let inv = invPP(this.tracesW.curExp().trim());
    let jsInv = invToJS(inv);

    this.userInputCb(inv);

    try {
      let parsedInv = esprima.parse(jsInv);
    } catch (err) {
      this.tracesW.delayedError(inv + " is not a valid expression.");
      return;
    }

    if (inv.length === 0) {
      this.tracesW.evalResult({ clear: true });
      return;
    }

    try {
      let doProceed = true;
      let pos_res = invEval(jsInv, this.curLvl.variables, this.curLvl.data[0]);
      let res: [any[], any[], [any, any][]] = [pos_res, [], []];
      this.tracesW.evalResult({ data: res });

      if (!evalResultBool(res))
        return;

      let redundant = this.progressW.contains(inv);
      if (redundant) {
        this.progressW.markInvariant(inv, "duplicate");
        this.tracesW.immediateError("Duplicate Invariant!");
        doProceed = false;
        return;
      }


      if (this.player === 1) {
        if (progW2.contains(inv)) {
          progW2.markInvariant(inv, "duplicate");
          traceW.immediateError("Duplicate Invariant!");
          doProceed = false;
          return;
        }

        let player2Invs: string[] = getAllPlayer2Inv();

        if (player2Invs.length !== 0) {
          equivalentPairs([jsInv], player2Invs, function(x: any) {
            if (x != null && typeof player2Invs[x] !== "undefined") {
              // console.log(jsInv + " <=> " + player2Invs[x]);
              progW2.markInvariant(player2Invs[x], "duplicate");
              traceW.immediateError("Duplicate Invariant!");
              traceW.disableSubmit();
              doProceed = false;
              return;
            }
            else {
              impliedBy(player2Invs, jsInv, function(x: any) {
                if (x !== null) {
                  // console.log(player2Invs[x] + " ==> " + jsInv);
                  progW2.markInvariant(player2Invs[x], "implies");
                  traceW.immediateError("Implied by opponent's invariant!");
                  traceW.disableSubmit();
                  doProceed = false;
                  return;
                }
              });
            }

          });
        }
      }

      else if (this.player === 2) {
        if (progW.contains(inv)) {
          progW.markInvariant(inv, "duplicate");
          traceW2.immediateError("Duplicate Invariant!");
          doProceed = false;
          return;
        }

        let player1Invs: string[] = getAllPlayer1Inv();

        if (player1Invs.length !== 0) {

          equivalentPairs([jsInv], player1Invs, function(x) {
            if (x != null && typeof player1Invs[x] !== "undefined") {
              // console.log(jsInv + " <=> " + player1Invs[x]);
              progW.markInvariant(player1Invs[x], "duplicate");
              traceW2.immediateError("Duplicate Invariant!");
              traceW2.disableSubmit();
              doProceed = false;
              return;
            }

            else {
              impliedBy(player1Invs, jsInv, function(x: any) {
                if (x !== null) {
                  // console.log(player1Invs[x] + " ==> " + jsInv);
                  progW.markInvariant(player1Invs[x], "implies");
                  traceW2.immediateError("Implied by opponent's invariant!");
                  traceW2.disableSubmit();
                  doProceed = false;
                  return;
                }
              });
            }
          });
        }
      }


      let all = pos_res.length;
      let hold = pos_res.filter(function(x) { return x; }).length;

      if (hold < all) {
        this.tracesW.error("Holds for " + hold + "/" + all + " cases.");
        doProceed = false;
      }
      else {
        let gl = this;
        isTautology(jsInv, function(res) {
          if (res) {
            gl.tracesW.error("This is a always true...");
            gl.tracesW.disableSubmit();
            doProceed = false;
            return;
          }

          impliedBy(gl.foundJSInv, jsInv, function(x: number) {
            if (x !== null) {
              gl.progressW.markInvariant(gl.foundInv[x], "implies");
              gl.tracesW.immediateError("Implied by existing invariant!");
              // console.log(gl.foundInv[x] + " ==> " + jsInv);
              doProceed = false;
            }
            else {
              if (doProceed === true) {
                gl.tracesW.enableSubmit();
                if (!commit) {
                  gl.tracesW.msg("Press Enter...");
                  return;
                }

                let addScore = gl.computeScore(jsInv, 1);

                gl.pwupSuggestion.invariantTried(jsInv);
                setTimeout(() => gl.setPowerups(gl.pwupSuggestion.getPwups()), 1000); // TODO: Remove hack

                gl.score += addScore;
                gl.scoreW.add(addScore);
                gl.foundInv.push(inv);
                gl.foundJSInv.push(jsInv);
                gl.progressW.addInvariant(inv);
                gl.tracesW.setExp("");

                if (allowBonus) {
                  getBonus(this.player, function(pt) {
                    gl.scoreW.add(pt);
                  });
                }
              }

              if (!gl.lvlPassedF) {
                gl.goalSatisfied((sat, feedback) => {
                  let lvl = gl.curLvl;
                  if (sat) {
                    gl.lvlPassedF = true;
                    gl.lvlPassedCb();
                  }
                });
              }
            }
          });
        });
      }

    } catch (err) {
      this.tracesW.delayedError(<string>interpretError(err));
    }
  }
}
