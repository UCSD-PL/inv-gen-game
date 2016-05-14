type voidCb = ()=>void
type boolCb = (res: boolean)=>void
type invSoundnessResT = { sound: boolean, ctrex: [ any[], any[], any[] ]}
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
  invSound(inv: invariantT, cb: (res:invSoundnessResT)=>void): void;

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
    let newScore = pwups.reduce((score, pwup) => pwup.transform(score), s)
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

  invSound(inv: invariantT, cb: (res:invSoundnessResT)=>void): void {
    let invs = this.soundInvs.concat([inv])
    let gl = this;
    pre_vc_ctrex(curLvlSet, this.curLvl.id, invs, function(pos_res) {
      if (pos_res.length != 0) {
        cb({ sound: false, ctrex: [pos_res, [], []] })
      } else {
        ind_vc_ctrex(curLvlSet, gl.curLvl.id, invs, function(ind_res) {
          cb({ sound: ind_res.length == 0, ctrex: [ [], [], ind_res ] })
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

              gl.invSound(jsInv, function (res) {
                if (res.ctrex[0].length != 0) {
                  gl.overfittedInvs.push(jsInv)
                } else if (res.ctrex[2].length != 0) {
                  gl.nonindInvs.push(jsInv)
                } else {
                  gl.soundInvs.push(jsInv)
                } 

                if (res.sound) {
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

/*
function CEGameLogic(tracesW, progressW, scoreW, stickyW) {
  var gl = this;

  var foundInv;
  var foundJSInv, ignoredJSInv, this.overfittedInvs, this.nonindInvs, this.soundInvs;
  var overfittedInvs;
  var progress;
  var pwups;
  var inductiveCtrxExpr = null;
  var lvlPassedF = false;
  var minInvForNextLvl = 3;

  gl.tracesW = tracesW;
  gl.progressW = progressW;
  gl.scoreW = scoreW;
  gl.stickyW = stickyW;
  gl.curLvl = null;
  gl.pwupSuggestion = new PowerupSuggestionFullHistory(5, "lfu")

  gl.clear = function () {
    foundInv = [];
    foundJSInv = [];
    ignoredJSInv = [];

    this.overfittedInvs = [];
    this.nonindInvs = [];
    this.soundInvs = [];

    overfittedInvs = [];
    gl.curLvl = null;
    progress = {}
    pwups = {};
  }

  var computeScore = function(inv, s) {
    var update = true;
    for (var i in pwups) {
      if (pwups.hasOwnProperty(i) && pwups[i].holds(inv)) {
        s = pwups[i].transform(s)
        pwups[i].highlight(function () {
          if (update) { // We have multiple callbacks. Want only one to update.
            update = false;
            gl.setPowerups(gl.pwupSuggestion.getPwups())
          }
        });
      }
    }
    return s;
  }

  gl.userInput = function (commit) {
    tracesW.disableSubmit();
    tracesW.clearError();
    progressW.clearMarks();

    var inv = invPP(tracesW.curExp().trim());
    var jsInv = invToJS(inv)

    gl.userInputCb(inv);

    try {
      var parsedInv = esprima.parse(jsInv);
    } catch (err) {
      //log("Error parsing: " + err)
      tracesW.delayedError(inv + " is not a valid expression.");
      return;
    }

    if (inv.length == 0) {
      tracesW.evalResult({ clear: true })
      return;
    }

    try {
      var pos_res = invEval(jsInv, gl.curLvl.variables, gl.curLvl.data[0])
      var neg_res = invEval(jsInv, gl.curLvl.variables, gl.curLvl.data[1])
      var ind_res = invEval(jsInv, gl.curLvl.variables, gl.curLvl.data[2])

      // Pair the inductive results
      var ind_res = zip(ind_res.filter((_,i)=>i%2 == 0), ind_res.filter((_,i)=>i%2==1))

      var res = [pos_res, neg_res, ind_res]
      tracesW.evalResult({ data: res })

      if (!evalResultBool(res))
        return;

      var redundant = progW.contains(inv)
      if (redundant) {
        progW.markInvariant(inv, "duplicate")
        tracesW.immediateError("Duplicate Invariant!")
        return
      }

      var all = pos_res.length + neg_res.length + ind_res.length
      var hold_pos = pos_res.filter(function (x) { return x; }).length
      var hold_neg = neg_res.filter(function (x) { return !x; }).length
      var ind_choices = tracesW.switches.map(x=>x.pos)
      var hold_ind = zip(ind_choices, ind_res).filter(function (x) {
        if (x[0] == 0)
          return !x[1][0]
        else
          return x[1][0] && x[1][1]
      }).length
      var hold = hold_pos + hold_neg + hold_ind

      if (hold < all)
        tracesW.error("Holds for " + hold + "/" + all + " cases.")
      else {
        tracesW.enableSubmit();
        if (!commit) {
          tracesW.msg("<span class='good'>Press Enter...</span>");
          return;
        }

        isTautology(invToJS(inv), function(res) {
          if (res) {
            tracesW.error("This is a always true...")
            return
          }

          equivalentToAny(ignoredJSInv, jsInv, function (x) {
            if (x !== null) {
              progW.markInvariant(foundInv[x], "implies")
              tracesW.immediateError("This is equivalent to an ignored expression!")
              return;
            }

            impliedBy(foundJSInv, jsInv, function (x) {
              if (x !== null) {
                progW.markInvariant(foundInv[x], "implies")
                tracesW.immediateError("This is weaker than a found expression!")
              } else {
                gl.pwupSuggestion.invariantTried(jsInv);
                gl.setPowerups(gl.pwupSuggestion.getPwups());

                gl.curLvl.invSound(jsInv, this.soundInvs, function (res) {
                  if (res.ctrex[0].length != 0) {
                    this.overfittedInvs.push(jsInv)
                  } else if (res.ctrex[2].length != 0) {
                    this.nonindInvs.push(jsInv)
                  } else {
                    this.soundInvs.push(jsInv)
                  } 

                  if (res.sound || gl.curLvl.multiround) {
                    var addScore = computeScore(jsInv, 1)
                    scoreW.add(addScore);
                    foundInv.push(inv)
                    foundJSInv.push(jsInv)
                    progW.addInvariant(inv);
                    tracesW.setExp("");
                    if (!gl.lvlPassedF) {
                      gl.curLvl.goalSatisfied(
                        foundJSInv, 
                        this.overfittedInvs, 
                        this.nonindInvs,
                        this.soundInvs, 
                        function(res) {
                          var lvl = gl.curLvl
                          if (res.satisfied) {
                            gl.lvlPassedF = true;
                            gl.lvlPassed();
                          } else if (lvl.multiround && foundJSInv.length > minInvForNextLvl) {
                            rpc.call("App.getPositiveExamples", [ curLvlSet, 
                              lvl.id, lvl.exploration_state,
                              this.overfittedInvs.map(esprima.parse), 5], (data) => {
                                var templates = foundJSInv.map(abstractLiterals)
                                rpc.call("App.instantiate", [templates, lvl.variables, data[1]],
                                (invs) => {
                                  invs = invs.map((inv) => inv.substring(1, inv.length - 1))
                                  invs = invs.filter( (item, ind) => invs.indexOf(item) == ind )
                                  var newLvl = new Level(lvl.id,
                                    lvl.variables, [data[1], [], []], data[0], lvl.goal,
                                    lvl.hint, lvl.support_pos_ex, lvl.support_neg_ex,
                                    lvl.support_ind_ex, lvl.multiround, invs)
                                  lvls.splice(curLvl+1, 0, newLvl)
                                  gl.lvlPassedF = true;
                                  gl.lvlPassed();
                                })
                              })
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
        })
      }

    } catch (err) {
      tracesW.delayedError(interpretError(err))
    }
  }

  gl.loadLvl = function(lvl) {
    gl.lvlPassedF = false;
    gl.clear();
    gl.curLvl = lvl;
    stickyW.clear();
    progW.clear();
    tracesW.clearError();
    //scoreW.clear();
    tracesW.clearData(0);
    tracesW.clearData(1);
    tracesW.clearData(2);
    tracesW.setVariables(lvl);
    tracesW.addData(lvl.data);
    if (lvl.support_pos_ex) {
      tracesW.onMoreExamples(function(type) {
        rpc.call("App.getPositiveExamples", [curLvlSet, gl.curLvl.id, lvl.exploration_state, 
          overfittedInvs.map(esprima.parse), 1],
          function (res) {
            lvl.exploration_state = res[0]
            lvl.data[0] = lvl.data[0].concat(res[1])
            tracesW.addData([res[1], [], []])
          })
      })
    } else {
      tracesW.onMoreExamples((type) => assert(false, "Shouldn't get here"))
    }
    tracesW.setExp("");
    gl.userInput(false);
    gl.pwupSuggestion.clear(lvl);
    gl.setPowerups(gl.pwupSuggestion.getPwups())
    gl.lvlLoaded();

    for (var i in lvl.startingInvs) {
      var sInv = lvl.startingInvs[i]
      gl.curLvl.invSound(sInv, this.soundInvs, ((inv) => (res) => {
        if (res.ctrex[0].length != 0) {
          this.overfittedInvs.push(inv)
        } else if (res.ctrex[2].length != 0) {
          this.nonindInvs.push(inv)
        } else {
          this.soundInvs.push(inv)
        } 

        if (res.sound) {
          var addScore = computeScore(inv, 1)
          scoreW.add(addScore);
          foundInv.push(inv)
          foundJSInv.push(inv)
          progW.addInvariant(inv);
        } else {
          ignoredJSInv.push(inv)
          progW.addIgnored(inv);
        }
      })(sInv))
    }
  }

  gl.addPowerup = function(pwup) {
    if (pwup.id in pwups) {
      return;
    }

    gl.stickyW.add(pwup)
    pwups[pwup.id] = pwup;
  }

  gl.setPowerups = function (new_pwups) {
    pwups = {}
    for (var i in new_pwups) {
      pwups[new_pwups[i].id] = new_pwups[i]
    }

    stickyW.set(new_pwups);
  }

  gl.removePowerup = function(pwup) {
    if (!(pwup.id in pwups)) {
      return;
    }

    $(pwup.element).remove();
    delete pwups[pwup.id]
  }

  tracesW.onChanged(function () {
    gl.userInput(false);
  })

  tracesW.onCommit(function () {
    tracesW.msg("Trying out...");
    tracesW.disable();
    gl.userInput(true);
    tracesW.enable();
  })

  gl.lvlPassed = function () {}
  gl.lvlLoaded = function () {}

  gl.onLvlPassed = function (cb) {
    gl.lvlPassed = cb;
  }

  gl.onLvlLoaded = function (cb) {
    gl.lvlLoaded = cb;
  }

  gl.userInputCb = function (dummy) {}
  gl.onUserInput = function (cb) {
    gl.userInputCb = cb;
  }

  gl.addData = function (data) {
    tracesW.addData(data)
    for (var i in [0,1]) {
      gl.curLvl.data[i] = gl.curLvl.data[i].concat(data[i])
    }
    gl.curLvl.data[2] = gl.curLvl.data[2].concat(data[2].reduce((a,b)=>a.concat(b), []))
  }

  gl.score = function () { return scoreW.score; }
  gl.clear();
}
*/
