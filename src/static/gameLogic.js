function GameLogic(tracesW, progressW, scoreW, stickyW) {
  var gl = this;

  var foundInv;
  var foundJSInv;
  var progress;
  var pwups;

  var player = tracesW.getPlayer() //get player # here

  gl.tracesW = tracesW;
  gl.progressW = progressW;
  gl.scoreW = scoreW;
  gl.stickyW = stickyW;
  gl.curGoal = null;
  //gl.pwupSuggestion = new PowerupSuggestionAll(gl,2)
  gl.pwupSuggestion = new PowerupSuggestionFullHistory(gl, 5, "lfu")

  gl.getFoundJSInv = function() {
    return foundJSInv;
  }

  gl.getTracesW = function() {
    return gl.tracesW;
  }

  gl.getScoreW = function() {
    return gl.scoreW;
  }

  gl.clear = function () {
    foundInv = [];
    foundJSInv = [];
    gl.curGoal = null;
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
      res = invEval(jsInv, data)
      tracesW.evalResult({ data: res })

      if (!evalResultBool(res))
        return;

      var redundant = progressW.contains(inv)
      if (redundant) {
        progressW.markInvariant(inv, "duplicate")
        tracesW.immediateError("Duplicate Invariant!")
        return
      }

      all = res.length
      hold = res.filter(function (x) { return x; }).length

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
              progressW.markInvariant(foundInv[x], "implies");
              // foundInv[x] ==> JSinv
              tracesW.immediateError("Implied by existing invariant!")
              tracesW.disableSubmit();
            }
            else {
              gl.pwupSuggestion.invariantTried(jsInv);

              foundInv.push(inv)
              foundJSInv.push(jsInv)
              progressW.addInvariant(inv);

              var addScore = computeScore(jsInv, 1)

              if (addScore == 1) { // No powerups applied
                gl.setPowerups(gl.pwupSuggestion.getPwups());
              }

              addScore += getBonus(player)

              scoreW.add(addScore);

              if (!progress.satisfied) {
                goalSatisfied(gl.curGoal, foundJSInv,
                  function(newProgress) {
                    progress = newProgress
                    if (progress.satisfied) {
                      gl.lvlPassed();
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
    gl.curGoal = lvl.goal;
    stickyW.clear();
    //progW.clear();
    progressW.clear();
    tracesW.clearError();
    //scoreW.clear();
    tracesW.loadData(lvl);
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
    tracesW.setExp("");
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
