type dataT = [any[][], any[][], [ any[], any[] ][] ]
type resDataT = { data: [ any[], any[], [any, any][] ]} 
type resClearT = { clear: any }
type resT = resDataT | resClearT

interface ITracesWindow {
  immediateError(msg:string): void;
  delayedError(msg:string): void;
  immediateMsg(msg:string): void;
  clearError(): void;

  error(msg:string): void;
  msg(msg:string): void;

  setVariables(lvl: Level): void;
  addData(data: dataT): void

  curExp(): string;
  setExp(exp: string): void;

  onChanged(cb: ()=>void): void;
  onCommit(cb: ()=>void): void;
  evalResult(res: resT): void;

  enable(): void;
  disable(): void;
  enableSubmit(): void;
  disableSubmit():  void;
}

abstract class BaseTracesWinow implements ITracesWindow {
  ppInv: string = "";
  okToSubmit: boolean = false;
  data: dataT = [ [], [], [] ];
  dataMap:  [ any[], any[], any[] ] = [ [], [], [] ];
  errorTimer: number;

  changedCb: ()=>void;
  commitCb: ()=>void;
  moreExCb: (typ:string)=>void;

  constructor (public parent: HTMLElement) {
    $(this.parent).addClass('positioned')
    $(this.parent).addClass('box')
    $(this.parent).addClass('tracesWindow')
  }

  immediateError(msg: string): void {
    $("th #errormsg").html("<div class='error'> " + msg + "</div>");
    this.reflowCb();
  }

  delayedError(msg: string, errorDelay: number= 2000) {
    let traceW = this;
    this.errorTimer = setTimeout(() => traceW.immediateError(msg), errorDelay)
  }

  immediateMsg(msg: string): void {
    $("th #errormsg").html("<div class='msg'> " + msg + "</div>");
    this.reflowCb();
  }

  clearError() {
    if (this.errorTimer) {
      window.clearTimeout(this.errorTimer);
      this.errorTimer = null;
    }
    this.immediateError("&nbsp");
  }

  error(msg:string): void { this.immediateError(msg); }
  msg(msg:string): void { this.immediateMsg(msg); }

  setVariables(lvl: Level): void {
    let hstr = '<table id="lvl_table" class="table table-stripped"><thead><tr>';
    for (var i in lvl.variables) {
      hstr += '<th>' + lvl.variables[i] + '</th>';
    }
    hstr += '<th><input id="formula-entry" type="text"><span id="errormsg">&nbsp</span></th>';
    hstr += '</tr></thead><tbody></tbody></table>';
    $(this.parent).html(hstr)
    $('#formula-entry').focus();
    var tW = this;
    $('#formula-entry').keyup(function (keyEv) {
      let curInv = invPP(tW.curExp())
      if (keyEv.keyCode == 13 && tW.okToSubmit) {
        tW.commitCb();
      } else if (curInv != tW.ppInv) {
        tW.ppInv = curInv;
        tW.changedCb();
      }
    })

    this.dataMap = [[], [], []];
    this.data = [[], [], []];
    das.reflowAll();
  }

  abstract addData(data: dataT): void;
  abstract evalResult(res: resT): void;

  curExp(): string {
   let v = $('#formula-entry').val();
   return (v === undefined ? "" : v);
  }

  setExp(exp:string) {
    $('#formula-entry').val(exp);
    this.changedCb();
  }

  onChanged(cb:()=>void) { this.changedCb = cb; }
  onCommit (cb:()=>void) { this.commitCb = cb; }
  onMoreExamples(cb:()=>void) { this.moreExCb = cb; }
  enableSubmit(): void { this.okToSubmit = true; }
  disableSubmit(): void { this.okToSubmit = false; }
  disable(): void { $('#formula-entry').attr('disabled', 'disabled'); }
  enable(): void { $('#formula-entry').removeAttr('disabled'); }
  private reflowCb(): void { das.reflowAll(); }
  protected setResultCell(row: JQuery, datum: any): void {
    let cell = row.children('.temp_expr_eval')
    cell.html(JSON.stringify(datum))
    cell.removeClass('true false greyed')
    if (typeof(datum) == "boolean")
      cell.addClass(datum ? 'true' : 'false')
  }
  
  protected greyRow(row:JQuery):void {
    $(row).children('td')
      .html('&nbsp')
      .removeClass('true false')
      .addClass('greyed')
  }

  protected ungreyRow(row: JQuery, data: any, type: string): void {
    let dataCols = $(row).children('td').not('.temp_expr_eval')
    dataCols.each(function (i) {
      $(this).html(data[i]).removeClass('greyed true false').addClass(type)
    })

    $(row).children('.temp_expr_eval')
      .removeClass('greyed true false')
  }
}

