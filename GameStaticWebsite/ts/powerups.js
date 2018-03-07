function isOneShotPowerup(obj) {
    return 'used' in obj;
}
function isLevelPowerup(obj) {
    return 'level_powerup_tag' in obj;
}
class BasePowerup {
    constructor(id, html, holds, transform, applies, tip) {
        this.id = id;
        this.html = html;
        this.holds = holds;
        this.transform = transform;
        this.applies = applies;
        this.tip = tip;
        this.element = $(html);
        this.element.attr("title", tip);
    }
    highlight(cb) {
        this.element.effect("highlight", { color: "#008000" }, 500, cb);
    }
}
// NOTE: This probably makes more sense as a mixin/interface pair.
class MultiplierPowerup extends BasePowerup {
    constructor(id, html, holds, mult, applies, tip) {
        super(id + "x", "<div class='pwup box'>" + html + "<div class='pwup-mul'>" + mult + "X</div></div>", holds, (x) => x * mult, applies, mult + "X if you " + tip);
        this.id = id;
        this.html = html;
        this.holds = holds;
        this.mult = mult;
        this.applies = applies;
    }
    highlight(cb) {
        this.element.effect("highlight", { color: "#008000" }, 2000, () => 0);
        let mulSpan = $("<span class='scoreText scoreFloat'>x" + this.mult + "</span>");
        $(this.element).append(mulSpan);
        $(mulSpan).position({ "my": "right center", "at": "left-10 center", "of": this.element });
        mulSpan.hide({ effect: "puff", easing: "swing", duration: 2000, complete: () => { mulSpan.remove(); cb(); } });
    }
    setMultiplier(newm) {
        this.mult = newm;
        while (this.tip.charAt(0) >= "0" && this.tip.charAt(0) <= "9") {
            this.tip = this.tip.slice(1);
        }
        this.tip = newm + this.tip;
        this.transform = (x) => x * newm;
        this.element.find("div.pwup-mul").html(newm + "X");
        this.element.find("div.pwup-mul").effect({ effect: "highlight", color: "red" });
        this.element.attr("title", this.tip);
    }
}
class NewVarPowerup extends MultiplierPowerup {
    constructor(varname, multiplier = 2) {
        super("NewVar=" + varname, varname + "<span style='position:absolute;left:4px;color:goldenrod'>" +
            "*</span>", (inv) => isMember(identifiers(inv), varname), multiplier, (lvl) => true, "use '" + varname + "' in an expression");
        this.level_powerup_tag = true;
        this.used = false;
    }
}
class VarOnlyPowerup extends MultiplierPowerup {
    constructor(multiplier = 2) {
        super("var only", "<span style='position: absolute; left:13px'>1</span>" +
            "<span style='position: absolute;color:red; left:10px'>&#10799;</span>", (inv) => setlen(literals(inv)) === 0, multiplier, (lvl) => true, "don't use constants");
    }
}
class UseXVarsPwup extends MultiplierPowerup {
    constructor(nvars, multiplier = 2) {
        super("NVars=" + nvars, nvars + "V", (inv) => setlen(identifiers(inv)) === nvars, multiplier, (lvl) => lvl.variables.length >= nvars && lvl.variables.length != 1, "you use " + nvars + " variable(s)");
    }
}
class UseOpsPwup extends MultiplierPowerup {
    constructor(ops, html, name, multiplier = 2) {
        super("Use ops: " + ops, html, (inv) => {
            let inv_ops = operators(inv);
            for (let i in ops) {
                if (inv_ops.has(ops[i]))
                    return true;
            }
            return false;
        }, multiplier, (lvl) => true, "use " + name);
    }
}
class PowerupSuggestionAll {
    constructor() {
        this.age = {};
        this.lbls = [];
        this.timers = [];
        this.all_pwups = [
            new VarOnlyPowerup(2),
            new UseOpsPwup(["<=", ">=", "<", ">", "!=="], "<>", "inequality"),
            new UseOpsPwup(["=="], "=", "equality"),
            new UseOpsPwup(["*", "/"], "*/", "multiplication or division"),
            new UseOpsPwup(["+", "-"], "&plusmn;", "addition or subtraction"),
            //new UseOpsPwup(["->"], "if", "if clause"),
            new UseOpsPwup(["%"], "%", "remainder after division by"),
        ];
    }
    clear(lvl) {
        this.all_pwups = this.all_pwups.filter(p => !isLevelPowerup(p));
        if (Args.get_use_new_var_powerup()) {
            for (let v of lvl.variables) {
                this.all_pwups.push(new NewVarPowerup(v));
            }
        }
        this.age = {};
        for (let p of this.all_pwups) {
            this.age[p.id] = 0;
            let mPwup = p;
            mPwup.setMultiplier(2);
        }
        this.clearLabels();
    }
    clearLabels() {
        for (let t of this.timers) {
            clearTimeout(t);
        }
        for (let l of this.lbls) {
            removeLabel(l);
        }
        this.timers = [];
        this.lbls = [];
    }
    invariantTried(inv) {
        for (let p of this.all_pwups) {
            if (p.holds(inv)) {
                this.age[p.id] = 0;
                if (isOneShotPowerup(p)) {
                    p.used = true;
                }
            }
            else {
                this.age[p.id]++;
            }
            let newM = 2 * (this.age[p.id] + 1);
            let mPwup = p;
            if (newM > mPwup.mult) {
                let fn = () => {
                    let delay = 1000 + (1000 * newM / 2);
                    let l = label({ "at": "left center", "of": mPwup.element }, "Went up to " + newM + "X !", "right");
                    let t = setTimeout(() => { removeLabel(l); }, delay);
                    this.timers.push(t);
                    this.lbls.push(l);
                };
                fn();
            }
            mPwup.setMultiplier(newM);
        }
    }
    getPwups() {
        return this.all_pwups.filter(p => !(isOneShotPowerup(p) && p.used));
    }
}
class PowerupSuggestionFullHistory {
    constructor(nDisplay, type) {
        this.nDisplay = nDisplay;
        this.type = type;
        this.all_pwups = [];
        this.actual = [];
        this.age = {};
        this.gen = 0;
        this.nUses = {};
        this.lastUse = {};
        this.sortFreq = []; // TODO: Rename
        this.sortLast = []; // TODO: Rename
        this.all_pwups = [
            new VarOnlyPowerup(2),
            new UseOpsPwup(["<=", ">=", "<", ">", "!=="], "<>", "inequality"),
            new UseOpsPwup(["=="], "=", "equality"),
            new UseOpsPwup(["*", "/"], "*/", "multiplication or division"),
            new UseOpsPwup(["+", "-"], "&plusmn;", "addition or subtraction"),
        ];
        for (let i in this.all_pwups) {
            this.nUses[this.all_pwups[i].id] = 0;
            this.lastUse[this.all_pwups[i].id] = 0;
        }
    }
    computeOrders() {
        let sugg = this;
        if (this.gen > 0)
            this.sortFreq = this.actual.map(function (x, ind) { return [sugg.nUses[x.id] / sugg.gen, x]; });
        else
            this.sortFreq = this.actual.map(function (x, ind) { return [0, x]; });
        this.sortLast = this.actual.map(function (x, ind) { return [sugg.lastUse[x.id], x]; });
        this.sortFreq.sort(function (a, b) { return a[0] - b[0]; });
        this.sortLast.sort(function (a, b) { return a[0] - b[0]; });
    }
    clear(lvl) {
        this.actual = [];
        this.age = {};
        for (let i in this.all_pwups) {
            if (this.all_pwups[i].applies(lvl)) {
                this.actual.push(this.all_pwups[i]);
            }
        }
        this.computeOrders();
    }
    invariantTried(inv) {
        this.gen++;
        for (let i in this.actual) {
            if (this.actual[i].holds(inv)) {
                this.nUses[this.actual[i].id]++;
                this.lastUse[this.actual[i].id] = this.gen;
            }
        }
        this.computeOrders();
    }
    getPwups() {
        if (this.type === "lru") {
            return this.sortLast.slice(0, this.nDisplay).map(([fst, snd]) => snd);
        }
        else {
            assert(this.type === "lfu");
            return this.sortFreq.slice(0, this.nDisplay).map(([fst, snd]) => snd);
        }
    }
}
class PowerupSuggestionFullHistoryVariableMultipliers extends PowerupSuggestionFullHistory {
    constructor() {
        super(...arguments);
        this.lbl = null;
        this.shown = {};
        this.timer = 0;
    }
    computeOrders() {
        super.computeOrders();
        let lst = (this.type == "lru" ? this.sortLast : this.sortFreq);
        this.shown = {};
        for (var i = 0; i < min(this.nDisplay, lst.length); i++) {
            this.shown[lst[i][1].id] = true;
        }
        if (this.lbl) {
            clearTimeout(this.timer);
            removeLabel(this.lbl);
            this.lbl = null;
        }
    }
    invariantTried(inv) {
        super.invariantTried(inv);
        let age = {};
        for (let pwup of this.actual) {
            let age = this.gen - this.lastUse[pwup.id];
            let newM = 2 * (Math.floor(age / 3) + 1);
            let mPwup = pwup;
            if (newM != mPwup.mult)
                mPwup.setMultiplier(newM);
            if (this.shown[pwup.id] && age > 7 && this.lbl == null) {
                this.lbl = label({ "at": "left center", "of": pwup.element }, "You haven't tried <br> this in a <br> while!", "right");
                this.timer = setTimeout(() => { removeLabel(this.lbl); }, 5000);
            }
        }
    }
}
// Two Player Stuff.
// TODO: Lots of code duplication. Resolve
class TwoPlayerBasePowerup {
    constructor(playerNum, id, html, holds, transform, applies, tip) {
        this.playerNum = playerNum;
        this.id = id;
        this.html = html;
        this.holds = holds;
        this.transform = transform;
        this.applies = applies;
        this.tip = tip;
        this.player = playerNum;
        this.element = $(html);
        this.element.attr("title", tip);
        this.element.tooltip({ position: {
                within: $(".container"),
                my: "center top+15",
                at: "center bottom",
                collision: "none none",
            } });
    }
    highlight(cb) {
        if (this.player === 1) {
            this.element.effect("highlight", { color: "#f00000" }, 500, cb);
        }
        else if (this.player === 2) {
            this.element.effect("highlight", { color: "#0000f0" }, 500, cb);
        }
    }
}
class TwoPlayerMultiplierPowerup extends TwoPlayerBasePowerup {
    constructor(playerNum, id, html, holds, mult, applies, tip) {
        super(playerNum, id + "x" + mult, (playerNum === 1) ?
            ("<div class='pwup1 box'>" + html + "<div class='pwup-mul'>" +
                mult + "X</div></div>")
            :
                ("<div class='pwup2 box'>" + html + "<div class='pwup-mul'>" +
                    mult + "X</div></div>"), holds, (x) => x * mult, applies, tip);
    }
}
class TwoPlayerVarOnlyPowerup extends TwoPlayerMultiplierPowerup {
    constructor(playerNum, multiplier = 2) {
        super(playerNum, "var only", "<span style='position: absolute; left:13px'>1</span>" +
            "<span style='position: absolute;color:red; left:10px'>&#10799;</span>", (inv) => setlen(literals(inv)) === 0, multiplier, (lvl) => true, multiplier + "X if you don't use constants");
    }
}
class TwoPlayerUseXVarsPwup extends TwoPlayerMultiplierPowerup {
    constructor(playerNum, nvars, multiplier = 2) {
        super(playerNum, "NVars=" + nvars, nvars + "V", (inv) => setlen(identifiers(inv)) === nvars, multiplier, (lvl) => lvl.variables.length >= nvars && lvl.variables.length !== 1, multiplier + "X if you use " + nvars + " variable(s)");
    }
}
class TwoPlayerUseOpsPwup extends TwoPlayerMultiplierPowerup {
    constructor(playerNum, ops, html, name, multiplier = 2) {
        super(playerNum, "Use ops: " + ops, html, (inv) => {
            let inv_ops = operators(inv);
            for (let op of ops) {
                if (isMember(inv_ops, op))
                    return true;
            }
            return false;
        }, multiplier, (lvl) => true, multiplier + "X if you use " + name);
    }
}
class TwoPlayerPowerupSuggestionFullHistory {
    constructor(playerNum, nDisplay, type) {
        this.playerNum = playerNum;
        this.nDisplay = nDisplay;
        this.type = type;
        this.all_pwups = [];
        this.actual = [];
        this.age = {};
        this.gen = 0;
        this.nUses = {};
        this.lastUse = {};
        this.sortFreq = []; // TODO: Rename
        this.sortLast = []; // TODO: Rename
        this.all_pwups = [
            new TwoPlayerVarOnlyPowerup(playerNum, 2),
            new TwoPlayerUseXVarsPwup(playerNum, 1, 2),
            new TwoPlayerUseXVarsPwup(playerNum, 2, 2),
            new TwoPlayerUseXVarsPwup(playerNum, 3, 2),
            new TwoPlayerUseXVarsPwup(playerNum, 4, 2),
            new TwoPlayerUseOpsPwup(playerNum, ["<=", ">=", "<", ">"], "<>", "inequality"),
            new TwoPlayerUseOpsPwup(playerNum, ["=="], "=", "equality"),
            new TwoPlayerUseOpsPwup(playerNum, ["*"], "*", "multiplication"),
            new TwoPlayerUseOpsPwup(playerNum, ["+"], "+", "addition"),
        ];
        for (let i in this.all_pwups) {
            this.nUses[this.all_pwups[i].id] = 0;
            this.lastUse[this.all_pwups[i].id] = -1;
        }
    }
    computeOrders() {
        let sugg = this;
        if (this.gen > 0)
            this.sortFreq = this.actual.map(function (x, ind) { return [sugg.nUses[x.id] / sugg.gen, x]; });
        else
            this.sortFreq = this.actual.map(function (x, ind) { return [0, x]; });
        this.sortLast = this.actual.map(function (x, ind) { return [sugg.lastUse[x.id], x]; });
        this.sortFreq.sort(function (a, b) { return a[0] - b[0]; });
        this.sortLast.sort(function (a, b) { return a[0] - b[0]; });
    }
    clear(lvl) {
        this.actual = [];
        this.age = {};
        for (let i in this.all_pwups) {
            if (this.all_pwups[i].applies(lvl)) {
                this.actual.push(this.all_pwups[i]);
            }
        }
        this.computeOrders();
    }
    invariantTried(inv) {
        for (let i in this.actual) {
            if (this.actual[i].holds(inv)) {
                this.nUses[this.actual[i].id]++;
                this.lastUse[this.actual[i].id] = this.gen;
            }
        }
        this.gen++;
        this.computeOrders();
    }
    getPwups() {
        if (this.type === "lru") {
            return this.sortLast.slice(0, this.nDisplay).map(([fst, snd]) => snd);
        }
        else {
            assert(this.type === "lfu");
            return this.sortFreq.slice(0, this.nDisplay).map(([fst, snd]) => snd);
        }
    }
}
//# sourceMappingURL=powerups.js.map