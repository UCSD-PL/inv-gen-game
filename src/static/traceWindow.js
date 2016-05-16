function TraceWindow(player, div, data) {
  var traceW = this;
  var errorTimer;

  traceW.getPlayer = function() { return player; }

  traceW.okToSubmit = false;

  traceW.immediateError = function (msg) {
    $("th #errormsg").html("<div class='error'> " + msg + "</div>");
  }

  traceW.immediateMsg = function (msg) {
    $("th #errormsg").html("<div class='msg'> " + msg + "</div>");
  }

  traceW.error = traceW.immediateError;
  traceW.msg = traceW.immediateMsg;

  traceW.delayedError = function (msg, errorDelay = 2000) {
    errorTimer = setTimeout(function() {
      traceW.immediateError(msg);
    }, errorDelay)
  }

  traceW.clearError = function () {
    if (errorTimer) {
      window.clearTimeout(errorTimer);
      errorTimer = null;
    }
    traceW.immediateError("&nbsp");
  }


  this.loadData = function(data) {
    hstr = '<table class="table table-stripped" id="traces' + player + '"><tr>';
    for (var i in data.variables) {
      hstr += '<th style="margin-top: 0px; border-top: 0px;">' + data.variables[i] + '</th>';
    }
    if(player == 1) {
      hstr += '<th style="margin-top: 0px; border-top: 0px;"><input id="formula-entry" type="text"><span id="errormsg">&nbsp</span></th>';
    }
    else {
      hstr += '<th style="margin-top: 0px; border-top: 0px;"><input id="formula-entry2" type="text"><span id="errormsg">&nbsp</span></th>';
    }

    hstr += '</tr>';

    for (var i in data.data) {
      hstr += '<tr id= "' + player + i + '" class="traces-row">';
      for (var j in data.data[i]) {
        hstr += '<td>' + data.data[i][j] + '</td>';
      }
      hstr += '<td class="temp_expr_eval">&nbsp</td></tr>';
    }
    hstr += '</table>'
    $(div).html(hstr)

    if(player == 1) {
      $('#formula-entry').focus();

      $('#formula-entry').keyup(function (keyEv) {
        if (keyEv.keyCode == 13 && traceW.okToSubmit) {
          traceW.commitCb();
          setTimeout(function() {$('#btn-switch').click();}, 2000);
          $('#formula-entry2').focus();
        } else
          traceW.changedCb();
      })

      $('#formula-entry').focus();
    }
    else {
      $('#formula-entry2').focus();

      $('#formula-entry2').keyup(function (keyEv) {
        if (keyEv.keyCode == 13 && traceW.okToSubmit) {
          traceW.commitCb();
          setTimeout(function() {$('#btn-switch2').click();}, 2000);
          $('#formula-entry').focus();
        } else
          traceW.changedCb();
      })

      $('#formula-entry2').focus();
    }

  }

  this.curExp = function () {
    var v = null;
    if(player == 1) {
      v = $('#formula-entry').val();
    }
    else {
      v = $('#formula-entry2').val();
    }
    return (v === undefined ? "" : v);
  }

  this.setExp = function (exp) {
    if (player == 1) {
      $('#formula-entry').val(exp);
    }
    else {
      $('#formula-entry2').val(exp);
    }
    traceW.changedCb();
  }

  this.changed = function (cb) {
    traceW.changedCb = cb;
  }

  this.commit = function (cb) {
    traceW.commitCb = cb;
  }

  /* not working for tutorial */
  this.evalResult = function (res) {
    if(player == 1) {
      if (res.data) {
        for (var i in res.data) {
          $('#' + player + i + ' .temp_expr_eval').html(JSON.stringify(res.data[i]))
        }

        for (var i in res.data) {
          $('#' + player + i).removeClass('true')
          $('#' + player + i).removeClass('false')
          if (typeof(res.data[i]) == "boolean") {
            $('#' + player + i).addClass(res.data[i] ? 'true' : 'false')
          }
        }
      } else if (res.clear) {
        $('.temp_expr_eval').html('');
        $('.traces-row').removeClass('true')
        $('.traces-row').removeClass('false')
      }
    }
    else {
      if (res.data) {
        for (var i in res.data) {
          $('#' + player + i + ' .temp_expr_eval').html(JSON.stringify(res.data[i]))
        }

        for (var i in res.data) {
          $('#' + player + i).removeClass('true')
          $('#' + player + i).removeClass('false')
          if (typeof(res.data[i]) == "boolean")
            $('#' + player + i).addClass(res.data[i] ? 'true' : 'false')
        }
      } else if (res.clear) {
        $('.temp_expr_eval').html('');
        $('.traces-row').removeClass('true')
        $('.traces-row').removeClass('false')
      }
    }
  }

  this.enableSubmit = function () { traceW.okToSubmit = true; }
  this.disableSubmit = function () { traceW.okToSubmit = false; }

  this.disable = function () {
    if (player == 1) {
      $('#formula-entry').attr('disabled', 'disabled');
    }
    else {
      $('#formula-entry2').attr('disabled', 'disabled');
    }
  }

  this.enable = function () {
    if (player == 1) {
      $('#formula-entry').removeAttr('disabled');
    }
    else {
      $('#formula-entry2').removeAttr('disabled');
    }
  }

  if (data  !== undefined) {
    this.loadData(data)
  }

  $(div).addClass('box')
  if(player == 1) {
    $(div).addClass('tracesWindow1')
  }
  else {
    $(div).addClass('tracesWindow2')
  }
}
