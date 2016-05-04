function CETraceWindow(div, data) {
  var traceW = this;
  var errorTimer;

  traceW.okToSubmit = false;
  traceW.dataMap = [[], [], []];
  traceW.data = [[], [], []];
  traceW.ppInv = "";
  traceW.container = div;
  traceW.switches = []

  $(div).addClass('positioned')

  traceW.immediateError = function (msg) {
    $("th #errormsg").html("<div class='error'> " + msg + "</div>");
    das.reflowAll();
  }

  traceW.immediateMsg = function (msg) {
    $("th #errormsg").html("<div class='msg'> " + msg + "</div>");
    das.reflowAll();
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
    das.reflowAll();
  }

  this.clearData = function(type) {
    if (type == 2) {
      for (var i in traceW.switches) {
        traceW.switches[i].destroy()
      }
      traceW.switches = []
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
    das.reflowAll();
  }

  this.addData = function(data) {
    // For now support a single inductive counterexample
    assert (data[2].length <= 1); 
    classes = [ 'true', 'false', 'inductive' ]

    var id = $('table#lvl_table tr.traces-row').length
    var lbls = []
    var appendedData = traceW.data[0].length > 0 ||
                       traceW.data[1].length > 0 ||
                       traceW.data[2].length > 0;

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
              "<td class='greyed temp_expr_eval'>&nbsp</td>" +
            "</tr>") ]
        }

        traceW.data[type].push(data[type][i])

        for (var j = type; j >= 0; j --) {
          var dataM = traceW.dataMap[j]
          if (dataM.length > 0) {
            if (dataM[dataM.length - 1].length == 2) {
              dataM[dataM.length - 1][1].after(curRow)
            } else {
              dataM[dataM.length - 1].after(curRow)
            }
            break;
          }
        }

        if (j == -1) {
          // First Piece of data
          $("table#lvl_table tbody").append(curRow)
        }


        traceW.dataMap[type][data_id] = curRow

        if (type == 2) {
          traceW.switches.push(new KillSwitch(curRow[0]))
          traceW.switches[data_id].onFlip(traceW.changedCb)
        }
        id ++;

        if (appendedData) {
          // New piece of data - mark
          $(curRow).each(function () { 
            lbls.push(label({ of: $(this), at: "right center" }, "new", "left"))
          })
        }
      }
    }
    das.reflowAll();
    function mkLblCleaner(lbls) {
      return function () {
        for (var i in lbls)
          removeLabel(lbls[i])
      }
    }
    setTimeout(mkLblCleaner(lbls), 5000)
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
      cell.removeClass('true false greyed')
      if (typeof(datum) == "boolean")
        cell.addClass(datum ? 'true' : 'false')
    }
    function _grey(row) {
      $(row).children('td')
        .html('&nbsp')
        .removeClass('true false')
        .addClass('greyed')
    }
    function _ungrey(row, data, type) {
      var dataCols = $(row).children('td').not('.temp_expr_eval')
      dataCols.each(function (i) {
        $(this).html(data[i]).removeClass('greyed true false').addClass(type)
      })

      $(row).children('.temp_expr_eval')
        .removeClass('greyed true false')
    }

    if (res.data) {
      for (var type in res.data) {
        for (var i in res.data[type]) {
          var datum = res.data[type][i]
          var row = traceW.dataMap[type][i]

          if (row.length == 2) {
            var pos = this.switches[i].pos
            if (pos == 0) {
              _ungrey(row[0], traceW.data[type][i][0], "false")
              _grey(row[1])
              _set(row[0], datum[0])
            } else {
              _ungrey(row[0], traceW.data[type][i][0], "true")
              _ungrey(row[1], traceW.data[type][i][1], "true")
              _set(row[0], datum[0])
              _set(row[1], datum[1])
            }
          } else
            _set(row, datum)
        }
      }
    } else if (res.clear) {
      $('.temp_expr_eval').html('');
      $('.traces-row td.temp_expr_eval').removeClass('true')
      $('.traces-row td.temp_expr_eval').removeClass('false')

      for (var i in traceW.dataMap[2]) {
            var pos = this.switches[i].pos
            var row = traceW.dataMap[2][i]
            if (pos == 0) {
              _ungrey(row[0], traceW.data[2][i][0], "false")
              _grey(row[1])
            } else {
              _ungrey(row[0], traceW.data[2][i][0], "true")
              _ungrey(row[1], traceW.data[2][i][1], "true")
            }
      }

    }
    das.reflowAll();
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
