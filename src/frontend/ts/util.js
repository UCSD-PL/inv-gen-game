define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    function emptyStrset() {
        return new Set();
    }
    exports.emptyStrset = emptyStrset;
    function toStrset(strs) {
        let res = emptyStrset();
        for (let x of strs) {
            res.add(x);
        }
        return res;
    }
    exports.toStrset = toStrset;
    function isMember(s, x) {
        return s.has(x);
    }
    exports.isMember = isMember;
    function isSubset(s1, s2) {
        for (let k of s1) {
            if (!isMember(s2, k))
                return false;
        }
        return true;
    }
    function difference(s1, s2) {
        let res = emptyStrset();
        for (let k of s1) {
            if (isMember(s2, k))
                continue;
            res.add(k);
        }
        return res;
    }
    exports.difference = difference;
    function isEmpty(s) {
        return s.size === 0;
    }
    exports.isEmpty = isEmpty;
    function any_mem(s) {
        for (let k of s) {
            return k;
        }
    }
    exports.any_mem = any_mem;
    function log(arg) { console.log(arg); }
    exports.log = log;
    function error(arg) { log(arg); }
    exports.error = error;
    function assert(c, msg) {
        if (msg === undefined)
            msg = "Oh-oh";
        if (!c)
            throw msg || "Assertion failed.";
    }
    exports.assert = assert;
    function fst(x) { return x[0]; }
    function snd(x) { return x[1]; }
    class Args {
        static parse_args() {
            if (Args.parsed)
                return;
            let query = window.location.search.substring(1).split("&");
            for (let i = 0; i < query.length; i++) {
                if (query[i] === "")
                    continue;
                let param = query[i].split("=");
                Args.args[decodeURIComponent(param[0])] = decodeURIComponent(param[1] || "");
            }
            Args.hit_id = Args.args["hitId"];
            Args.worker_id = Args.args["workerId"] || "";
            Args.assignment_id = Args.args["assignmentId"];
            Args.turk_submit_to = Args.args["turkSubmitTo"];
            Args.tutorial_action = Args.args["tutorialAction"];
            Args.admin_token = Args.args["adminToken"];
            Args.mode = Args.args["mode"] || "patterns";
            Args.noifs = Args.args.hasOwnProperty("noifs");
            Args.use_new_var_powerup = !!+Args.args["nvpower"];
            Args.individual_mode = !!+Args.args["individual"];
            Args.consent = !!+Args.args["consent"];
            Args.parsed = true;
        }
        static get_hit_id() {
            Args.parse_args();
            return Args.hit_id;
        }
        static get_worker_id() {
            Args.parse_args();
            return Args.worker_id;
        }
        static get_assignment_id() {
            Args.parse_args();
            return Args.assignment_id;
        }
        static get_turk_submit_to() {
            Args.parse_args();
            return Args.turk_submit_to;
        }
        static get_tutorial_action() {
            Args.parse_args();
            return Args.tutorial_action;
        }
        static get_admin_token() {
            Args.parse_args();
            return Args.admin_token;
        }
        static get_mode() {
            Args.parse_args();
            return Args.mode;
        }
        static get_noifs() {
            Args.parse_args();
            return Args.noifs;
        }
        static get_use_new_var_powerup() {
            Args.parse_args();
            return Args.use_new_var_powerup;
        }
        static get_individual_mode() {
            Args.parse_args();
            return Args.individual_mode;
        }
        static get_consent() {
            Args.parse_args();
            return Args.consent;
        }
    }
    Args.parsed = false;
    Args.args = {};
    Args.hit_id = null;
    Args.worker_id = null;
    Args.assignment_id = null;
    Args.turk_submit_to = null;
    Args.tutorial_action = null;
    Args.admin_token = null;
    Args.mode = null;
    Args.noifs = false;
    Args.use_new_var_powerup = false;
    Args.individual_mode = false;
    Args.consent = false;
    exports.Args = Args;
    function shuffle(arr) {
        let j = null;
        for (let i = 0; i < arr.length; i++) {
            j = Math.floor(Math.random() * arr.length);
            let x = arr[i];
            arr[i] = arr[j];
            arr[j] = x;
        }
    }
    ;
    class Label {
        constructor(pos_arg, txt, direction, pulseWidth = 5, pulse = 500) {
            this.txt = txt;
            this.direction = direction;
            this.pulseWidth = pulseWidth;
            this.pulse = pulse;
            if (pos_arg.hasOwnProperty("of")) {
                this.pos = pos_arg;
            }
            else {
                this.pos = {
                    of: pos_arg
                };
                if (direction === "up") {
                    this.pos["at"] = "center bottom";
                }
                else if (direction === "down") {
                    this.pos["at"] = "center top";
                }
                else if (direction === "left") {
                    this.pos["at"] = "right center";
                }
                else if (direction === "right") {
                    this.pos["at"] = "left center";
                }
            }
            function _strPos(s) {
                return s[0] + (s[1] > 0 ? '+' : '') + (s[1] != 0 ? s[1] : "") + " " +
                    s[2] + (s[3] > 0 ? '+' : '') + (s[3] != 0 ? s[3] : "");
            }
            let clazz = "", text_pos = "", arrow_pos = "";
            let vec = [0, 0], arr_off = [0, 0];
            if (direction == "up") {
                clazz = "arrow_up";
                text_pos = "top:  30px;";
                arrow_pos = "left:  20px; top:  20px;";
                arr_off = [0, 10];
                vec = [0, pulseWidth];
            }
            else if (direction == "down") {
                clazz = "arrow_down";
                text_pos = "top:  0px;";
                arrow_pos = "left:  20px; top:  40px;";
                arr_off = [0, -10];
                vec = [0, -pulseWidth];
            }
            else if (direction == "left") {
                clazz = "arrow_left";
                text_pos = "left:  30px; top: -10px;";
                arrow_pos = "left:  0px; top:  0px;";
                arr_off = [10, -5];
                vec = [pulseWidth, 0];
            }
            else if (direction == "right") {
                clazz = "arrow_right";
                text_pos = "float:  left;";
                arrow_pos = "float: right;";
                arr_off = [-15, -5];
                vec = [-pulseWidth, 0];
            }
            let div = $("<div class='absolute'><div class=" + clazz +
                " style='" + arrow_pos + "'></div><div style='" + text_pos +
                "position: relative; text-align: center;'>" + txt + "</div></div>");
            $("body").append(div);
            this.pos.collision = "none none";
            let arrowDiv = $(div).children('div')[0];
            let aPos = $(arrowDiv).position();
            let aPosOff = ["left", -aPos.left + arr_off[0], "top", -aPos.top + arr_off[1]];
            this.pos.my = _strPos(aPosOff);
            $(div).position(this.pos);
            this.pos.using = (css, dummy) => $(div).animate(css, pulse / 2);
            let ctr = 0;
            let lbl = this;
            this.timer = setInterval(function () {
                let v = (ctr % 2 == 0 ? aPosOff : [aPosOff[0], aPosOff[1] + vec[0], aPosOff[2], aPosOff[3] + vec[1]]);
                lbl.pos.my = _strPos(v);
                $(div).position(lbl.pos);
                ctr++;
            }, this.pulse / 2);
            this.elem = div;
        }
        remove() {
            this.elem.remove();
            clearInterval(this.timer);
        }
    }
    exports.Label = Label;
    function removeLabel(l) {
        l.remove();
    }
    exports.removeLabel = removeLabel;
    function label(arg, txt, direction, pulseWidth = 5, pulse = 500) {
        if (arg.hasOwnProperty("get")) {
            return new Label(arg.get()[0], txt, direction, pulseWidth, pulse);
        }
        else {
            return new Label(arg, txt, direction, pulseWidth, pulse);
        }
    }
    exports.label = label;
    class Script {
        constructor(steps) {
            this.steps = steps;
            this.step = -1;
            this.cancelCb = null;
            this.nextStep();
        }
        nextStep() {
            this.step++;
            this.cancelCb = null;
            this.steps[this.step].setup(this);
        }
        nextStepOnKeyClickOrTimeout(timeout, destructor, keyCode = null) {
            let s = this;
            if (timeout > 0) {
                this.timeoutId = setTimeout(function () {
                    $("body").off("keyup");
                    $("body").off("keypress");
                    $("body").off("click");
                    destructor();
                    s.nextStep();
                }, timeout);
            }
            this.cancelCb = function () {
                if (timeout > 0)
                    clearTimeout(s.timeoutId);
                $("body").off("keyup");
                $("body").off("keypress");
                $("body").off("click");
                destructor();
            };
            $("body").keypress(function (ev) {
                if (keyCode === null || ev.which === keyCode) {
                    ev.stopPropagation();
                    return false;
                }
            });
            $("body").keyup(function (ev) {
                if (keyCode === null || ev.which === keyCode) {
                    if (timeout > 0)
                        clearTimeout(s.timeoutId);
                    $("body").off("keyup");
                    $("body").off("keypress");
                    $("body").off("click");
                    destructor();
                    //ev.stopPropagation();
                    s.nextStep();
                    return false;
                }
            });
            $("body").click(function (ev) {
                if (timeout > 0)
                    clearTimeout(s.timeoutId);
                $("body").off("keyup");
                $("body").off("keypress");
                $("body").off("click");
                destructor();
                //ev.stopPropagation();
                s.nextStep();
                return false;
            });
            $("body").focus();
        }
        cancel() {
            if (this.cancelCb)
                this.cancelCb();
            this.step = this.steps.length + 1;
        }
    }
    exports.Script = Script;
    /* In-place union - modifies s1 */
    function union(s1, s2) {
        for (let e of s2) {
            s1.add(e);
        }
        return s1;
    }
    exports.union = union;
    function setlen(s) {
        return s.size;
    }
    exports.setlen = setlen;
    function forAll(boolL) {
        return boolL.map(x => x ? 1 : 0).reduce((x, y) => x + y, 0) === boolL.length;
    }
    function zip(a1, a2) {
        return a1.map((_, i) => [a1[i], a2[i]]);
    }
    exports.zip = zip;
    class KillSwitch {
        constructor(parent) {
            this.parent = parent;
            this.pos = 0;
            this.onFlipCb = (i) => 0;
            this.container = $("<div class='kill-switch' style='position: absolute;'></div>");
            let pOff = $(this.parent).offset();
            let pW = $(this.parent).width();
            exports.das.position(this.container[0], {
                my: "right center",
                of: this.parent,
                at: "right-40 bottom"
            });
            $("body").append(this.container);
            let ks = this;
            this.container.click(function () {
                if (ks.pos === 0) {
                    ks.pos = 1;
                }
                else {
                    ks.pos = 0;
                }
                ks.refresh();
                ks.onFlipCb(ks.pos);
            });
            this.refresh();
        }
        onFlip(cb) {
            this.onFlipCb = cb;
        }
        refresh() {
            if (this.pos === 0) {
                this.container.html("<img src='knife-up.gif' style='width: 30; height: 60px;'/>");
            }
            else {
                this.container.html("<img src='knife-down.gif' style='width: 30; height: 60px;'/>");
            }
        }
        destroy() {
            this.container.remove();
            exports.das.remove(this.container[0]);
        }
        flip() {
            this.container.click();
        }
    }
    class DynamicAttachments {
        constructor() {
            this.objs = [];
        }
        position(target, spec) {
            for (let i in this.objs) {
                if (this.objs[i][0] === target) {
                    this.objs[i][1] = spec;
                    $(target).position(spec);
                    return;
                }
            }
            this.objs.push([target, spec]);
            $(target).position(spec);
        }
        reflowAll() {
            for (let i in this.objs) {
                $(this.objs[i][0]).position(this.objs[i][1]);
            }
        }
        remove(elmt) {
            this.objs = this.objs.filter((item) => item[0] !== elmt);
        }
    }
    exports.das = new DynamicAttachments();
    function disableBackspaceNav() {
        $(document).unbind("keydown").bind("keydown", function (event) {
            let doPrevent = false;
            if (event.keyCode === 8) {
                let d = event.srcElement || event.target;
                if (d.tagName.toUpperCase() === "INPUT") {
                    let di = d;
                    if (di.type.toUpperCase() === "TEXT" ||
                        di.type.toUpperCase() === "PASSWORD" ||
                        di.type.toUpperCase() === "FILE" ||
                        di.type.toUpperCase() === "SEARCH" ||
                        di.type.toUpperCase() === "EMAIL" ||
                        di.type.toUpperCase() === "NUMBER" ||
                        di.type.toUpperCase() === "DATE") {
                        doPrevent = di.readOnly || di.disabled;
                    }
                    else {
                        doPrevent = true;
                    }
                }
                else if (d.tagName.toUpperCase() === "TEXTAREA") {
                    let dta = d;
                    doPrevent = dta.readOnly || dta.disabled;
                }
                else {
                    doPrevent = true;
                }
                if (doPrevent) {
                    event.preventDefault();
                }
            }
        });
    }
    exports.disableBackspaceNav = disableBackspaceNav;
    function shape_eq(o1, o2) {
        if (typeof (o1) != typeof (o2))
            return false;
        if (typeof (o1) == "number" || typeof (o1) == "boolean" || typeof (o1) == "string") {
            return o1 === o2;
        }
        if (typeof (o1) == "object") {
            for (var i in o1) {
                if (!o1.hasOwnProperty(i))
                    continue;
                if (!o2.hasOwnProperty(i))
                    continue;
                if (!shape_eq(o1[i], o2[i]))
                    return false;
            }
            for (var i in o2) {
                if (o2.hasOwnProperty(i) && !o1.hasOwnProperty(i))
                    return false;
            }
            return true;
        }
        assert(false, "Unexpected objects being compared: " + o1 + " and " + o2);
    }
    function unique(l, id) {
        let dict = {};
        for (var x in l) {
            dict[id(l[x])] = l[x];
        }
        let res = [];
        for (var key in dict) {
            if (!dict.hasOwnProperty(key))
                continue;
            res.push(dict[key]);
        }
        return res;
    }
    exports.unique = unique;
    function isin(needle, hay, id) {
        let key = id(needle);
        for (var i in hay) {
            if (id(hay[i]) == key)
                return true;
        }
        return false;
    }
    function min(...args) {
        let min = args[0];
        for (var i in args)
            if (args[i] < min) {
                min = args[i];
            }
        return min;
    }
    exports.min = min;
    function queryAppend(qStr, append) {
        if (qStr == "") {
            qStr += "?";
        }
        else {
            qStr += "&";
        }
        return qStr + append;
    }
    exports.queryAppend = queryAppend;
});
//# sourceMappingURL=util.js.map