class PositiveTracesWindow extends BaseTracesWinow {
  addData(data:dataT): void {
    // For now support a single inductive counterexample
    assert (data[1].length == 0 && data[2].length == 0); 
    let classes = [ 'true', 'false', 'inductive' ]
    var id = $('table#lvl_table tr.traces-row').length
    var lbls = []
    
    for (var i in data[0]) {
      var data_id = this.data[0].length
      let curRow = $(
          "<tr class='traces-row' id='" + id +"'>" +
            data[0][i].map(el => 
              "<td class='" + classes[0]  + "'>" + el + "</td>").join("") +
            "<td class='temp_expr_eval'>&nbsp</td>" +
          "</tr>")
      this.data[0].push(data[0][i])
      $("table#lvl_table tbody").append(curRow)
      this.dataMap[0][data_id] = curRow
      id ++;
    }
    das.reflowAll();
  }

  evalResult(res: resT):void {
    if (res.hasOwnProperty("data")) {
      let resD = <resDataT>res;

      for (var type in resD.data) {
        for (var i in resD.data[type]) {
          var datum = resD.data[type][i]
          var row = this.dataMap[type][i]
          this.setResultCell(row, datum)
        }
      }
    } else if (res.hasOwnProperty("clear")) {
      $('.temp_expr_eval').html('');
      $('.traces-row td.temp_expr_eval').removeClass('true')
      $('.traces-row td.temp_expr_eval').removeClass('false')
    }
    das.reflowAll();
  }
}

class CounterExampleTracesWindow extends BaseTracesWinow {
  switches: KillSwitch[] = [];
  clearData(type:number): void {
    if (type == 2) {
      for (var i in this.switches) {
        this.switches[i].destroy()
      }
      this.switches = []
    }

    this.data[type] = []
    for (var i in this.dataMap[type]) {
      if (this.dataMap[type][i].length == 2) {
        this.dataMap[type][i][0].remove()
        this.dataMap[type][i][1].remove()
      } else
        this.dataMap[type][i].remove()
    }
    this.dataMap[type] = []
    das.reflowAll();
  }

  addData(data:dataT) {
    // For now support a single inductive counterexample
    assert (data[2].length <= 1); 
    let classes = [ 'true', 'false', 'inductive' ]

    let id = $('table#lvl_table tr.traces-row').length
    let lbls = []
    let appendedData = this.data[0].length > 0 ||
                       this.data[1].length > 0 ||
                       this.data[2].length > 0;

    for (let type in [0,1,2]) {
      for (let i in data[type]) {
        let data_id = this.data[type].length
        let curRow: any = null;

        if (type != '2') {
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

        this.data[type].push(data[type][i])
        let added = false;

        for (let j = parseInt(type); j >= 0; j --) {
          var dataM = this.dataMap[j]
          if (dataM.length > 0) {
            if (dataM[dataM.length - 1].length == 2) {
              dataM[dataM.length - 1][1].after(curRow)
            } else {
              dataM[dataM.length - 1].after(curRow)
            }
            added = true
            break;
          }
        }

        if (!added) {
          // First Piece of data
          $("table#lvl_table tbody").append(curRow)
        }


        this.dataMap[type][data_id] = curRow

        if (type == '2') {
          this.switches.push(new KillSwitch(curRow[0]))
          this.switches[data_id].onFlip(this.changedCb)
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
    setTimeout(() => {
      for (var i in lbls)
        removeLabel(lbls[i])
    }, 5000)
    this.changedCb()
  }

  evalResult(res:resT): void {
    if (res.hasOwnProperty("data")) {
      let resD = <resDataT>res
      for (var type in resD.data) {
        for (var i in resD.data[type]) {
          var datum = resD.data[type][i]
          var row = this.dataMap[type][i]

          if (row.length == 2) {
            var pos = this.switches[i].pos
            if (pos == 0) {
              this.ungreyRow(row[0], this.data[type][i][0], "false")
              this.greyRow(row[1])
              this.setResultCell(row[0], datum[0])
            } else {
              this.ungreyRow(row[0], this.data[type][i][0], "true")
              this.ungreyRow(row[1], this.data[type][i][1], "true")
              this.setResultCell(row[0], datum[0])
              this.setResultCell(row[1], datum[1])
            }
          } else
            this.setResultCell(row, datum)
        }
      }
    } else if (res.hasOwnProperty("clear")) {
      $('.temp_expr_eval').html('');
      $('.traces-row td.temp_expr_eval').removeClass('true')
      $('.traces-row td.temp_expr_eval').removeClass('false')

      for (var i in this.dataMap[2]) {
            var pos = this.switches[i].pos
            var row = this.dataMap[2][i]
            if (pos == 0) {
              this.ungreyRow(row[0], this.data[2][i][0], "false")
              this.greyRow(row[1])
            } else {
              this.ungreyRow(row[0], this.data[2][i][0], "true")
              this.ungreyRow(row[1], this.data[2][i][1], "true")
            }
      }

    }
    das.reflowAll();
  }

}
