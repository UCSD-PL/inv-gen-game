type voidCb = ()=>void
type boolCb = (res: boolean)=>void
type invSoundnessResT = { ctrex: [ any[], any[], any[] ]}
type invariantT = ESTree.Node;
type templateT = [ invariantT, string[], string[] ]

declare var curLvlSet: string; // TODO: Remove hack
declare var progW: any;
declare var progW2: any;
declare var traceW: any;
declare var traceW2: any;
declare var allowBonus: boolean;

class UserInvariant {
  public rawInv: invariantT;
  public archetype: templateT;
  public id: string;
  public archetypeId: string;

  constructor(public rawUserInp: string,
              public rawJS: string,
              public canonForm: invariantT) {
    this.rawInv = esprima.parse(rawJS);
    this.archetype = generalizeInv(canonForm);
    this.archetypeId = esprimaToStr(this.archetype[0]);
    this.id = esprimaToStr(this.canonForm);
  }
}

interface IGameLogic {
  clear(): void;
  loadLvl(lvl: Level): void;

  userInput(commit: boolean): void;
  goalSatisfied(cb: (sat: boolean, feedback: any) => void): void;

  onUserInput(cb: (inv:string)=>void): void;
  onLvlPassed(cb: ()=>void): void;
  onLvlLoaded(cb: ()=>void): void;
  onCommit(cb: ()=>void): void;
}

interface IDynGameLogic extends IGameLogic {
  clear(): void;
  loadLvl(lvl: Level): void;
  addData(data: dataT): void;
  invSound(inv: UserInvariant, cb: (sound: boolean, res:invSoundnessResT)=>void): void;

  userInput(commit: boolean): void;
  goalSatisfied(cb: (sat: boolean, feedback: any) => void): void;

  onUserInput(cb: (inv:string)=>void): void;
  onLvlPassed(cb: ()=>void): void;
  onLvlLoaded(cb: ()=>void): void;
  onCommit(cb: ()=>void): void;
}

abstract class BaseGameLogic implements IGameLogic {
  curLvl: Level = null;
  lvlPassedCb: voidCb = null;
  lvlLoadedCb: voidCb = null;
  userInputCb: (inv:string)=> void = null;
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

  protected computeScore(inv: invariantT, s: number): number {
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

    this.stickyW.setPowerups(new_pwups);
  }

  abstract userInput(commit: boolean): void
  abstract goalSatisfied(cb:(sat: boolean, feedback: any)=>void):void;
  onUserInput(cb: (inv: string)=>void): void { this.userInputCb = cb; };
  onLvlPassed(cb: ()=>void): void { this.lvlPassedCb = cb; };
  onLvlLoaded(cb: ()=>void): void { this.lvlLoadedCb = cb; };
  onCommit(cb: ()=>void): void { this.commitCb = cb; };
}

class StaticGameLogic extends BaseGameLogic implements IGameLogic {
  foundJSInv: UserInvariant[] = [];
  lvlPassedF: boolean = false;

  constructor(public tracesW: ITracesWindow,
              public progressW: IProgressWindow,
              public scoreW: ScoreWindow,
              public stickyW: StickyWindow,
              numBonuses: number = 5) {
    super(tracesW, progressW, scoreW, stickyW);
    this.pwupSuggestion = new PowerupSuggestionFullHistory(numBonuses, "lfu");
  }

  clear(): void {
    super.clear();
    this.foundJSInv = [];
    this.lvlPassedF = false;
  }

  goalSatisfied(cb: (sat: boolean, feedback?: any) => void): void {
    let goal = this.curLvl.goal;
    if (goal == null) {
      cb(true)
    } else  if (goal.equivalent) {
      assert(goal.equivalent.length > 0);
      let eq_exp:(string[]|ESTree.Node[]) = goal.equivalent
      if (typeof(eq_exp[0]) == "string") {
        eq_exp = (<string[]>eq_exp).map(esprima.parse);
      }
      equivalentPairs(<ESTree.Node[]>eq_exp, this.foundJSInv.map((x)=>x.canonForm), function(pairs) {
        var numFound = 0;
        var equiv = []
        for (var i=0; i < pairs.length; i++) {
          if (-1 == $.inArray(pairs[i][0], equiv))
            equiv.push(pairs[i][0])
        }

        cb(equiv.length == goal.equivalent.length,
           { "equivalent": { "found": equiv.length , "total": goal.equivalent.length } })
      })
    } else if (goal.hasOwnProperty('atleast')) {
      cb(this.foundJSInv.length >= goal.atleast)
    } else if (goal.hasOwnProperty("none")) {
      cb(false)
    } else {
      error("Unknown goal " + JSON.stringify(goal));
    }
  }

