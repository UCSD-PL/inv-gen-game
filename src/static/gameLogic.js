function GameLogic(tracesW, progressW, scoreW, msgW) {
  var gl = this;
  var erorrTimer = null;

  gl.tracesW = tracesW;
  gl.progressW = progressW;
  gl.scoreW = scoreW;
  gl.msgW = msgW;

  gl.userInput = function () {
    msgW.onInput();
    msgW.clear();
    progressW.clearMarks();

    var inv = invPP(tracesW.curExp().trim());
    try {
      var parsedInv = esprima.parse();
    } catch (err) {
      log("Error parsing: " + err)
      msgW.delayedError(inv + " is not a valid expression.");
      return;
    }

    if (inv.length == 0) {
      tracesW.evalResult({ clear: true })
      return;
    }

    try {
      res = invEval(invToJS(inv), data)
      tracesW.evalResult({ data: res })

      if (!evalResultBool(res))
        return;

      var redundant = progW.contains(inv)
      if (redundant) {
        progW.markInvariant(inv, "duplicate")
        msgW.immediateError("Duplicate Invariant!")
        return
      }

      all = res.length
      hold = res.filter(function (x) { return x; }).length
      
      if (hold < all)
        msgW.error("Holds for " + hold + "/" + all + " cases.")
      else {
        isTautology(invToJS(inv), function(res) {
          if (res) {
            msgW.error("This is a tautology...")
            return
          }
          progW.addInvariant(inv);
          scoreW.add(1);
        })
      }

    } catch (err) {
      msgW.delayedError(interpretError(err))
    }
  }

  gl.loadLvl = function(lvl) {
    progW.clear();
    msgW.clear();
    scoreW.clear();
    tracesW.loadData(lvl);
    tracesW.setExp("");
    gl.userInput();
  }

  tracesW.changed(function () {
    gl.userInput();
  })

}
