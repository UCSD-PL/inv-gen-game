type voidCb = ()=>void
type boolCb = (res: boolean)=>void
type invSoundnessResT = { ctrex: [ any[], any[], any[] ]}
declare var curLvlSet: string; // TODO: Remove hack

interface IGameLogic {
  clear(): void;
  loadLvl(lvl: Level): void;

  userInput(commit: boolean): void
  goalSatisfied(cb:(sat: boolean, feedback: any)=>void):void;

  onUserInput(cb: (inv:invariantT)=>void): void;
  onLvlPassed(cb: ()=>void): void;
  onLvlLoaded(cb: ()=>void): void;
  onCommit(cb: ()=>void): void;
}

interface IDynGameLogic extends IGameLogic {
  clear(): void;
  loadLvl(lvl: Level): void;
  addData(data: dataT): void;
  invSound(inv: invariantT, cb: (sound: boolean, res:invSoundnessResT)=>void): void;

  userInput(commit: boolean): void
  goalSatisfied(cb:(sat: boolean, feedback: any)=>void):void;

  onUserInput(cb: (inv:invariantT)=>void): void;
  onLvlPassed(cb: ()=>void): void;
  onLvlLoaded(cb: ()=>void): void;
  onCommit(cb: ()=>void): void;
}

abstract class BaseGameLogic implements IGameLogic {
  curLvl: Level = null;
  lvlPassedCb: voidCb = null;
  lvlLoadedCb: voidCb = null;
  userInputCb: (inv:invariantT)=> void = null;
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

