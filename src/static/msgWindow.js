function MsgWindow(div) {
  var errorTimer;
  var msgW = this;
  msgW.element = div;

  msgW.immediateError = function (msg) {
    $(div).html("<div class='error'> " + msg + "</div>");
  }

  msgW.error = msgW.immediateError;

  msgW.delayedError = function (msg, errorDelay = 2000) {
    errorTimer = setTimeout(function() {
      msgW.immediateError(msg);
    }, errorDelay)
  }

  msgW.clear = function () {
    if (errorTimer) {
      window.clearTimeout(errorTimer);
      errorTimer = null;
    }
    msgW.immediateError("");
  }

  msgW.onInput = function () {
    if (errorTimer) {
      window.clearTimeout(errorTimer);
      errorTimer = null;
    }
  }
}
