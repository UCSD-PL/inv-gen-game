type voidCb = ()=>void
type boolCb = (res: boolean)=>void
type invSoundnessResT = { ctrex: [ any[], any[], any[] ]}
type invariantT = ESTree.Node;
type templateT = [ invariantT, string[] ]

declare var curLvlSet: string; // TODO: Remove hack

class UserInvariant {
  public rawInv: invariantT;
  public archetype: templateT;
  public id: string;
  public archetypeId: string;

  constructor(public rawUserInp: string,
              public rawJS: string,
              public canonForm: invariantT) {
    this.rawInv = esprima.parse(rawJS);
    this.archetype = abstractLiterals(canonForm);
    this.archetypeId = esprimaToStr(this.archetype[0]);
    this.id = esprimaToStr(this.canonForm);
  }
}

interface IGameLogic {
  clear(): void;
  loadLvl(lvl: Level): void;

  userInput(commit: boolean): void
  goalSatisfied(cb:(sat: boolean, feedback: any)=>void):void;

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

  userInput(commit: boolean): void
  goalSatisfied(cb:(sat: boolean, feedback: any)=>void):void;

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
  score:  number = 0;

  constructor(public tracesW: ITracesWindow,
              public progressW: IProgressWindow,
              public scoreW: ScoreWindow,
              public stickyW: StickyWindow) {
    this.clear();
    let gl = this;
    this.tracesW.onChanged(function () {
      gl.userInput(false);
    })

    this.tracesW.onCommit(function () {
      gl.tracesW.msg("Trying out...");
      gl.tracesW.disable();
      gl.userInput(true);
      gl.tracesW.enable();
    })

    this.onUserInput(()=>{});
    this.onLvlLoaded(()=>{});
    this.onLvlPassed(()=>{});
    this.onUserInput((x)=>{});
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
    this.setPowerups(this.pwupSuggestion.getPwups())
    if (this.lvlLoadedCb)
      this.lvlLoadedCb();
  }

  protected computeScore(inv: invariantT, s: number): number {
    let pwups = this.pwupSuggestion.getPwups();
    let hold = pwups.filter((pwup)=> pwup.holds(inv))
    let newScore = hold.reduce((score, pwup) => pwup.transform(score), s)
    hold.forEach((pwup)=>pwup.highlight(()=>0));
    return newScore;
  }

  protected setPowerups(new_pwups: IPowerup[]): void {
    let pwups = {}
    for (let i in new_pwups) {
      pwups[new_pwups[i].id] = new_pwups[i]
    }

    this.stickyW.set(new_pwups);
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
              public stickyW: StickyWindow) {
    super(tracesW, progressW, scoreW, stickyW);
    this.pwupSuggestion = new PowerupSuggestionFullHistory(5, "lfu");
  }

  clear(): void {
    super.clear();
    this.foundJSInv = [];
    this.lvlPassedF = false;
  }

