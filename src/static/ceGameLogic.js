function CEGameLogic(tracesW, progressW, scoreW, stickyW) {
  var gl = this;

  var foundInv;
  var foundJSInv;
  var progress;
  var pwups;

  gl.tracesW = tracesW;
  gl.progressW = progressW;
  gl.scoreW = scoreW;
  gl.stickyW = stickyW;
  gl.curLvl = null;
  gl.pwupSuggestion = new PowerupSuggestionFullHistory(gl, 5, "lfu")

  gl.clear = function () {
    foundInv = [];
    foundJSInv = [];
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
      ind_res = zip(ind_res.filter((_,i)=>i%2 == 0), ind_res.filter((_,i)=>i%2==1))

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

      all = pos_res.length + neg_res.length + ind_res.length
      hold_pos = pos_res.filter(function (x) { return x; }).length
      hold_neg = neg_res.filter(function (x) { return x; }).length
      hold_ind = ind_res.filter(function (x) { return x[0] == x[1]; }).length
      hold = hold_pos + hold_neg + hold_ind

      if (hold < all)
        tracesW.error("Holds for " + hold + "/" + all + " cases.")
      else {
        tracesW.enableSubmit();
        if (!commit) {
          tracesW.msg("Press Enter...");
          return;
        }

        isTautology(invToJS(inv), function(res) {
          if (res) {
            tracesW.error("This is a tautology...")
            return
          }

          impliedBy(foundJSInv, jsInv, function (x) {
            if (x !== null) {
              progW.markInvariant(foundInv[x], "implies")
              tracesW.immediateError("Implied by existing invariant!")
            } else {
              gl.pwupSuggestion.invariantTried(jsInv);

              if (!progress.satisfied) {
                gl.curLvl.goalSatisfied(foundJSInv.concat(jsInv),
                  function(newProgress) {
                    progress = newProgress
                    if (progress.satisfied) {
                      gl.lvlPassed();
                    } else {
                      if (progress.counterexamples) {
                        var invalidInv = true;
                        // Order of checking and the short-circuiting here is important. We check first
                        // 1) precondition counterexamples (positive) as they
                        //    are guaranteed to be negative values
                        // 2) inductive counterexamples, as they are the only
                        //    other barrier for a sound invariant
                        // 3) postcondition failures - if only those are
                        //    present, then the user has a sound inductive
                        //    invariant that we should keep. Its just not tight
                        //    enough. TODO: We currently don't display the
                        //    negative counterexamples. Whats a good way to show those?
                        if (progress.counterexamples[0].length > 0) {
                          tracesW.addData([progress.counterexamples[0], [], []])
                          gl.curLvl.data[0] = gl.curLvl.data[0].concat(progress.counterexamples[0])
                        } else if (progress.counterexamples[2].length > 0){
                          tracesW.clearData(2)
                          tracesW.addData([[],[], progress.counterexamples[2]])
                          gl.curLvl.data[2] = progress.counterexamples[2][0]
                        } else {
                          /*
                          // assert (progress.counterexamples[1].length > 0)
                          tracesW.addData(progress.counterexamples[1], "negative")
                          gl.curLvl.data[1] = gl.curLvl.data[1].concat(progress.counterexamples[1])
                          */
                          invalidInv = false;
                        } 

                        if (invalidInv) {
                          gl.userInput(false)
                        } else {
                          foundInv.push(inv)
                          foundJSInv.push(jsInv)
                          progW.addInvariant(inv);
                          var addScore = computeScore(jsInv, 1)

                          if (addScore == 1) { // No powerups applied
                            gl.setPowerups(gl.pwupSuggestion.getPwups());
                          }
                          scoreW.add(addScore);
                          tracesW.setExp("");

                          // Clear inductive counterexamples
                          gl.curLvl.data[2] = [];
                          tracesW.clearData(2)
                        }
                      }
                    }
                });
              }
            }
          })
        })
      }

    } catch (err) {
      tracesW.delayedError(interpretError(err))
    }
  }

  gl.loadLvl = function(lvl) {
    gl.clear();
    gl.curLvl = lvl;
    stickyW.clear();
    progW.clear();
    tracesW.clearError();
    //scoreW.clear();
    tracesW.setVariables(lvl);
    tracesW.addData(lvl.data);
    if (lvl.support_pos_ex) {
      tracesW.moreExamples(function(type) {
        rpc.call("App.getPositiveExamples", [curLvlSet, lvls[curLvl], lvl.exploration_state, 1],
        function (res) {
          lvl.exploration_state = res[0]
          lvl.data[0] = lvl.data[0].concat(res[1])
          tracesW.addData([res[1], [], []])
        })
      })
    }
    tracesW.setExp("");
    gl.userInput(false);
    gl.pwupSuggestion.clear(lvl);
    gl.setPowerups(gl.pwupSuggestion.getPwups())
    gl.lvlLoaded();
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

  gl.score = function () { return scoreW.score; }
  gl.clear();
}
