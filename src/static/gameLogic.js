function GameLogic(tracesW, progressW, scoreW, stickyW) {
  var all_powerups = {
    var_only:
      { 
        html :  "Var Only - 2x",
        apply : function (inv, score) {
                  if (setlen(literals(inv)) == 0) {
                    return 2*score;
                  } else
                    return score;
                },
      },
  }
  var gl = this;

  var foundInv;
  var foundJSInv;
  var progress;
  var pwups;

  gl.tracesW = tracesW;
  gl.progressW = progressW;
  gl.scoreW = scoreW;
  gl.stickyW = stickyW;
  gl.curGoal = null;

  gl.clear = function () {
    foundInv = [];
    foundJSInv = [];
    gl.curGoal = null;
    progress = {}
    pwups = {};
  }

  var computeScore = function(inv, s) {
    for (var i in pwups) {
      if (pwups.hasOwnProperty(i))
        s = all_powerups[i].apply(inv, s)
    }
    return s;
  }

  gl.userInput = function () {
    tracesW.clearError();
    progressW.clearMarks();

    var inv = invPP(tracesW.curExp().trim());
    try {
      var parsedInv = esprima.parse(inv);
    } catch (err) {
      log("Error parsing: " + err)
      tracesW.delayedError(inv + " is not a valid expression.");
      return;
    }

    if (inv.length == 0) {
      tracesW.evalResult({ clear: true })
      return;
    }

    try {
      var jsInv = invToJS(inv)
      res = invEval(jsInv, data)
      tracesW.evalResult({ data: res })

      if (!evalResultBool(res))
        return;

      var redundant = progW.contains(inv)
      if (redundant) {
        progW.markInvariant(inv, "duplicate")
        tracesW.immediateError("Duplicate Invariant!")
        return
      }

      all = res.length
      hold = res.filter(function (x) { return x; }).length
      
      if (hold < all)
        tracesW.error("Holds for " + hold + "/" + all + " cases.")
      else {
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
              foundInv.push(inv)
              foundJSInv.push(jsInv)
              progW.addInvariant(inv);
              scoreW.add(computeScore(jsInv, 1));

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
    progW.clear();
    tracesW.clearError();
    scoreW.clear();
    tracesW.loadData(lvl);
    tracesW.setExp("");
    gl.userInput();
    gl.addPowerup("var_only");
  }

  gl.addPowerup = function(pwup) {
    if (!(pwup in all_powerups))
      throw "Powerup " + pwup + " not found";
    if (pwup in pwups) {
      return;
    }

    pwups[pwup] = stickyW.add(all_powerups[pwup].html);
  }

  gl.removePowerup = function(pwup) {
    if (!(pwup.name in pwups)) {
      return;
    }

    stickyW.remove(pwups[pwup.name]);
    delete pwups[pwup.name]
  }

  tracesW.changed(function () {
    gl.userInput();
  })

  gl.lvlPassed = function () {}

  gl.onLvlPassed = function (cb) {
    gl.lvlPassed = cb;
  }

  gl.clear();
}