  protected computeScore(inv: string, s: number): number {
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
  onUserInput(cb: (inv: invariantT)=>void): void { this.userInputCb = cb; };
  onLvlPassed(cb: ()=>void): void { this.lvlPassedCb = cb; };
  onLvlLoaded(cb: ()=>void): void { this.lvlLoadedCb = cb; };
  onCommit(cb: ()=>void): void { this.commitCb = cb; };
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
      equivalentPairs(goal.equivalent, this.foundJSInv, function(pairs) {
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
      let res: [any[], any[], [any, any][]] = [pos_res, [], []]
      this.tracesW.evalResult({ data: res })

      if (!evalResultBool(res))
        return;

      let redundant = this.progressW.contains(inv)
      if (redundant) {
        this.progressW.markInvariant(inv, "duplicate")
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
        isTautology(invToJS(inv), function(res) {
          if (res) {
            gl.tracesW.error("This is a always true...")
            return
          }

          impliedBy(gl.foundJSInv, jsInv, function (x: number) {
            if (x !== null) {
              gl.progressW.markInvariant(gl.foundInv[x], "implies")
              gl.tracesW.immediateError("This is weaker than a found expression!")
            } else {
              var addScore = gl.computeScore(jsInv, 1)

              gl.pwupSuggestion.invariantTried(jsInv);
              setTimeout(() => gl.setPowerups(gl.pwupSuggestion.getPwups()), 1000); // TODO: Remove hack

              gl.score += addScore;
              gl.scoreW.add(addScore);
              gl.foundInv.push(inv)
              gl.foundJSInv.push(jsInv)
              gl.progressW.addInvariant(inv);
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

    } catch (err) {
      this.tracesW.delayedError(<string>interpretError(err))
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

  invSound(inv: invariantT, cb: (sound: boolean, res:invSoundnessResT)=>void): void {
    let invs = this.soundInvs.concat([inv])
    let gl = this;
    pre_vc_ctrex(curLvlSet, this.curLvl.id, invs, function(pos_res) {
      if (pos_res.length != 0) {
        cb(false, { ctrex: [pos_res, [], []] })
      } else {
        ind_vc_ctrex(curLvlSet, gl.curLvl.id, invs, function(ind_res) {
          cb(ind_res.length == 0, { ctrex: [ [], [], ind_res ] })
        })
      }
    })
  }

  goalSatisfied(cb:(sat: boolean, feedback: any)=>void):void {
    if (this.soundInvs.length > 0) {
      counterexamples(curLvlSet, this.curLvl.id, this.soundInvs, (res:dataT) => {
        var pos=res[0],neg=res[1],ind = res[2]
        cb(pos.length == 0 && neg.length == 0 && ind.length == 0, res)
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

      let redundant = this.progressW.contains(inv)
      if (redundant) {
        this.progressW.markInvariant(inv, "duplicate")
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
        isTautology(invToJS(inv), function(res) {
          if (res) {
            gl.tracesW.error("This is a always true...")
            return
          }

          impliedBy(gl.foundJSInv, jsInv, function (x: number) {
            if (x !== null) {
              gl.progressW.markInvariant(gl.foundInv[x], "implies")
              gl.tracesW.immediateError("This is weaker than a found expression!")
            } else {
              gl.pwupSuggestion.invariantTried(jsInv);
              gl.setPowerups(gl.pwupSuggestion.getPwups());

              gl.invSound(jsInv, function (sound, res) {
                if (res.ctrex[0].length != 0) {
                  gl.overfittedInvs.push(jsInv)
                } else if (res.ctrex[2].length != 0) {
                  gl.nonindInvs.push(jsInv)
                } else {
                  gl.soundInvs.push(jsInv)
                } 

                if (sound) {
                  var addScore = gl.computeScore(jsInv, 1)
                  gl.score += addScore;
                  gl.scoreW.add(addScore);
                  gl.foundInv.push(inv)
                  gl.foundJSInv.push(jsInv)
                  gl.progressW.addInvariant(inv);
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
  foundJSInv: string[] = [];
  foundInv: string[] = [];
  lvlPassedF: boolean = false;
  nonindInvs: invariantT[] = [];
  overfittedInvs: invariantT[] = [];
  soundInvs: invariantT[] = [];
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
    this.foundInv = [];
    this.soundInvs = [];
    this.overfittedInvs = [];
    this.nonindInvs = [];
    this.lvlPassedF = false;
  }

  goalSatisfied(cb:(sat: boolean, feedback: any)=>void):void {
    if (this.foundJSInv.length > 0) {
      checkInvs(curLvlSet, this.curLvl.id, this.foundJSInv, ([overfitted, nonind, sound]) => {
        if (sound.length > 0) {
          this.soundInvs = sound.map((v) => this.foundJSInv[v])
          this.overfittedInvs = overfitted.map((v) => this.foundJSInv[v[0]])
          this.nonindInvs = nonind.map((v) => this.foundJSInv[v[0]])
          counterexamples(curLvlSet, this.curLvl.id, this.soundInvs, (res:dataT) => {
            let pos=res[0],neg=res[1],ind = res[2]
            cb((pos.length == 0 && neg.length == 0 && ind.length == 0) ||
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

      let redundant = this.progressW.contains(inv)
      if (redundant) {
        this.progressW.markInvariant(inv, "duplicate")
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
        isTautology(invToJS(inv), function(res) {
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
          let implCandidattes = [].concat(gl.soundInvs);

          impliedBy(gl.foundJSInv, jsInv, function (x: number) {
            if (x !== null) {
              gl.progressW.markInvariant(gl.foundInv[x], "implies")
              gl.tracesW.immediateError("This is weaker than a found expression!")
            } else {
              gl.pwupSuggestion.invariantTried(jsInv);
              gl.setPowerups(gl.pwupSuggestion.getPwups());

              var addScore = gl.computeScore(jsInv, 1)
              gl.score += addScore;
              gl.scoreW.add(addScore);
              gl.foundInv.push(inv)
              gl.foundJSInv.push(jsInv)
              gl.progressW.addInvariant(inv);
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

    } catch (err) {
      this.tracesW.delayedError(<string>interpretError(err))
    }
  }

  addIgnoredInvariants(invs: invariantT[]): void {
    for (let ind in invs) {
      let inv = invs[ind]
      this.foundInv.push(invPP(inv))
      this.foundJSInv.push(inv)
      this.progressW.addIgnoredInvariant(inv);
    }
  }

  addSoundInvariants(invs: invariantT[]): void {
    for (let ind in invs) {
      let inv = invs[ind]
      this.foundInv.push(invPP(inv))
      this.foundJSInv.push(inv)
      this.progressW.addInvariant(inv);
    }
  }

  loadLvl(lvl: PrepopulatedDynamicLevel): void {
    let loadedCb = this.lvlLoadedCb;
    this.lvlLoadedCb = null;
    super.loadLvl(lvl);
    let [ overfitted, nonind, sound ] = lvl.startingInvs
    this.overfittedInvs = this.overfittedInvs.concat(overfitted.map(x=>x[0]))
    this.nonindInvs = this.nonindInvs.concat(nonind.map(x=>x[0]))
    this.addIgnoredInvariants(overfitted.map(x=>x[0]).concat(nonind.map(x=>x[0])));
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
