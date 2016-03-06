function TraceWindow(div, data) {
  var traceW = this;
  var errorTimer;

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
    hstr = '<table class="table table-stripped"><tr>';
    for (var i in data.variables) {
      hstr += '<th>' + data.variables[i] + '</th>';
    }
    hstr += '<th><input id="formula-entry" type="text"><span id="errormsg">&nbsp</span></th>';
        
    hstr += '</tr>';
    for (var i in data.data) {
      hstr += '<tr id= "' + i + '" class="traces-row">';
      for (var j in data.data[i]) {
        hstr += '<td>' + data.data[i][j] + '</td>';
      }
      hstr += '<td class="temp_expr_eval">&nbsp</td></tr>';
    }
    hstr += '</table>'
    $(div).html(hstr)

    $('#formula-entry').keyup(function (keyEv) {
      if (keyEv.key == "Enter" && traceW.okToSubmit) {
        traceW.commitCb();
      } else
        traceW.changedCb();
    })

    $('#formula-entry').focus();

  }

  this.curExp = function () { var v = $('#formula-entry').val(); return (v === undefined ? "" : v); }
  this.setExp = function (exp) { $('#formula-entry').val(exp); traceW.changedCb(); }
  this.changed = function (cb) {
    traceW.changedCb = cb;
  }

  this.commit = function (cb) {
    traceW.commitCb = cb;
  }

  this.evalResult = function (res) {
    if (res.data) {
      for (var i in res.data) {
        $('#' + i + ' .temp_expr_eval').html(JSON.stringify(res.data[i]))
      }

      for (var i in res.data) {
        $('#' + i).removeClass('true')
        $('#' + i).removeClass('false')
        if (typeof(res.data[i]) == "boolean")
          $('#' + i).addClass(res.data[i] ? 'true' : 'false')
      }
    } else if (res.clear) {
      $('.temp_expr_eval').html('');
      $('.traces-row').removeClass('true')
      $('.traces-row').removeClass('false')
    }
  }

  this.enableSubmit = function () { traceW.okToSubmit = true; }
  this.disableSubmit = function () { traceW.okToSubmit = false; }
  this.disable = function () { $('#formula-entry').attr('disabled', 'disabled'); }
  this.enable = function () { $('#formula-entry').removeAttr('disabled'); }

  if (data  !== undefined)
    this.loadData(data)

  $(div).addClass('box')
  $(div).addClass('tracesWindow')
}
