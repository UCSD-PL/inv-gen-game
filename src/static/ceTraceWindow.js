function CETraceWindow(div, data) {
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
    // For now assuming a level starts only with positive examples
    assert(data.data[1].length == 0 && data.data[2].length == 0);
    hstr = '<table id="data_table" class="table table-stripped"><tbody><tr>';
    for (var i in data.variables) {
      hstr += '<th>' + data.variables[i] + '</th>';
    }
    hstr += '<th><input id="formula-entry" type="text"><span id="errormsg">&nbsp</span></th>';
    hstr += '</tr>';
    for (var i in data.data[0]) {
      hstr += '<tr id= "' + i + '" class="traces-row">';
      for (var j in data.data[0][i]) {
        hstr += '<td class="true">' + data.data[0][i][j] + '</td>';
      }
      hstr += '<td class="temp_expr_eval">&nbsp</td></tr>';
    }
    hstr += '</tbody></table>'

    if (data.support_pos_ex) {
      hstr += '<div id="example_buttons"><button id="ask_pos_ex"> More Examples </button></div>'
    }

    $(div).html(hstr)
    $('#formula-entry').focus();
    $('#formula-entry').keyup(function (keyEv) {
      if (keyEv.keyCode == 13 && traceW.okToSubmit) {
        traceW.commitCb();
      } else
        traceW.changedCb();
    })

    $('#ask_pos_ex').click(function() {
      traceW.moreExCb("positive")
    })

    $('#formula-entry').focus();

  }

  this.addData = function(rows, type) {
    if (type == "positive")
      clazz = "true"
    else if (type == "negative")
      clazz = "false"
    else
      clazz = "inductive"

    nrows = $('table#data_table tr.traces-row').length
    $('table#data_table').append(rows.map(
      (row, ind) => "<tr class='traces-row' id='" + (ind + nrows) +"'>" +
        row.map(el => "<td class='" + clazz + "'>" + el + "</td>").join("") + 
        "<td class='temp_expr_eval'>&nbsp</td></tr>"
    ).join("\n"))
    this.changedCb()
  }

  this.curExp = function () { var v = $('#formula-entry').val(); return (v === undefined ? "" : v); }
  this.setExp = function (exp) { $('#formula-entry').val(exp); traceW.changedCb(); }
  this.changed = function (cb) {
    traceW.changedCb = cb;
  }

  this.commit = function (cb) {
    traceW.commitCb = cb;
  }

  this.moreExamples = function (cb) {
    traceW.moreExCb = cb;
  }

  this.evalResult = function (res) {
    if (res.data) {
      for (var i in res.data) {
        $('#' + i + ' .temp_expr_eval').html(JSON.stringify(res.data[i]))
      }

      for (var i in res.data) {
        $('#' + i + ' td.temp_expr_eval').removeClass('true')
        $('#' + i + ' td.temp_expr_eval').removeClass('false')
        if (typeof(res.data[i]) == "boolean")
          $('#' + i + ' td.temp_expr_eval').addClass(res.data[i] ? 'true' : 'false')
      }
    } else if (res.clear) {
      $('.temp_expr_eval').html('');
      $('.traces-row td.temp_expr_eval').removeClass('true')
      $('.traces-row td.temp_expr_eval').removeClass('false')
    }
  }

  this.enableSubmit = function () { traceW.okToSubmit = true; }
  this.disableSubmit = function () { traceW.okToSubmit = false; }
  this.disable = function () { $('#formula-entry').attr('disabled', 'disabled'); }
  this.enable = function () { $('#formula-entry').removeAttr('disabled'); }

  if (data  !== undefined)
  {
    this.loadData(data)
  }

  $(div).addClass('box')
  $(div).addClass('tracesWindow')
}
