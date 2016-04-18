function CETraceWindow(div, data) {
  var traceW = this;
  var errorTimer;
  var pulseTimer;

  traceW.okToSubmit = false;
  traceW.dataMap = [[], [], []];
  traceW.data = [[], [], []];
  traceW.ppInv = ""

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

  this.setVariables = function(lvl) {
    hstr = '<table id="lvl_table" class="table table-stripped"><thead><tr>';
    for (var i in lvl.variables) {
      hstr += '<th>' + lvl.variables[i] + '</th>';
    }
    hstr += '<th><input id="formula-entry" type="text"><span id="errormsg">&nbsp</span></th>';
    hstr += '</tr></thead><tbody></tbody></table>';

    if (lvl.support_pos_ex) {
      hstr += '<div id="example_buttons"><button id="ask_pos_ex"> More Examples </button></div>'
    }

    $(div).html(hstr)
    $('#formula-entry').focus();
    $('#formula-entry').keyup(function (keyEv) {
      var curInv = invPP(traceW.curExp())
      if (keyEv.keyCode == 13 && traceW.okToSubmit) {
        traceW.commitCb();
      } else if (curInv != traceW.ppInv) {
        traceW.ppInv = curInv;
        traceW.changedCb();
      }
    })

    if (lvl.support_pos_ex) {
      $('#ask_pos_ex').click(function() {
        traceW.moreExCb("positive")
      })
    }

    traceW.dataMap = [[], [], []];
    traceW.data = [[], [], []];
  }

  this.clearData = function(type) {
    if (type == 2 && pulseTimer) {
      window.clearTimeout(pulseTimer);
      pulseTimer = null;
    }

    traceW.data[type] = []
    for (var i in traceW.dataMap[type]) {
      if (traceW.dataMap[type][i].length == 2) {
        traceW.dataMap[type][i][0].remove()
        traceW.dataMap[type][i][1].remove()
      } else
        traceW.dataMap[type][i].remove()
    }
    traceW.dataMap[type] = []
  }

  this.addData = function(data) {
    // For now support a single inductive counterexample
    assert (data[2].length <= 1); 
    classes = [ 'true', 'false', 'inductive' ]

    var id = $('table#lvl_table tr.traces-row').length

    for (var type in [0,1,2]) {
      for (var i in data[type]) {
        var data_id = traceW.data[type].length
        if (type != 2) {
          curRow = $(
            "<tr class='traces-row' id='" + id +"'>" +
              data[type][i].map(el => 
                "<td class='" + classes[type]  + "'>" + el + "</td>").join("") +
              "<td class='temp_expr_eval'>&nbsp</td>" +
            "</tr>")
        } else {
          curRow = [ $(
            "<tr class='traces-row' id='" + id +"_0'>" +
              data[type][i][0].map(el => 
                "<td class='false ind_disp'>" + el + "</td>").join("") +
              "<td class='temp_expr_eval'>&nbsp</td>"),
          $("<tr class='traces-row' id='" + id + "_1'>" +
              data[type][i][1].map(el => 
                "<td class='true ind_disp'>" + el + "</td>").join("") +
              "<td class='temp_expr_eval'>&nbsp</td>" +
            "</tr>") ]
          var i = 0;
          pulseTimer = setInterval(function () {
            $(curRow[i%2]).children(".ind_disp").effect("highlight", 1000);
            i++
          }, 1000)
        }

        id ++;
        traceW.data[type].push(data[type][i])


        for (var j = type; j >= 0; j --) {
          var dataM = traceW.dataMap[j]
          if (dataM.length > 0) {
            dataM[dataM.length - 1].after(curRow)
            break;
          }
        }

        if (j == -1) {
          $("table#lvl_table tbody").append(curRow)
        }

        traceW.dataMap[type][data_id] = curRow
      }
    }
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
    function _set(row, datum) {
      var cell = row.children('.temp_expr_eval')
      cell.html(JSON.stringify(datum))
      cell.removeClass('true false')
      if (typeof(datum) == "boolean")
        cell.addClass(datum ? 'true' : 'false')
    }

    if (res.data) {
      for (var type in res.data) {
        for (var i in res.data[type]) {
          var datum = res.data[type][i]
          var row = traceW.dataMap[type][i]

          if (row.length == 2) {
            _set(row[0], datum[0])
            _set(row[1], datum[1])
          } else
            _set(row, datum)
        }
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
    this.addData(data)
  }

  $(div).addClass('box')
  $(div).addClass('tracesWindow')
}
