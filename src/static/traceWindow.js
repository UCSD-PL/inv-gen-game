function TraceWindow(div, data) {
  var traceW = this;

  this.loadData = function(data) {
    hstr = '<table class="table table-stripped"><tr>';
    for (var i in data.variables) {
      hstr += '<th>' + data.variables[i] + '</th>';
    }
    hstr += '<th><input id="formula-entry" type="text"></th>';
        
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
      traceW.changedCb();
    })

    $('#formula-entry').focus();

  }

  this.curExp = function () { var v = $('#formula-entry').val(); return (v === undefined ? "" : v); }
  this.setExp = function (exp) { $('#formula-entry').val(exp); traceW.changedCb(); }
  this.changed = function (cb) {
    traceW.changedCb = cb;
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

  if (data  !== undefined)
    this.loadData(data)
}