  userInput(commit: boolean): void {
    this.tracesW.disableSubmit();
    this.tracesW.clearError();
    this.progressW.clearMarks();

    let inv = invPP(this.tracesW.curExp().trim());
    this.userInputCb(inv);

    let jsInv = invToJS(inv)
    let parsedInv:invariantT = null

    try {
      parsedInv = esprima.parse(jsInv);
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

      simplify(jsInv, (simplInv: ESTree.Node) => { 
        let ui: UserInvariant = new UserInvariant(inv, jsInv, simplInv)

        let redundant = this.progressW.contains(ui.id)
        if (redundant) {
          this.progressW.markInvariant(ui.id, "duplicate")
          this.tracesW.immediateError("Duplicate Expression!")
          return
        }

        let all = pos_res.length
        let hold = pos_res.filter(function (x) { return x; }).length

        if (hold < all)
          this.tracesW.error("Holds for " + hold + "/" + all + " cases.")
        else {
          this.tracesW.enableSubmit();
          if (!commit) {
            this.tracesW.msg("<span class='good'>Press Enter...</span>");
            return;
          }

          let gl = this;
          isTautology(ui.canonForm, function(res) {
            if (res) {
              gl.tracesW.error("This is a always true...")
              return
            }

            impliedBy(gl.foundJSInv.map(x=>x.canonForm), ui.canonForm, function (x: ESTree.Node[]) {
              if (x.length > 0) {
                gl.progressW.markInvariant(esprimaToStr(x[0]), "implies")
                gl.tracesW.immediateError("This is weaker than a found expression!")
              } else {
                var addScore = gl.computeScore(parsedInv, 1)

                gl.pwupSuggestion.invariantTried(parsedInv);
                setTimeout(() => gl.setPowerups(gl.pwupSuggestion.getPwups()), 1000); // TODO: Remove hack

                gl.score += addScore;
                gl.scoreW.add(addScore);
                gl.foundJSInv.push(ui)
                gl.progressW.addInvariant(ui.id, ui.rawInv);
                gl.tracesW.setExp("");
                if (!gl.lvlPassedF) {
                  gl.goalSatisfied((sat, feedback) => {
                    var lvl = gl.curLvl
                    if (sat) {
                      gl.lvlPassedF = true;
                      gl.lvlPassedCb();
                    }
                  });
                }
              }
            })
          })
        }
      })
    } catch (err) {
      this.tracesW.delayedError(<string>interpretError(err));
    }
  }
}

class CounterexampleGameLogic extends BaseGameLogic implements IDynGameLogic {
  foundJSInv: UserInvariant[] = [];
  soundInvs: UserInvariant[] = [];
  overfittedInvs: UserInvariant[] = [];
  nonindInvs: UserInvariant[] = [];
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
    this.nonindInvs= [];
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

  invSound(inv: UserInvariant, cb: (sound: boolean, res:invSoundnessResT)=>void): void {
    let invs = this.soundInvs.concat([inv])
    let gl = this;
    checkInvs(curLvlSet, this.curLvl.id, invs.map((x)=>x.canonForm), ([overfitted, nonind, sound]) => {
      if (sound.map((x)=>esprimaToStr(x)).indexOf(inv.id) >= 0) {
        cb(true, { ctrex: [ [], [], [] ] })
      } else {
        let ind = overfitted.map((x)=>esprimaToStr(x[0])).indexOf(inv.id)
        if (ind >= 0) {
          cb(false, { ctrex: [ [ overfitted[ind][1] ], [], [] ] })
        } else {
          let ind = nonind.map((x)=>esprimaToStr(x[0])).indexOf(inv.id)
          assert(ind >= 0);
          cb(false, { ctrex: [ [], [], [ nonind[ind][1] ] ] })
        }
      }
    });
  }

