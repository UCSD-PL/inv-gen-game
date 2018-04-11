define(["require", "exports", "./pp"], function (require, exports, pp_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    class ProgressWindow {
        constructor(parent) {
            this.parent = parent;
            this.invMap = {};
            this.ctr = 0;
            $(this.parent).html("<div class='progressWindow box good centered positioned'>" +
                "Accepted expressions<br>" +
                "<ul id='good-invariants'></ul>" +
                "</div>");
            this.container = $(this.parent).children("div")[0];
        }
        ;
        addInvariant(key, invariant) {
            let invUl = $(this.container).children("#good-invariants")[0];
            $(invUl).append("<li class='good-invariant' id='good_" +
                this.ctr + "'>" + pp_1.invToHTML(invariant) + "</li>");
            this.invMap[key] = $('#good_' + this.ctr)[0];
            this.ctr++;
        }
        removeInvariant(key) {
            $(this.invMap[key]).remove();
            delete this.invMap[key];
        }
        markInvariant(key, state) {
            let invDiv = $(this.invMap[key]);
            if (invDiv == undefined) {
                console.log("Unknown invariant " + key);
                return;
            }
            if (state === "checking") {
            }
            else if (state === "duplicate") {
                invDiv.addClass("error");
            }
            else if (state === "tautology") {
            }
            else if (state === "implies") {
                invDiv.addClass("error");
            }
            else if (state === "counterexampled") {
                invDiv.addClass("error");
            }
            else if (state === "ok") {
                invDiv.removeClass("error");
            }
        }
        clearMarks() {
            for (let i in this.invMap) {
                $(this.invMap[i]).removeClass("error");
            }
        }
        clear() {
            let invUL = $(this.container).children("#good-invariants")[0];
            $(invUL).html("");
            this.invMap = {};
            this.ctr = 0;
        }
        contains(key) {
            return this.invMap.hasOwnProperty(key);
        }
    }
    exports.ProgressWindow = ProgressWindow;
    class IgnoredInvProgressWindow extends ProgressWindow {
        constructor(parent) {
            super(parent);
            this.parent = parent;
            $(this.parent).html("<div class='progressWindow box good centered positioned'>" +
                "Accepted expressions<br>" +
                "<ul id='good-invariants'></ul>" +
                "</div>" +
                "<div class='ignoreWindow box warn centered positioned'>" +
                "Ignored expressions<br>" +
                "<ul id='ignored-invariants'></ul>" +
                "</div>");
            this.container = $(this.parent).children("div")[0];
            this.ignoredContainer = $(this.parent).children("div")[1];
        }
        ;
        addIgnoredInvariant(key, inv) {
            let invUL = $(this.ignoredContainer).children("ul")[0];
            $(invUL).append("<li class='ignored-invariant' id='ign_" +
                this.ctr + "'>" + pp_1.invToHTML(inv) + "</li>");
            this.invMap[key] = $('#ign_' + this.ctr)[0];
            this.ctr++;
        }
        clear() {
            super.clear();
            let invUL = $(this.ignoredContainer).children("ul")[0];
            $(invUL).html('');
        }
    }
    class TwoPlayerProgressWindow extends ProgressWindow {
        constructor(playerNum, parent) {
            super(parent);
            this.playerNum = playerNum;
            this.parent = parent;
            this.player = playerNum;
            $(this.parent).html("");
            $(this.parent).addClass("box");
            $(this.parent).addClass("progressWindow");
            if (this.player === 1) {
                $(this.parent).html("<strong>Invariants</strong><br>" +
                    "<ul id='good-invariants' style='font-family: monospace; list-style-type: none; padding: 0px; text-align: center;'></ul>");
            }
            else if (this.player === 2) {
                $(this.parent).html("<strong>Invariants</strong><br>" +
                    "<ul id='good-invariants2' style='font-family: monospace; list-style-type: none; padding: 0px; text-align: center;'></ul>");
            }
            this.container = $(this.parent).children("div")[0];
        }
        addInvariant(key, invariant) {
            let invUl = null;
            if (this.player === 1) {
                // invUl = $(this.container).children("#good-invariants")[0];
                invUl = $("#good-invariants");
            }
            else if (this.player === 2) {
                // invUl = $(this.container).children("#good-invariants2")[0];
                invUl = $("#good-invariants2");
            }
            $(invUl).append("<li class='good-invariant' id='good_" + this.player +
                this.ctr + "'>" + pp_1.invToHTML(invariant) + "</li>");
            this.invMap[key] = $("#good_" + this.player + this.ctr)[0];
            this.ctr++;
        }
        markInvariant(key, state) {
            let invDiv = $(this.invMap[key]);
            // let invDiv = $(this.invMap[invariant]);
            if (invDiv === undefined) {
                console.log("Unknown invariant " + key);
                return;
            }
            if (state === "checking") {
            }
            else if (state === "duplicate") {
                invDiv.addClass("bold");
            }
            else if (state === "tautology") {
            }
            else if (state === "implies") {
                invDiv.addClass("bold");
            }
            else if (state === "counterexampled") {
                invDiv.addClass("bold");
            }
            else if (state === "ok") {
                invDiv.removeClass("bold");
            }
        }
        clearMarks() {
            for (let i in this.invMap) {
                $(this.invMap[i]).removeClass("bold");
            }
        }
        clear() {
            let invUL = null;
            if (this.player === 1) {
                invUL = $("#good-invariants");
            }
            else if (this.player === 2) {
                invUL = $("#good-invariants2");
            }
            $(invUL).html("");
            this.invMap = {};
            this.ctr = 0;
        }
    }
});
//# sourceMappingURL=progressWindow.js.map