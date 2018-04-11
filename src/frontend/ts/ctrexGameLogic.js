define(["require", "exports", "./gameLogic", "./util", "./eval", "./powerups", "./logic", "./pp", "esprima", "./rpc"], function (require, exports, gameLogic_1, util_1, eval_1, powerups_1, logic_1, pp_1, esprima_1, rpc_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    class CounterexGameLogic extends gameLogic_1.BaseGameLogic {
        constructor(tracesW, progressW, scoreW, stickyW) {
            super(tracesW, progressW, scoreW, stickyW);
            this.tracesW = tracesW;
            this.progressW = progressW;
            this.scoreW = scoreW;
            this.stickyW = stickyW;
            this.foundJSInv = [];
            this.invMap = {};
            this.lvlPassedF = false;
            this.nonindInvs = [];
            this.overfittedInvs = [];
            this.soundInvs = [];
            this.allData = {};
            this.allNonind = {};
            //this.pwupSuggestion = new PowerupSuggestionFullHistoryVariableMultipliers(3, "lfu");
            this.pwupSuggestion = new powerups_1.PowerupSuggestionAll();
        }
        clear() {
            super.clear();
            this.foundJSInv = [];
            this.invMap = {};
            this.soundInvs = [];
            this.overfittedInvs = [];
            this.nonindInvs = [];
            this.lvlPassedF = false;
        }
        computeScore(inv, s) {
            let pwups = this.pwupSuggestion.getPwups();
            let hold = pwups.filter((pwup) => pwup.holds(inv));
            let newScore = hold.reduce((score, pwup) => pwup.transform(score), s);
            let pwupsActivated = [];
            for (var i in hold) {
                pwupsActivated.push([hold[i].id, (hold[i]).mult]);
                if (i == "" + (hold.length - 1)) {
                    /* After the last powerup is done highlighting,
                     * recompute the powerups
                     */
                    hold[i].highlight(() => {
                        this.pwupSuggestion.invariantTried(inv);
                        this.setPowerups(this.pwupSuggestion.getPwups());
                    });
                }
                else {
                    hold[i].highlight(() => 0);
                }
            }
            rpc_1.logEvent("PowerupsActivated", [gameLogic_1.curLvlSet(), this.curLvl.id, inv, pwupsActivated]);
            if (hold.length == 0) {
                this.pwupSuggestion.invariantTried(inv);
            }
            return newScore;
        }
        goalSatisfied(cb) {
            let contains = (v, arr) => {
                for (let i in arr)
                    if (arr[i] == v) {
                        return true;
                    }
                return false;
            };
            if (this.foundJSInv.length > 0) {
                var invToTry = this.foundJSInv.filter((ui) => !contains(ui.id, this.overfittedInvs));
                logic_1.tryAndVerify(gameLogic_1.curLvlSet(), this.curLvl.id, invToTry.map((x) => x.canonForm), ([overfitted, nonind, sound, post_ctrex, direct_ctrex]) => {
                    if (sound.length > 0) {
                        cb(post_ctrex.length == 0, [overfitted, nonind, sound, post_ctrex, direct_ctrex]);
                    }
                    else {
                        cb(false, [overfitted, nonind, sound, post_ctrex, direct_ctrex]);
                    }
                });
            }
            else {
                cb(false, [[], [], []]);
            }
        }
        userInput(commit) {
            this.tracesW.disableSubmit();
            this.tracesW.clearError();
            this.progressW.clearMarks();
            let gl = this;
            let inv = pp_1.invPP(this.tracesW.curExp().trim());
            let desugaredInv = eval_1.invToJS(inv);
            var parsedInv = null;
            this.userInputCb(inv);
            if (inv.length == 0) {
                this.tracesW.evalResult({ clear: true });
                return;
            }
            try {
                parsedInv = esprima_1.parse(desugaredInv);
            }
            catch (err) {
                //this.tracesW.delayedError(inv + " is not a valid expression.");
                return;
            }
            parsedInv = eval_1.fixVariableCase(parsedInv, this.curLvl.variables);
            let undefined_ids = util_1.difference(eval_1.identifiers(parsedInv), util_1.toStrset(this.curLvl.variables));
            if (!util_1.isEmpty(undefined_ids)) {
                this.tracesW.delayedError(util_1.any_mem(undefined_ids) + " is not defined.");
                return;
            }
            let jsInv = eval_1.esprimaToStr(parsedInv);
            try {
                if (jsInv.search("\\^") >= 0) {
                    throw new eval_1.ImmediateErrorException("UnsupportedError", "^ not supported. Try * instead.");
                }
                let pos_res = eval_1.invEval(parsedInv, this.curLvl.variables, this.curLvl.data[0]);
                let neg_res = eval_1.invEval(parsedInv, this.curLvl.variables, this.curLvl.data[2]);
                let res = [pos_res, [], neg_res];
                this.tracesW.evalResult({ data: res });
                if (!eval_1.evalResultBool(res))
                    return;
                logic_1.simplify(jsInv, (simplInv) => {
                    let ui = new gameLogic_1.UserInvariant(inv, jsInv, simplInv);
                    rpc_1.logEvent("TriedInvariant", [gameLogic_1.curLvlSet(),
                        gl.curLvl.id,
                        ui.rawUserInp,
                        ui.canonForm,
                        gl.curLvl.colSwap,
                        gl.curLvl.isReplay()]);
                    let redundant = this.progressW.contains(ui.id);
                    if (redundant) {
                        this.progressW.markInvariant(ui.id, "duplicate");
                        this.tracesW.immediateError("Duplicate Expression!");
                        return;
                    }
                    let all = pos_res.length + neg_res.length;
                    let hold = pos_res.filter(function (x) { return x; }).length +
                        neg_res.filter(function (x) { return !x; }).length;
                    if (hold < all)
                        this.tracesW.error("Holds for " + hold + "/" + all + " cases.");
                    else {
                        this.tracesW.enableSubmit();
                        if (!commit) {
                            this.tracesW.msg("<span class='good'>Press Enter...</span>");
                            return;
                        }
                        logic_1.isTautology(ui.rawInv, function (res) {
                            if (res) {
                                gl.tracesW.error("This is always true...");
                                return;
                            }
                            let allCandidates = gl.foundJSInv.map((x) => x.canonForm);
                            logic_1.impliedBy(allCandidates, ui.canonForm, function (x) {
                                if (x.length > 0) {
                                    gl.progressW.markInvariant(eval_1.esprimaToStr(x[0]), "implies");
                                    gl.tracesW.immediateError("This is weaker than a found expression!");
                                }
                                else {
                                    var addScore = gl.computeScore(ui.rawInv, 1);
                                    gl.score += addScore;
                                    gl.scoreW.add(addScore);
                                    gl.foundJSInv.push(ui);
                                    gl.invMap[ui.id] = ui;
                                    gl.progressW.addInvariant(ui.id, ui.rawInv);
                                    if (gl.curLvl.hint && gl.curLvl.hint.type == "post-assert") {
                                        gl.tracesW.setExp(gl.curLvl.hint.assert);
                                    }
                                    else {
                                        gl.tracesW.setExp("");
                                    }
                                    /*
                                     * Clear the current negative rows
                                     */
                                    gl.curLvl.data[2] = [];
                                    gl.tracesW.clearNegRows();
                                    rpc_1.logEvent("FoundInvariant", [gameLogic_1.curLvlSet(),
                                        gl.curLvl.id,
                                        ui.rawUserInp,
                                        ui.canonForm,
                                        gl.curLvl.colSwap,
                                        gl.curLvl.isReplay()]);
                                    if (!gl.lvlPassedF) {
                                        if (gl.foundJSInv.length >= 6) {
                                            var coin = Math.random() > .5;
                                            if (coin) {
                                                gl.lvlPassedF = true;
                                                gl.lvlPassedCb();
                                                rpc_1.logEvent("FinishLevel", [gameLogic_1.curLvlSet(),
                                                    gl.curLvl.id,
                                                    false,
                                                    gl.foundJSInv.map((x) => x.rawUserInp),
                                                    gl.foundJSInv.map((x) => x.canonForm),
                                                    gl.curLvl.colSwap,
                                                    gl.curLvl.isReplay()]);
                                            }
                                        }
                                        else {
                                            /*
                                             * There is a potential race between an earlier call to
                                             * goalSatisfied and a later game finish due to 8 levels,
                                             * that could result in 2 or more FinishLevel events for
                                             * the same level.
                                             */
                                            var preCallCurLvl = gl.curLvl.id;
                                            gl.goalSatisfied((sat, feedback) => {
                                                var overfittedInvs = feedback[0].map((p) => eval_1.esprimaToStr(p[0]));
                                                gl.overfittedInvs = gl.overfittedInvs.concat(overfittedInvs);
                                                if (!sat) {
                                                    // Add any counterexamples
                                                    var overfitted = feedback[0].map((p) => p[1]);
                                                    var postctrex = feedback[4];
                                                    console.log(overfitted, postctrex);
                                                    gl.tracesW.addData([overfitted, [], postctrex]);
                                                    gl.curLvl.data[0] = gl.curLvl.data[0].concat(overfitted);
                                                    gl.curLvl.data[2] = gl.curLvl.data[2].concat(postctrex);
                                                    return;
                                                }
                                                /*
                                                 * Lets try and make sure at least late "gameFinished" events from
                                                 * previous levels don't impact next level.
                                                 */
                                                if (preCallCurLvl != gl.curLvl.id)
                                                    return;
                                                rpc_1.logEvent("FinishLevel", [gameLogic_1.curLvlSet(),
                                                    gl.curLvl.id,
                                                    sat,
                                                    gl.foundJSInv.map((x) => x.rawUserInp),
                                                    gl.foundJSInv.map((x) => x.canonForm),
                                                    gl.curLvl.colSwap,
                                                    gl.curLvl.isReplay()]);
                                                gl.lvlPassedF = true;
                                                gl.lvlPassedCb();
                                            });
                                        }
                                    }
                                }
                            });
                        });
                    }
                });
            }
            catch (err) {
                if (err instanceof eval_1.ImmediateErrorException) {
                    this.tracesW.immediateError(eval_1.interpretError(err));
                }
                else {
                    this.tracesW.delayedError(eval_1.interpretError(err));
                }
            }
        }
        loadLvl(lvl) {
            let loadedCb = this.lvlLoadedCb;
            this.lvlLoadedCb = null;
            super.loadLvl(lvl);
            if (!this.allData.hasOwnProperty(lvl.id)) {
                this.allData[lvl.id] = [[], [], []];
            }
            this.allData[lvl.id][0] = this.allData[lvl.id][0].concat(lvl.data[0]);
            this.allData[lvl.id][1] = this.allData[lvl.id][1].concat(lvl.data[1]);
            this.allData[lvl.id][2] = this.allData[lvl.id][2].concat(lvl.data[2]);
            for (let [rawInv, canonInv] of lvl.startingInvs) {
                let jsInv = eval_1.esprimaToStr(esprima_1.parse(eval_1.invToJS(rawInv)));
                let ui = new gameLogic_1.UserInvariant(rawInv, jsInv, canonInv);
                this.foundJSInv.push(ui);
                this.invMap[ui.id] = ui;
                this.progressW.addInvariant(ui.id, ui.rawInv);
            }
            this.lvlLoadedCb = loadedCb;
            if (this.lvlLoadedCb)
                this.lvlLoadedCb();
            rpc_1.logEvent("StartLevel", [gameLogic_1.curLvlSet(),
                this.curLvl.id,
                this.curLvl.colSwap,
                this.curLvl.isReplay()]);
        }
        skipToNextLvl() {
            rpc_1.logEvent("SkipToNextLevel", [gameLogic_1.curLvlSet(),
                this.curLvl.id,
                this.curLvl.colSwap,
                this.curLvl.isReplay()]);
            rpc_1.logEvent("FinishLevel", [gameLogic_1.curLvlSet(),
                this.curLvl.id,
                false,
                this.foundJSInv.map((x) => x.rawUserInp),
                this.foundJSInv.map((x) => x.canonForm),
                this.curLvl.colSwap,
                this.curLvl.isReplay()]);
            this.lvlPassedF = true;
            this.lvlPassedCb();
        }
    }
    exports.CounterexGameLogic = CounterexGameLogic;
});
//# sourceMappingURL=ctrexGameLogic.js.map