  goalSatisfied(cb: (sat: boolean, feedback: any) => void): void {
    if (this.soundInvs.length > 0) {
      counterexamples(curLvlSet, this.curLvl.id, this.soundInvs.map((x)=>x.canonForm), (res) => {
        let overfitted=res[0],nonind=res[1],sound=res[2], post_ctrex=res[3]
        cb(overfitted.length == 0 && nonind.length == 0 && post_ctrex.length == 0, res)
      })
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

      simplify(jsInv, (simplInv: ESTree.Node) => { 
        let ui: UserInvariant = new UserInvariant(inv, jsInv, simplInv)

        let redundant = this.progressW.contains(ui.id)
        if (redundant) {
          this.progressW.markInvariant(ui.id, "duplicate")
          this.tracesW.immediateError("Duplicate Expression!")
          return
        }

        let all = pos_res.length + neg_res.length + ind_res.length
        let hold_pos = pos_res.filter(function (x) { return x; }).length
        let hold_neg = neg_res.filter(function (x) { return !x; }).length
        let ind_choices = this.tracesW.switches.map(x=>x.pos)
        let hold_ind = zip(ind_choices, ind_res).filter(function (x) {
          if (x[0] == 0)
            return !x[1][0]
          else
            return x[1][0] && x[1][1]
        }).length
        var hold = hold_pos + hold_neg + hold_ind

        if (hold < all)
          this.tracesW.error("Holds for " + hold + "/" + all + " cases.")
        else {
          this.tracesW.enableSubmit();
          if (!commit) {
            this.tracesW.msg("<span class='good'>Press Enter...</span>");
            return;
          }

          let gl = this;
          isTautology(ui.canonForm, function(res) {
            if (res) {
              gl.tracesW.error("This is a always true...")
              return
            }

            impliedBy(gl.foundJSInv.map((x)=>x.canonForm), ui.canonForm, function (x: ESTree.Node[]) {
              if (x.length > 0) {
                gl.progressW.markInvariant(esprimaToStr(x[0]), "implies")
                gl.tracesW.immediateError("This is weaker than a found expression!")
              } else {
                gl.pwupSuggestion.invariantTried(ui.rawInv);
                gl.setPowerups(gl.pwupSuggestion.getPwups());

                gl.invSound(ui, function (sound, res) {
                  if (res.ctrex[0].length != 0) {
                    gl.overfittedInvs.push(ui)
                  } else if (res.ctrex[2].length != 0) {
                    gl.nonindInvs.push(ui)
                  } else {
                    gl.soundInvs.push(ui)
                  } 

                  if (sound) {
                    var addScore = gl.computeScore(ui.rawInv, 1)
                    gl.score += addScore;
                    gl.scoreW.add(addScore);
                    gl.foundJSInv.push(ui)
                    gl.progressW.addInvariant(ui.id, ui.rawInv);
                    gl.tracesW.setExp("");
                    if (!gl.lvlPassedF) {
                      gl.goalSatisfied((sat, feedback) => {
                          var lvl = gl.curLvl
                          if (sat) {
                            gl.lvlPassedF = true;
                            gl.lvlPassedCb();
                          }
                        });
                    }
                  } else {
                    gl.addData(res.ctrex);
                    gl.userInput(false)
                  }
                })
              }
            })
          })
        }
      })
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
  foundJSInv: UserInvariant[] = [];
  invMap: { [ id: string ] : UserInvariant } = {};
  lvlPassedF: boolean = false;
  nonindInvs: UserInvariant[] = [];
  overfittedInvs: UserInvariant[] = [];
  soundInvs: UserInvariant[] = [];

  allData: { [ lvlid: string ] : dataT } = { };
  allOverfitted: { [ lvlid: string ] : UserInvariant[] } =  { };
  allNonind: { [ lvlid: string ] : invariantT[] } =  { };

  constructor(public tracesW: ITracesWindow,
              public progressW: IgnoredInvProgressWindow,
              public scoreW: ScoreWindow,
              public stickyW: StickyWindow) {
    super(tracesW, progressW, scoreW, stickyW);
    this.pwupSuggestion = new PowerupSuggestionFullHistory(5, "lfu");
  }

  clear(): void {
    super.clear();
    this.foundJSInv = [];
    this.invMap = {};
    this.soundInvs = [];
    this.overfittedInvs = [];
    this.nonindInvs = [];
    this.lvlPassedF = false;
  }

  goalSatisfied(cb:(sat: boolean, feedback: any)=>void):void {
    if (this.foundJSInv.length > 0) {
      checkInvs(curLvlSet, this.curLvl.id, this.foundJSInv.map((x)=>x.canonForm),
        ([overfitted, nonind, sound]) => {
          if (sound.length > 0) {
            this.soundInvs = sound.map((x) => this.invMap[esprimaToStr(x)])
            this.overfittedInvs = overfitted.map((v) => this.invMap[esprimaToStr(v[0])])
            this.allOverfitted[this.curLvl.id] = unique(
              this.allOverfitted[this.curLvl.id].concat(this.overfittedInvs),
              (x:UserInvariant) => x.id);
            this.nonindInvs = nonind.map((v) => this.invMap[esprimaToStr(v[0])])
            counterexamples(curLvlSet, this.curLvl.id, this.soundInvs.map((x)=>x.canonForm), (res) => {
              let overfitted=res[0],nonind=res[1],sound=res[2], post_ctrex=res[3]
              cb((overfitted.length == 0 && nonind.length == 0 && post_ctrex.length == 0) ||
                  this.foundJSInv.length >= 4, res)
            })
          } else {
              cb(this.foundJSInv.length >= 4, null)
          }
        })
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

      simplify(jsInv, (simplInv: ESTree.Node) => { 
        let ui: UserInvariant = new UserInvariant(inv, jsInv, simplInv)

        let redundant = this.progressW.contains(ui.id)
        if (redundant) {
          this.progressW.markInvariant(ui.id, "duplicate")
          this.tracesW.immediateError("Duplicate Expression!")
          return
        }

        let all = pos_res.length
        let hold = pos_res.filter(function (x) { return x; }).length

        if (hold < all)
          this.tracesW.error("Holds for " + hold + "/" + all + " cases.")
        else {
          this.tracesW.enableSubmit();
          if (!commit) {
            this.tracesW.msg("<span class='good'>Press Enter...</span>");
            return;
          }

          let gl = this;
          isTautology(ui.rawInv, function(res) {
            if (res) {
              gl.tracesW.error("This is a always true...")
              return
            }

            // Def:
            //    The syntactic archetype of an invariant is the result
            //    of calling abstractLiterals(simplify(inv)).
            //
            //    We are assuming that simplify is nondeterministing (abstractLiterals is).
            //    A syntactic archetype denotes a family of invariants.

            // We want to check if the new invariant is implied by:
            //    1) a known sound invariant
            //    2) a known 'ignored' inv from the same syntactic family (i.e. same ast up to constants)
            let soundCandidattes = gl.soundInvs.map((x)=>x.canonForm);
            let unsoundCandidates = gl.nonindInvs.concat(gl.overfittedInvs)
              .filter((uinv) => uinv.archetypeId == ui.archetypeId).map((x)=>x.canonForm)
            let allCandidates = soundCandidattes.concat(unsoundCandidates)
              .concat(gl.foundJSInv.map((x)=>x.canonForm))

            impliedBy(allCandidates, ui.canonForm, function (x: ESTree.Node[]) {
              if (x.length > 0) {
                gl.progressW.markInvariant(esprimaToStr(x[0]), "implies")
                gl.tracesW.immediateError("This is weaker than a found expression!")
              } else {
                gl.pwupSuggestion.invariantTried(ui.rawInv);
                gl.setPowerups(gl.pwupSuggestion.getPwups());

                var addScore = gl.computeScore(ui.rawInv, 1)
                gl.score += addScore;
                gl.scoreW.add(addScore);
                gl.foundJSInv.push(ui)
                gl.invMap[ui.id] = ui;
                gl.progressW.addInvariant(ui.id, ui.rawInv);
                gl.tracesW.setExp("");
                if (!gl.lvlPassedF) {
                  gl.goalSatisfied((sat, feedback) => {
                      var lvl = gl.curLvl
                      if (sat) {
                        gl.lvlPassedF = true;
                        gl.lvlPassedCb();
                      }
                    });
                }
              }
            })
          })
        }
      })
    } catch (err) {
      this.tracesW.delayedError(<string>interpretError(err))
    }
  }

  addIgnoredInvariants(invs: invariantT[], queue: UserInvariant[]): void {
    for (let ind in invs) {
      let inv = invs[ind]
      let jsStr = esprimaToStr(inv);
      simplify(jsStr, (simplInv:invariantT) => {
        let ui = new UserInvariant(jsStr, jsStr, simplInv)
        this.invMap[ui.id] = ui;
        queue.push(ui);
        this.progressW.addIgnoredInvariant(ui.id, ui.rawInv);
      })
    }
  }

  addSoundInvariants(invs: invariantT[]): void {
    for (let ind in invs) {
      let inv = invs[ind]
      let jsStr = esprimaToStr(inv);
      simplify(jsStr, (simplInv:invariantT) => {
        let ui = new UserInvariant(jsStr, jsStr, inv)
        this.foundJSInv.push(ui)
        this.invMap[ui.id] = ui;
        this.progressW.addInvariant(ui.id, ui.rawInv);
      })
    }
  }

  loadLvl(lvl: PrepopulatedDynamicLevel): void {
    let loadedCb = this.lvlLoadedCb;
    this.lvlLoadedCb = null;
    super.loadLvl(lvl);
    let [ overfitted, nonind, sound ] = lvl.startingInvs
    this.addIgnoredInvariants(overfitted.map(x=>x[0]), this.overfittedInvs);
    this.addIgnoredInvariants(nonind.map(x=>x[0]), this.nonindInvs);
    this.addSoundInvariants(sound);

    if (!this.allData.hasOwnProperty(lvl.id)) {
      this.allData[lvl.id] = [ [], [], [] ];
      this.allOverfitted[lvl.id] = [ ];
    }

    for (let i in [0,1,2])
      this.allData[lvl.id][i]  = this.allData[lvl.id][i].concat(lvl.data[i])

    for (var i in overfitted) {
      this.allData[lvl.id][0].push(overfitted[i][1])
      let s = esprimaToStr(overfitted[i][0]);
      this.allOverfitted[lvl.id].push(new UserInvariant(s, s, overfitted[i][0]));
    }

    this.lvlLoadedCb = loadedCb;
    if (this.lvlLoadedCb)
      this.lvlLoadedCb();
  }
}


class PatternGameLogic extends BaseGameLogic {
  foundJSInv: UserInvariant[] = [];
  invMap: { [ id: string ] : UserInvariant } = {};
  lvlPassedF: boolean = false;
  nonindInvs: UserInvariant[] = [];
  overfittedInvs: UserInvariant[] = [];
  soundInvs: UserInvariant[] = [];

  allData: { [ lvlid: string ] : dataT } = { };
  allNonind: { [ lvlid: string ] : invariantT[] } =  { };

  constructor(public tracesW: ITracesWindow,
              public progressW: IProgressWindow,
              public scoreW: ScoreWindow,
              public stickyW: StickyWindow) {
    super(tracesW, progressW, scoreW, stickyW);
    //this.pwupSuggestion = new PowerupSuggestionFullHistoryVariableMultipliers(3, "lfu");
    this.pwupSuggestion = new PowerupSuggestionAll();
  }

  clear(): void {
    super.clear();
    this.foundJSInv = [];
    this.invMap = {};
    this.soundInvs = [];
    this.overfittedInvs = [];
    this.nonindInvs = [];
    this.lvlPassedF = false;
  }

  protected computeScore(inv: invariantT, s: number): number {
    let pwups = this.pwupSuggestion.getPwups();
    let hold: IPowerup[] = pwups.filter((pwup)=> pwup.holds(inv))
    let newScore = hold.reduce((score, pwup) => pwup.transform(score), s)
    for (var i in hold) {
      if (i == ""+(hold.length - 1)) {
        /* After the last powerup is done highlighting,
         * recompute the powerups
         */
        hold[i].highlight(()=>{
          this.pwupSuggestion.invariantTried(inv);
          this.setPowerups(this.pwupSuggestion.getPwups());
        });
      } else {
        hold[i].highlight(()=>0);
      }
    }

    if (hold.length == 0) {
      this.pwupSuggestion.invariantTried(inv);
    }
    return newScore;
  }

  goalSatisfied(cb:(sat: boolean, feedback: any)=>void):void {
    if (this.foundJSInv.length > 0) {
      checkInvs(curLvlSet, this.curLvl.id, this.foundJSInv.map((x)=>x.canonForm),
        ([overfitted, nonind, sound]) => {
          if (sound.length > 0) {
            this.soundInvs = sound.map((x) => this.invMap[esprimaToStr(x)]);
            this.overfittedInvs = overfitted.map((v) => this.invMap[esprimaToStr(v[0])]);
            this.nonindInvs = nonind.map((v) => this.invMap[esprimaToStr(v[0])]);
            counterexamples(curLvlSet, this.curLvl.id, this.soundInvs.map((x)=>x.canonForm), (res) => {
              let overfitted=res[0],nonind=res[1],sound=res[2], post_ctrex=res[3];
              cb(overfitted.length == 0 && nonind.length == 0 && post_ctrex.length == 0, res);
            });
          } else {
              cb(false, null);
          }
        })
    } else {
      cb(false, [ [], [], [] ]);
    }
  }

  userInput(commit: boolean): void {
    this.tracesW.disableSubmit();
    this.tracesW.clearError();
    this.progressW.clearMarks();

    let inv = invPP(this.tracesW.curExp().trim());
    let jsInv = invToJS(inv)
    let parsedInv: ESTree.Node = null;

    this.userInputCb(inv);

    if (inv.length == 0) {
      this.tracesW.evalResult({ clear: true })
      return;
    }

    try {
      parsedInv = esprima.parse(jsInv);
    } catch (err) {
      //this.tracesW.delayedError(inv + " is not a valid expression.");
      return;
    }

    let undefined_ids = difference(identifiers(parsedInv), toStrset(this.curLvl.variables));
    if (!isEmpty(undefined_ids)) {
      this.tracesW.delayedError(any_mem(undefined_ids) + " is not defined.");
      return;
    }

    try {
      if (jsInv.search("\\^") >= 0) {
        throw new ImmediateErrorException("UnsupportedError", "^ not supported. Try * instead.");
      }

      let pos_res = invEval(jsInv, this.curLvl.variables, this.curLvl.data[0])
      let res: [any[], any[], [any, any][]] = [pos_res, [], [] ]
      this.tracesW.evalResult({ data: res })


      if (!evalResultBool(res))
        return;

      simplify(jsInv, (simplInv: ESTree.Node) => { 
        let ui: UserInvariant = new UserInvariant(inv, jsInv, simplInv)

        let redundant = this.progressW.contains(ui.id)
        if (redundant) {
          this.progressW.markInvariant(ui.id, "duplicate")
          this.tracesW.immediateError("Duplicate Expression!")
          return
        }

        let all = pos_res.length
        let hold = pos_res.filter(function (x) { return x; }).length

        if (hold < all)
          this.tracesW.error("Holds for " + hold + "/" + all + " cases.")
        else {
          this.tracesW.enableSubmit();
          if (!commit) {
            this.tracesW.msg("<span class='good'>Press Enter...</span>");
            return;
          }

          let gl = this;
          isTautology(ui.rawInv, function(res) {
            if (res) {
              gl.tracesW.error("This is a always true...")
              return
            }

            let allCandidates = gl.foundJSInv.map((x)=>x.canonForm);

            impliedBy(allCandidates, ui.canonForm, function (x: ESTree.Node[]) {
              if (x.length > 0) {
                gl.progressW.markInvariant(esprimaToStr(x[0]), "implies")
                gl.tracesW.immediateError("This is weaker than a found expression!")
              } else {
                var addScore = gl.computeScore(ui.rawInv, 1)
                gl.score += addScore;
                gl.scoreW.add(addScore);
                gl.foundJSInv.push(ui)
                gl.invMap[ui.id] = ui;
                gl.progressW.addInvariant(ui.id, ui.rawInv);
                gl.tracesW.setExp("");
                logEvent("FoundInvariant", [curLvlSet, gl.curLvl.id, ui.rawUserInp, ui.canonForm]);
                if (!gl.lvlPassedF) {
                  gl.goalSatisfied((sat, feedback) => {
                    if (Args.get_worker_id() != "") {
                      if (sat)
                        rpc.call("App.setLvlAsDone", [curLvlSet, gl.curLvl.id], (res) => { }, log);
                      else if (gl.foundJSInv.length >= 1)
                        rpc.call("App.addToIgnoreList", [Args.get_worker_id(), curLvlSet, gl.curLvl.id], (res) => { }, log);
                    }
                    if (sat || gl.foundJSInv.length >= 8) {
                      logEvent("FinishLevel",
                               [curLvlSet,
                                gl.curLvl.id,
                                sat,
                                gl.foundJSInv.map((x)=>x.rawUserInp),
                                gl.foundJSInv.map((x)=>x.canonForm)]);
                      gl.lvlPassedF = true;
                      gl.lvlPassedCb();
                    }
                  });
                }
              }
            })
          })
        }
      })
    } catch (err) {
      if (err instanceof ImmediateErrorException) {
        this.tracesW.immediateError(<string>interpretError(err))
      } else {
        this.tracesW.delayedError(<string>interpretError(err))
      }
    }
  }

  loadLvl(lvl: DynamicLevel): void {
    let loadedCb = this.lvlLoadedCb;
    this.lvlLoadedCb = null;
    super.loadLvl(lvl);

    if (!this.allData.hasOwnProperty(lvl.id)) {
      this.allData[lvl.id] = [ [], [], [] ];
    }

    for (let i in [0,1,2])
      this.allData[lvl.id][i]  = this.allData[lvl.id][i].concat(lvl.data[i])

    this.lvlLoadedCb = loadedCb;
    if (this.lvlLoadedCb)
      this.lvlLoadedCb();
    logEvent("StartLevel", [curLvlSet, this.curLvl.id]);
  }
}

abstract class TwoPlayerBaseGameLogic implements IGameLogic {
  curLvl: Level = null;
  lvlPassedCb: voidCb = null;
  lvlLoadedCb: voidCb = null;
  userInputCb: (inv: string) => void = null;
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

  protected computeScore(inv: invariantT, s: number): number {
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

    this.stickyW.setPowerups(new_pwups);
  }

  abstract userInput(commit: boolean): void
  abstract goalSatisfied(cb: (sat: boolean, feedback: any) => void): void;
  onUserInput(cb: (inv: string) => void): void { this.userInputCb = cb; };
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
      equivalentPairs(goal.equivalent.map(esprima.parse), allInvs.map(esprima.parse), function(pairs) {
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
          equivalentPairs([esprima.parse(jsInv)], player2Invs.map(esprima.parse), function(x: any) {
            if (x != null && typeof player2Invs[x] !== "undefined") {
              // console.log(jsInv + " <=> " + player2Invs[x]);
              progW2.markInvariant(player2Invs[x], "duplicate");
              traceW.immediateError("Duplicate Invariant!");
              traceW.disableSubmit();
              doProceed = false;
              return;
            }
            else {
              impliedBy(player2Invs.map(esprima.parse), esprima.parse(jsInv), function(x: any) {
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

          equivalentPairs([esprima.parse(jsInv)], player1Invs.map(esprima.parse), function(x) {
            if (x != null && typeof player1Invs[x] !== "undefined") {
              // console.log(jsInv + " <=> " + player1Invs[x]);
              progW.markInvariant(player1Invs[x], "duplicate");
              traceW2.immediateError("Duplicate Invariant!");
              traceW2.disableSubmit();
              doProceed = false;
              return;
            }

            else {
              impliedBy(player1Invs.map(esprima.parse), esprima.parse(jsInv), function(x: invariantT[]) {
                if (x !== null && x.length > 0) {
                  // console.log(player1Invs[x] + " ==> " + jsInv);
                  progW.markInvariant(esprimaToStr(x[0]), "implies");
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
        isTautology(esprima.parse(jsInv), function(res) {
          if (res) {
            gl.tracesW.error("This is a always true...");
            gl.tracesW.disableSubmit();
            doProceed = false;
            return;
          }

          let jsInvEs = esprima.parse(jsInv);

          impliedBy(gl.foundJSInv.map(esprima.parse), jsInvEs, function(invs: invariantT[]) {
            if (invs !== null && invs.length > 0) {
              var x: number = gl.foundJSInv.indexOf(esprimaToStr(invs[0]));
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

                let addScore = gl.computeScore(jsInvEs, 1);

                gl.pwupSuggestion.invariantTried(jsInvEs);
                setTimeout(() => gl.setPowerups(gl.pwupSuggestion.getPwups()), 1000); // TODO: Remove hack

                gl.score += addScore;
                gl.scoreW.add(addScore);
                gl.foundInv.push(inv);
                gl.foundJSInv.push(jsInv);
                gl.progressW.addInvariant(inv, jsInvEs);
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