  goalSatisfied(cb:(sat: boolean, feedback?: any)=>void):void {
    let goal = this.curLvl.goal;
    if (goal == null) {
      cb(true)
    } else if (goal.manual) {
      cb(false)
    } else  if (goal.find) {
      var numFound = 0;
      for (var i=0; i < goal.find.length; i++) {
        var found = false;
        for (var j=0; j < goal.find[i].length; j++) {
          if ($.inArray(goal.find[i][j], this.foundJSInv) != -1) {
            found = true;
            break;
          }
        }

        if (found)
          numFound ++;

      }

      cb(numFound == goal.find.length,
         { "find": { "found": numFound, "total": goal.find.length } })
    } else  if (goal.equivalent) {
      equivalentPairs(goal.equivalent, this.foundJSInv.map((x)=>x.canonForm), function(pairs) {
        var numFound = 0;
        var equiv = []
        for (var i=0; i < pairs.length; i++) {
          if (-1 == $.inArray(pairs[i][0], equiv))
            equiv.push(pairs[i][0])
        }

        cb(equiv.length == goal.equivalent.length,
           { "equivalent": { "found": equiv.length , "total": goal.equivalent.length } })
      })
    } else if (goal.max_score) {
      cb(true, { "max_score" : { "found" : this.foundJSInv.length } })
    } else if (goal.none) {
      cb(false)
    } else if (goal.hasOwnProperty('atleast')) {
      cb(this.foundJSInv.length >= goal.atleast)
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

    if (inv.length == 0) {
      this.tracesW.evalResult({ clear: true })
      return;
    }

    try {
      let pos_res = invEval(jsInv, this.curLvl.variables, this.curLvl.data[0])
      let res: [any[], any[], [any, any][]] = [pos_res, [], []]
      this.tracesW.evalResult({ data: res })

      if (!evalResultBool(res))
        return;

      simplify(jsInv, (simplInv: ESTree.Node) => { 
        let ui: UserInvariant = new UserInvariant(inv, jsInv, simplInv)

        let redundant = this.progressW.contains(ui.id)
        if (redundant) {
          this.progressW.markInvariant(ui.id, "duplicate")
          this.tracesW.immediateError("Duplicate Invariant!")
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
      this.tracesW.delayedError(<string>interpretError(err))
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

  addData(data:dataT): void{
    for (var i in [0,1]) {
      this.curLvl.data[i] = this.curLvl.data[i].concat(data[i])
    }
    this.curLvl.data[2] = this.curLvl.data[2].concat(data[2].reduce((a,b)=>a.concat(b), []))
    this.tracesW.addData(data)
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
          cb(false, { ctrex: [ overfitted[ind][1], [], [] ] })
        } else {
          let ind = nonind.map((x)=>esprimaToStr(x[0])).indexOf(inv.id)
          assert(ind >= 0);
          cb(false, { ctrex: [ [], [], [ nonind[ind][1] ] ] })
        }
      }
    })
  }

  goalSatisfied(cb:(sat: boolean, feedback: any)=>void):void {
    if (this.soundInvs.length > 0) {
      counterexamples(curLvlSet, this.curLvl.id, this.soundInvs.map((x)=>x.canonForm), (res) => {
        let overfitted=res[0],nonind=res[1],sound=res[2], post_ctrex=res[3]
        cb(overfitted.length == 0 && nonind.length == 0 && post_ctrex.length == 0, res)
      })
    } else {
      cb(false, [ [], [], [] ])
    }
  }

  userInput(commit: boolean): void {
    this.tracesW.disableSubmit();
    this.tracesW.clearError();
    this.progressW.clearMarks();

    let inv = invPP(this.tracesW.curExp().trim());
    let jsInv = invToJS(inv)

    this.userInputCb(inv);

    try {
      let parsedInv = esprima.parse(jsInv);
    } catch (err) {
      this.tracesW.delayedError(inv + " is not a valid expression.");
      return;
    }

    if (inv.length == 0) {
      this.tracesW.evalResult({ clear: true })
      return;
    }

    try {
      let pos_res = invEval(jsInv, this.curLvl.variables, this.curLvl.data[0])
      let neg_res = invEval(jsInv, this.curLvl.variables, this.curLvl.data[1])
      let raw_ind_res = invEval(jsInv, this.curLvl.variables, this.curLvl.data[2])

      // Pair the inductive results
      let ind_res = zip(raw_ind_res.filter((_,i)=>i%2 == 0), raw_ind_res.filter((_,i)=>i%2==1))
      let res: [any[], any[], [any, any][]] = [pos_res, neg_res, ind_res]
      this.tracesW.evalResult({ data: res })

      if (!evalResultBool(res))
        return;

      simplify(jsInv, (simplInv: ESTree.Node) => { 
        let ui: UserInvariant = new UserInvariant(inv, jsInv, simplInv)

        let redundant = this.progressW.contains(ui.id)
        if (redundant) {
          this.progressW.markInvariant(ui.id, "duplicate")
          this.tracesW.immediateError("Duplicate Invariant!")
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
                  } else if (res.ctrex[1].length != 0) {
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
      this.tracesW.delayedError(<string>interpretError(err))
    }
  }
}


class TutorialCounterexampleGameLogic extends CounterexampleGameLogic {
  invSoundCb: (inv: invariantT, cb: (res:invSoundnessResT)=>void)=>void = null;
  onInvSound(cb:(inv: invariantT, cb: (res:invSoundnessResT)=>void)=>void) {
    this.invSoundCb = cb;
  }

  invSound(inv, cb) {
    if (this.invSoundCb)
      this.invSoundCb(inv, cb);
  }

  goalSatisfied(cb:(sat: boolean, feedback?: any)=>void):void {
    let goal = this.curLvl.goal;
    if (goal.none) {
      cb(false)
    } else if (goal.hasOwnProperty('atleast')) {
      cb(this.foundJSInv.length >= goal.atleast)
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
  allOverfitted: { [ lvlid: string ] : invariantT } =  { };
  allNonind: { [ lvlid: string ] : invariantT } =  { };

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
      cb(false, [ [], [], [] ])
    }
  }

  userInput(commit: boolean): void {
    this.tracesW.disableSubmit();
    this.tracesW.clearError();
    this.progressW.clearMarks();

    let inv = invPP(this.tracesW.curExp().trim());
    let jsInv = invToJS(inv)

    this.userInputCb(inv);

    try {
      let parsedInv = esprima.parse(jsInv);
    } catch (err) {
      this.tracesW.delayedError(inv + " is not a valid expression.");
      return;
    }

    if (inv.length == 0) {
      this.tracesW.evalResult({ clear: true })
      return;
    }

    try {
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
          this.tracesW.immediateError("Duplicate Invariant!")
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
        this.foundJSInv.push(ui);
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

    if (!this.allData.hasOwnProperty(lvl.id))
      this.allData[lvl.id] = [ [], [], [] ];

    for (let i in [0,1,2])
      this.allData[lvl.id][i]  = this.allData[lvl.id][i].concat(lvl.data[i])

    for (var i in overfitted) {
      this.allData[lvl.id][0].push(overfitted[i][1])
    }

    this.lvlLoadedCb = loadedCb;
    if (this.lvlLoadedCb)
      this.lvlLoadedCb();
  }
}
