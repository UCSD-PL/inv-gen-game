function GameLogic(tracesW, progressW, scoreW, msgW) {
  var gl = this;

  var foundInv;
  var foundJSInv;
  var progress;

  gl.tracesW = tracesW;
  gl.progressW = progressW;
  gl.scoreW = scoreW;
  gl.msgW = msgW;
  gl.curGoal = null;

  gl.clear = function () {
    foundInv = [];
    foundJSInv = [];
    gl.curGoal = null;
    progress = {}
  }

  gl.userInput = function () {
    tracesW.clearError();
    progressW.clearMarks();

    var inv = invPP(tracesW.curExp().trim());
    try {
      var parsedInv = esprima.parse();
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
              scoreW.add(1);

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
    progW.clear();
    tracesW.clearError();
    scoreW.clear();
    tracesW.loadData(lvl);
    tracesW.setExp("");
    gl.userInput();
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
