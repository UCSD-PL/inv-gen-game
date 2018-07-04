define(["require", "exports", "./util", "./pp"], function (require, exports, util_1, pp_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    class BaseTracesWindow {
        constructor(parent) {
            this.parent = parent;
            this.ppInv = "";
            this.okToSubmit = false;
            this.data = [[], [], []];
            this.dataMap = [[], [], []];
            $(this.parent).addClass("positioned");
            $(this.parent).addClass("box");
            $(this.parent).addClass("tracesWindow");
        }
        immediateError(msg) {
            $("th #errormsg").html("<div class='error'> " + msg + "</div>");
            this.reflowCb();
        }
        delayedError(msg, errorDelay = 2000) {
            let traceW = this;
            this.errorTimer = setTimeout(() => traceW.immediateError(msg), errorDelay);
        }
        immediateMsg(msg) {
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
        error(msg) { this.immediateError(msg); }
        msg(msg) { this.immediateMsg(msg); }
        setVariables(lvl) {
            let hstr = "<table id='lvl_table' class='table table-stripped'><thead><tr>";
            for (let i in lvl.variables) {
                hstr += "<th>" + lvl.variables[i] + "</th>";
            }
            hstr += '<th><input id="formula-entry" tabindex="-1" type="text"><span id="errormsg"><div>&nbsp;</div></span></th>';
            hstr += '</tr></thead><tbody></tbody></table>';
            $(this.parent).html(hstr);
            $('#formula-entry').focus();
            var tW = this;
            $('#formula-entry').keyup(function (keyEv) {
                let curInv = pp_1.invPP(tW.curExp());
                if (keyEv.keyCode == 13 && tW.okToSubmit) {
                    tW.commitCb();
                }
                else if (curInv !== tW.ppInv) {
                    tW.ppInv = curInv;
                    tW.changedCb();
                }
            });
            this.dataMap = [[], [], []];
            this.data = [[], [], []];
            util_1.das.reflowAll();
        }
        curExp() {
            let v = $("#formula-entry").val();
            return (v === undefined ? "" : v);
        }
        setExp(exp) {
            $("#formula-entry").val(exp);
            this.changedCb();
        }
        onChanged(cb) { this.changedCb = cb; }
        onCommit(cb) { this.commitCb = cb; }
        onMoreExamples(cb) { this.moreExCb = cb; }
        enableSubmit() { this.okToSubmit = true; }
        disableSubmit() { this.okToSubmit = false; }
        disable() { $("#formula-entry").attr("disabled", "disabled"); }
        enable() { $("#formula-entry").removeAttr("disabled"); }
        highlightRect(x, y, w, h, border_style, backgroud_style) {
            for (let i = x; i < x + w; i++) {
                $("#" + y + "_" + i).css('border-top', border_style);
                $("#" + (y + h - 1) + "_" + i).css('border-bottom', border_style);
            }
            for (let j = y; j < y + h; j++) {
                $("#" + j + "_" + x).css('border-left', border_style);
                $("#" + j + "_" + (x + w - 1)).css('border-right', border_style);
            }
            for (let i = x; i < x + w; i++) {
                for (let j = y; j < y + h; j++) {
                    $("#" + j + "_" + i).css('background-color', backgroud_style);
                }
            }
        }
        clearRect(x, y, w, h) {
            this.highlightRect(x, y, w, h, "", "");
        }
        reflowCb() { util_1.das.reflowAll(); }
        setResultCell(row, datum) {
            let cell = row.children('.temp_expr_eval');
            if (typeof (datum) != 'number' || (!isNaN(datum)) && datum !== Infinity && datum !== -Infinity) {
                cell.html(JSON.stringify(datum));
            }
            else {
                // TODO: Hack - assuming all NaNs come from division by 0
                cell.html("<span class='error'>Error! Did you divide by 0? Try * instead?</span>");
            }
            cell.removeClass('true false greyed');
            if (typeof (datum) == "boolean")
                cell.addClass(datum ? 'true' : 'false');
        }
        greyRow(row) {
            $(row).children("td")
                .html("&nbsp")
                .removeClass("true false")
                .addClass("greyed");
        }
        ungreyRow(row, data, type) {
            let dataCols = $(row).children("td").not(".temp_expr_eval");
            dataCols.each(function (i) {
                $(this).html(data[i]).removeClass("greyed true false").addClass(type);
            });
            $(row).children(".temp_expr_eval")
                .removeClass("greyed true false");
        }
    }
    exports.BaseTracesWindow = BaseTracesWindow;
    class PositiveTracesWindow extends BaseTracesWindow {
        addData(data) {
            // For now support a single inductive counterexample
            util_1.assert(data[1].length === 0 && data[2].length === 0);
            let classes = ["true", "false", "inductive"];
            let id = $("table#lvl_table tr.traces-row").length;
            let lbls = [];
            for (let i in data[0]) {
                let data_id = this.data[0].length;
                let col_id = 0;
                let curRow = $("<tr class='traces-row' id='" + id + "'>" +
                    data[0][i].map(el => "<td class='" + classes[0] + "' id='" + id + "_" + col_id++ + "'>" + el + "</td>").join("") +
                    "<td class='temp_expr_eval'>&nbsp</td>" +
                    "</tr>");
                this.data[0].push(data[0][i]);
                $("table#lvl_table tbody").append(curRow);
                this.dataMap[0][data_id] = curRow;
                id++;
            }
            util_1.das.reflowAll();
        }
        evalResult(res) {
            if (res.hasOwnProperty("data")) {
                let resD = res;
                for (let type in resD.data) {
                    for (let i in resD.data[type]) {
                        let datum = resD.data[type][i];
                        let row = this.dataMap[type][i];
                        this.setResultCell(row, datum);
                    }
                }
            }
            else if (res.hasOwnProperty("clear")) {
                $(".temp_expr_eval").html("");
                $(".traces-row td.temp_expr_eval").removeClass("true");
                $(".traces-row td.temp_expr_eval").removeClass("false");
            }
            util_1.das.reflowAll();
        }
    }
    exports.PositiveTracesWindow = PositiveTracesWindow;
    class TwoPlayerTracesWindow extends BaseTracesWindow {
        constructor(playerNum, parent) {
            super(parent);
            this.playerNum = playerNum;
            this.parent = parent;
            this.player = playerNum;
            $(this.parent).removeClass("tracesWindow");
            if (this.player === 1) {
                $(this.parent).addClass("tracesWindow1");
            }
            else if (this.player === 2) {
                $(this.parent).addClass("tracesWindow2");
            }
        }
        getPlayer() {
            return this.player;
        }
        changed(cb) {
            this.changedCb = cb;
        }
        commit(cb) {
            this.commitCb = cb;
        }
        setVariables(lvl) {
            let hstr = "<table id='lvl_table" + this.player + "' class='table table-stripped'><thead><tr>";
            for (let i in lvl.variables) {
                hstr += "<th>" + lvl.variables[i] + "</th>";
            }
            if (this.player === 1) {
                hstr += "<th><input id='formula-entry' type='text'><span id='errormsg'>&nbsp</span></th>";
            }
            else if (this.player === 2) {
                hstr += "<th><input id='formula-entry2' type='text'><span id='errormsg'>&nbsp</span></th>";
            }
            hstr += "</tr></thead><tbody></tbody></table>";
            $(this.parent).html(hstr);
            if (this.player === 1) {
                $("#formula-entry").focus();
                let tW = this;
                $("#formula-entry").keyup(function (keyEv) {
                    let curInv = pp_1.invPP(tW.curExp());
                    if (keyEv.keyCode === 13 && tW.okToSubmit) {
                        tW.commitCb();
                        $("#formula-entry").blur();
                        setTimeout(function () { $("#btn-switch").click(); }, 2000);
                        $("#formula-entry2").focus();
                    }
                    else if (curInv !== tW.ppInv) {
                        tW.ppInv = curInv;
                        tW.changedCb();
                    }
                });
            }
            else if (this.player === 2) {
                $("#formula-entry2").focus();
                let tW = this;
                $("#formula-entry2").keyup(function (keyEv) {
                    let curInv = pp_1.invPP(tW.curExp());
                    if (keyEv.keyCode === 13 && tW.okToSubmit) {
                        tW.commitCb();
                        $("#formula-entry2").blur();
                        setTimeout(function () { $("#btn-switch2").click(); }, 2000);
                        $("#formula-entry").focus();
                    }
                    else if (curInv !== tW.ppInv) {
                        tW.ppInv = curInv;
                        tW.changedCb();
                    }
                });
            }
            this.dataMap = [[], [], []];
            this.data = [[], [], []];
            util_1.das.reflowAll();
        }
        addData(data) {
            util_1.assert(data[1].length === 0 && data[2].length === 0);
            let classes = ["true", "false", "inductive"];
            let id = $("table#lvl_table" + this.player + " tr.traces-row").length;
            let lbls = [];
            for (let i in data[0]) {
                let data_id = this.data[0].length;
                let curRow = $("<tr class='traces-row' id='" + id + "'>" + // this.player + id???
                    data[0][i].map(el => "<td class='" + classes[0] + "'>" + el + "</td>").join("") +
                    "<td class='temp_expr_eval'>&nbsp</td>" +
                    "</tr>");
                this.data[0].push(data[0][i]);
                $("table#lvl_table" + this.player + " tbody").append(curRow);
                this.dataMap[0][data_id] = curRow;
                id++;
            }
            util_1.das.reflowAll();
        }
        evalResult(res) {
            if (res.hasOwnProperty("data")) {
                let resD = res;
                for (let type in resD.data) {
                    for (let i in resD.data[type]) {
                        let datum = resD.data[type][i];
                        let row = this.dataMap[type][i];
                        this.setResultCell(row, datum);
                    }
                }
            }
            else if (res.hasOwnProperty("clear")) {
                $(".temp_expr_eval").html("");
                $(".traces-row td.temp_expr_eval").removeClass("true");
                $(".traces-row td.temp_expr_eval").removeClass("false");
            }
            util_1.das.reflowAll();
        }
        curExp() {
            let v = null;
            if (this.player === 1) {
                v = $("#formula-entry").val();
            }
            else if (this.player === 2) {
                v = $("#formula-entry2").val();
            }
            return (v === undefined ? "" : v);
        }
        setExp(exp) {
            if (this.player === 1) {
                $("#formula-entry").val(exp);
            }
            else if (this.player === 2) {
                $("#formula-entry2").val(exp);
            }
            this.changedCb();
        }
        disable() {
            if (this.player === 1) {
                $("#formula-entry").attr("disabled", "disabled");
            }
            else if (this.player === 2) {
                $("#formula-entry2").attr("disabled", "disabled");
            }
        }
        enable() {
            if (this.player === 1) {
                $("#formula-entry").removeAttr("disabled");
            }
            else if (this.player === 2) {
                $("#formula-entry2").removeAttr("disabled");
            }
        }
    }
});
//# sourceMappingURL=traceWindow.js.map