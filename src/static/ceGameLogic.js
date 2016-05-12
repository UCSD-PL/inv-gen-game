function CEGameLogic(tracesW, progressW, scoreW, stickyW) {
  var gl = this;

  var foundInv;
  var foundJSInv, ignoredJSInv, overfitted_invs, nonind_invariants, sound_invariants;
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

    overfitted_invs = [];
    nonind_invariants = [];
    sound_invariants = [];

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

                gl.curLvl.invSound(jsInv, sound_invariants, function (res) {
                  if (res.ctrex[0].length != 0) {
                    overfitted_invs.push(jsInv)
                  } else if (res.ctrex[2].length != 0) {
                    nonind_invariants.push(jsInv)
                  } else {
                    sound_invariants.push(jsInv)
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
                        overfitted_invs, 
                        nonind_invariants,
                        sound_invariants, 
                        function(res) {
                          var lvl = gl.curLvl
                          if (res.satisfied) {
                            gl.lvlPassedF = true;
                            gl.lvlPassed();
                          } else if (lvl.multiround && foundJSInv.length > minInvForNextLvl) {
                            rpc.call("App.getPositiveExamples", [ curLvlSet, 
                              lvl.id, lvl.exploration_state,
                              overfitted_invs.map(esprima.parse), 5], (data) => {
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
      tracesW.moreExamples(function(type) {
        rpc.call("App.getPositiveExamples", [curLvlSet, gl.curLvl.id, lvl.exploration_state, 
          overfittedInvs.map(esprima.parse), 1],
          function (res) {
            lvl.exploration_state = res[0]
            lvl.data[0] = lvl.data[0].concat(res[1])
            tracesW.addData([res[1], [], []])
          })
      })
    } else {
      tracesW.moreExamples((type) => assert(false, "Shouldn't get here"))
    }
    tracesW.setExp("");
    gl.userInput(false);
    gl.pwupSuggestion.clear(lvl);
    gl.setPowerups(gl.pwupSuggestion.getPwups())
    gl.lvlLoaded();

    for (var i in lvl.startingInvs) {
      var sInv = lvl.startingInvs[i]
      gl.curLvl.invSound(sInv, sound_invariants, ((inv) => (res) => {
        if (res.ctrex[0].length != 0) {
          overfitted_invs.push(inv)
        } else if (res.ctrex[2].length != 0) {
          nonind_invariants.push(inv)
        } else {
          sound_invariants.push(inv)
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

  tracesW.changed(function () {
    gl.userInput(false);
  })

  tracesW.commit(function () {
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
