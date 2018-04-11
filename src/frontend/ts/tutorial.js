define(["require", "exports", "util", "./rpc", "./stickyWindow", "gameLogic", "eval", "traceWindow", "scoreWindow", "progressWindow", "rpc", "ctrexTracesWindow", "level", "esprima", "pp", "powerups"], function (require, exports, util_1, rpc_1, stickyWindow_1, gameLogic_1, eval_1, traceWindow_1, scoreWindow_1, progressWindow_1, rpc_2, ctrexTracesWindow_1, level_1, esprima_1, pp_1, powerups_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    var errorDelay = 2000;
    var fadeDelay = 500;
    var errorTimer;
    var jsfound = [];
    var curLvl;
    var tracesW = null, progW = null, scoreW = null, stickyW = null, gameLogic = null;
    var curL = null, curL1 = null, curL2 = null;
    var tempCb = null;
    var stepTimeout = -1;
    var pwups = [];
    util_1.disableBackspaceNav();
    function addSuccessfulInvariant(inv, safetyInv) {
        let parsedInv;
        try {
            parsedInv = esprima_1.parse(eval_1.invToJS(inv));
        }
        catch (err) {
            inv = safetyInv;
            parsedInv = esprima_1.parse(eval_1.invToJS(inv));
        }
        jsfound.push(eval_1.invToJS(inv));
        progW.addInvariant(inv, parsedInv);
    }
    function updateUI() {
        $('#errormsg').html("");
        let raw = tracesW.curExp().trim();
        var inv = pp_1.invPP(raw).replace(/\s/g, "");
        let desugared = eval_1.invToJS(raw);
        try {
            var parsedInv = esprima_1.parse(desugared);
        }
        catch (err) {
            util_1.log("Error parsing  " + desugared + ":" + err);
        }
        if (inv.length == 0) {
            tracesW.evalResult({ clear: true });
            return;
        }
        if (tempCb != null)
            tempCb(inv);
        try {
            let res_pos = eval_1.invEval(parsedInv, curLvl.variables, curLvl.data[0]);
            let res_ind = eval_1.invEval(parsedInv, curLvl.variables, curLvl.data[2]);
            let zipped_ind = util_1.zip(res_ind.filter((_, i) => i % 2 == 0), res_ind.filter((_, i) => i % 2 == 1));
            tracesW.evalResult({ data: [res_pos, [], zipped_ind] });
        }
        catch (err) {
            errorTimer = setTimeout(function () {
                tracesW.evalResult({ clear: true });
                $('#errormsg').html("<div class='error'> " + eval_1.interpretError(err) + "</div>");
            }, errorDelay);
        }
    }
    function nextStepOnInvariant(curScript, invariant, destructor) {
        tempCb = function (inv) {
            if (inv == invariant) {
                util_1.removeLabel(curL);
                tempCb = null;
                destructor();
                curScript.nextStep();
            }
        };
        $('#formula-entry').focus();
    }
    function nextStepOnGLInvariant(curScript, invariant, destructor, gl) {
        gl.onUserInput(function (inv) {
            if (inv == invariant) {
                util_1.removeLabel(curL);
                gl.onUserInput(function (inv) { });
                destructor();
                curScript.nextStep();
            }
        });
    }
    function labelRemover(lbl) {
        return function () { util_1.removeLabel(lbl); };
    }
    function inner(arg) {
        return arg.get()[0];
    }
    var mainScript = [
        { setup: function (cs) {
                $('.overlay').html("<h1>Welcome to the <span class='good'>InvGen</span> Tutorial!<br> You can press spacebar or click anywhere<br>to proceed to the next step.</h1>");
                if (util_1.Args.get_assignment_id() == "ASSIGNMENT_ID_NOT_AVAILABLE") {
                    $('.overlay').append("<h1><b>This is a preview, which only shows you the tutorial</b></h1>" +
                        "<h1><b>NOTE: Please DON'T accept more than one HIT from us at a time! <br> First finish your current HIT, before accepting another! </b></h1>" +
                        "<h3>This HIT involves playing at least two non-tutorial levels of the <span class='good'>InvGen</span> game.<h3>" +
                        "<h3><b>Played it before?</b> Come play again! You will bypass the tutorial and get new levels!<br>" +
                        "<b>New player?</b> Come try it out!</h3>" +
                        "<h3>We aim to pay about $10/hr</h3>" +
                        "<h3><b>$1.50 for the HIT</b>, which involves playing the game for at least 2 non-tutorial levels<br>" +
                        "<b>$1.50 bonus for doing the tutorial</b> (which you only do the first time)<br>" +
                        "<b>$0.75 bonus for each non-tutorial level you pass beyond two</b></h3>");
                }
                $('.overlay').fadeIn(fadeDelay, function () {
                    cs.nextStepOnKeyClickOrTimeout(stepTimeout, () => 0, 32);
                });
            }
        },
        // UI tutorial -----------------------------------------------------
        { setup: function (cs) {
                rpc_1.logEvent("TutorialStart", null);
                $(".overlay").fadeOut(fadeDelay, function () {
                    var lvl = {
                        id: "tutorial",
                        variables: ["i", "n"],
                        data: [[[0, 2], [1, 2], [2, 2]], [], []],
                        goal: {},
                        hint: "",
                        supports_pos_ex: false,
                        supports_neg_ex: false,
                        supports_ind_ex: false,
                    };
                    curLvl = lvl;
                    tracesW = new traceWindow_1.PositiveTracesWindow(inner($('#data-display')));
                    tracesW.setVariables(lvl);
                    tracesW.onChanged(function () {
                        if (errorTimer) {
                            window.clearTimeout(errorTimer);
                            errorTimer = null;
                        }
                        updateUI();
                    });
                    tracesW.addData(lvl.data);
                    $('#hint').html(lvl.hint);
                    updateUI();
                    cs.nextStep();
                });
            }
        },
        { setup: function (cs) {
                curL = util_1.label($('#formula-entry'), "Type the text '3+4' here!", "left");
                nextStepOnInvariant(cs, "3+4", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                curL = util_1.label({ of: "#2 .temp_expr_eval", at: "left+10 bottom" }, "3+4=7! (Press spacebar or click anywhere...)", "up");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($('#formula-entry'), "Now type i.", "left");
                nextStepOnInvariant(cs, "i", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                curL = util_1.label({ of: "#2 .temp_expr_eval", at: "left+10 bottom" }, "Column contains values of i! (space/click to continue...)", "up");
                curL1 = util_1.label({ of: $("#lvl_table > thead > tr > th:nth-child(1)"), at: "left center" }, "", "right");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, () => {
                    util_1.removeLabel(curL);
                    util_1.removeLabel(curL1);
                }, 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($('#formula-entry'), "Type i+1", "left");
                nextStepOnInvariant(cs, "i+1", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                curL = util_1.label({ of: "#2 .temp_expr_eval", at: "left+10 bottom" }, "Now you get i+1 in this column!", "up");
                curL1 = util_1.label({ of: $("#lvl_table > thead > tr > th:nth-child(1)"), at: "left center" }, "", "right");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, () => {
                    util_1.removeLabel(curL);
                    util_1.removeLabel(curL1);
                }, 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#formula-entry"), "This box works like a calculator!", "left");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label({ of: "#2 .temp_expr_eval", at: "left+10 bottom" }, "And the results appear here", "up");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#formula-entry"), "Now try i > 0", "left");
                nextStepOnInvariant(cs, "i>0", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#0 .temp_expr_eval"), "Red means false.", "left");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#1 .temp_expr_eval"), "Green means true.", "left");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#0 .temp_expr_eval"), "This row is part green, part red<br>Lets fix that.", "left");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#formula-entry"), "Type i >= 0", "left");
                nextStepOnInvariant(cs, "i>=0", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#0 .temp_expr_eval"), "Hurray! Each row is a single color now!!", "left");
                cs.nextStepOnKeyClickOrTimeout(-1, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#0 .temp_expr_eval"), "This is your goal: <br>" +
                    "to find an expression, <br> such that each row is a single color.", "left");
                cs.nextStepOnKeyClickOrTimeout(-1, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                tracesW.msg("Press Enter...");
                curL = util_1.label($("#formula-entry"), "Press enter...", "left");
                cs.nextStepOnKeyClickOrTimeout(-1, labelRemover(curL), 13);
            }
        },
        { setup: function (cs) {
                tracesW.msg("");
                $('#score-div-row').fadeIn(fadeDelay, function () {
                    curL = util_1.label({ of: $("#score-div-row"), at: "left+10 bottom" }, "You get points for each <br> accepted expression! Sweet!", "up");
                    scoreW.add(1);
                    cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
                });
            }
        },
        { setup: function (cs) {
                $('#discovered-invariants-div').fadeIn(fadeDelay, function () {
                    var inv = pp_1.invPP(tracesW.curExp().trim());
                    addSuccessfulInvariant(inv, "i>=0");
                    curL = util_1.label({ of: $("#good_0"), at: "left+10 bottom" }, "Your accepted expressions <br> appear here", "up");
                    cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
                });
            }
        },
        { setup: function (cs) {
                $("#formula-entry").val("");
                curL = util_1.label($("#formula-entry"), "Type i >= 0 again.", "left");
                nextStepOnInvariant(cs, "i>=0", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                $('#errormsg').html("<div class='error'> Duplicate Expression! </div>");
                curL = util_1.label({ of: $("#good_0"), at: "left+10 bottom" }, "Can't use same expression twice", "up");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#formula-entry"), "How about i>=-1?", "left");
                nextStepOnInvariant(cs, "i>=-1", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                $('#errormsg').html("<div class='error'>This is weaker than a found expression!</div>");
                curL = util_1.label({ of: $("#good_0"), at: "left+10 bottom" }, "Can't use a weaker<br> expression than <br> found one either.", "up");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                pwups = [new powerups_1.VarOnlyPowerup(2),
                    new powerups_1.UseOpsPwup(["<=", ">=", "<", ">", "!=="], "<>", "inequality"),
                    new powerups_1.UseOpsPwup(["+", "-"], "&plusmn;", "addition or subtraction")];
                $('#sticky').addClass("box stickyWindow");
                stickyW = new stickyWindow_1.StickyWindow($('#sticky').get()[0]);
                $('#sticky').hide();
                stickyW.setPowerups(pwups);
                $('#sticky').fadeIn(fadeDelay, () => {
                    curL = util_1.label({ of: $("#sticky"), at: "center bottom" }, "Some expressions<br>give you more points!", "up");
                    cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
                });
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#formula-entry"), "Type i<=n", "left");
                nextStepOnInvariant(cs, "i<=n", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                tracesW.msg("Press Enter...");
                curL = util_1.label($("#formula-entry"), "Press enter...", "left");
                cs.nextStepOnKeyClickOrTimeout(-1, labelRemover(curL), 13);
            }
        },
        { setup: function (cs) {
                tracesW.msg("");
                curL = util_1.label({ of: $("#sticky"), at: "center bottom" }, "Double added points <br> since you used only <br> variables", "up");
                pwups[0].highlight(() => cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32));
            }
        },
        { setup: function (cs) {
                tracesW.msg("");
                curL = util_1.label({ of: $("#sticky"), at: "center bottom" }, "Double added points <br> since you used <br> inequality", "up");
                pwups[1].highlight(() => cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32));
            }
        },
        { setup: function (cs) {
                curL = util_1.label({ of: $("#score-div-row"), at: "right center" }, "So you get +4<br>instead of +1", "left");
                scoreW.add(4);
                var inv = pp_1.invPP(tracesW.curExp().trim());
                addSuccessfulInvariant(inv, "i<=n");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                pwups = [new powerups_1.UseOpsPwup(["+", "-"], "&plusmn;", "addition or subtraction"),
                    new powerups_1.UseOpsPwup(["*", "/"], "*/", "multiplication or division"),
                    new powerups_1.UseOpsPwup(["=="], "=", "equality"),
                ];
                stickyW.setPowerups(pwups);
                curL = util_1.label({ of: $("#sticky"), at: "center bottom" }, "Bonuses change<br>based on what you try.", "up");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        // Show Mod-----------------------------------------------
        { setup: function (cs) {
                $('.overlay').html("<h1>Lets try this <br> with a more complicated operation. </h1>");
                $('.overlay').fadeIn(fadeDelay, function () {
                    cs.nextStepOnKeyClickOrTimeout(stepTimeout, () => 0, 32);
                });
            }
        },
        { setup: function (cs) {
                rpc_1.logEvent("TutorialStart", null);
                $(".overlay").fadeOut(fadeDelay, function () {
                    var lvl = {
                        id: "tutorial",
                        variables: ["j"],
                        data: [[[2], [4], [6], [8]], [], []],
                        goal: {},
                        hint: "",
                        supports_pos_ex: false,
                        supports_neg_ex: false,
                        supports_ind_ex: false,
                    };
                    curLvl = lvl;
                    tracesW = new traceWindow_1.PositiveTracesWindow($('#data-display').get()[0]);
                    tracesW.onChanged(function () {
                        if (errorTimer) {
                            window.clearTimeout(errorTimer);
                            errorTimer = null;
                        }
                        updateUI();
                    });
                    tracesW.setVariables(lvl);
                    tracesW.addData(lvl.data);
                    pwups = [
                        new powerups_1.UseOpsPwup(["%"], "%", "remainder after division"),
                        new powerups_1.UseOpsPwup(["=="], "=", "equality"),
                        new powerups_1.UseOpsPwup(["+", "-"], "&plusmn;", "addition or subtraction"),
                    ];
                    stickyW.setPowerups(pwups);
                    progW.clear();
                    updateUI();
                    cs.nextStep();
                });
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#formula-entry"), "Type j % 2", "left");
                nextStepOnInvariant(cs, "j%2", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#formula-entry"), "% means <br>'remainder of division'", "left");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#formula-entry"), "j always has remainder <br> 0 divided by 2", "left");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($("#formula-entry"), "Type j % 2 = 0", "left");
                nextStepOnInvariant(cs, "j%2=0", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                tracesW.msg("Press Enter...");
                curL = util_1.label($("#formula-entry"), "Press enter...", "left");
                cs.nextStepOnKeyClickOrTimeout(-1, labelRemover(curL), 13);
            }
        },
        { setup: function (cs) {
                var inv = pp_1.invPP(tracesW.curExp().trim());
                tracesW.msg("");
                pwups[0].highlight(() => 0);
                pwups[1].highlight(() => 0);
                scoreW.add(4);
                addSuccessfulInvariant(inv, "j%2=0");
                curL = util_1.label({ of: $("#score-div-row"), at: "right center" }, "Hurray! <br> You learned to use %!", "left");
                cs.nextStepOnKeyClickOrTimeout(-1, labelRemover(curL), 13);
            }
        },
        // Tutorial Levels for UI-----------------------------------------------
        { setup: function (cs) {
                $('.overlay').html("<h1>Lets warm up with a couple of levels!</h1>");
                $('.overlay').fadeIn(fadeDelay, function () {
                    cs.nextStepOnKeyClickOrTimeout(stepTimeout, () => 0, 32);
                });
            }
        },
        { setup: function (cs) {
                $(".overlay").fadeOut(fadeDelay, function () {
                    $('#sticky').addClass("box stickyWindow");
                    stickyW = new stickyWindow_1.StickyWindow($('#sticky').get()[0]);
                    gameLogic = new gameLogic_1.StaticGameLogic(tracesW, progW, scoreW, stickyW, 3);
                    var lvl = new level_1.Level("tutorial_lvl_1", ["j", "n"], [[[0, 3], [1, 3], [2, 3], [3, 3]], [], []], { atleast: 1 }, "What can you say about j and n?", false, []);
                    gameLogic.loadLvl(lvl);
                    tracesW.disable();
                    cs.nextStep();
                });
            }
        },
        { setup: function (cs) {
                curL = util_1.label({ of: $("#sticky"), at: "left+10 bottom" }, "Hover over each bonus for details!", "up");
                // In following line, use timeout of 3000 instead of stepTimeout because of some
                // weird thing that happens only in firefox (not in Chrome and not in Edge), 
                // which is that because of tracesW.disable(), the keyboard events don't come through
                // unless someone clicks somewhere on the page.
                cs.nextStepOnKeyClickOrTimeout(3000, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                tracesW.enable();
                $('#formula-entry').focus();
                gameLogic.onLvlPassed(() => $('#next-lvl').fadeIn(fadeDelay, () => {
                    curL = util_1.label({ of: $('#next-lvl'), at: "right center" }, "Click Here!", "left");
                }));
            }
        },
        { setup: function (cs) {
                //$('#next-lvl').hide();
                //removeLabel(curL);
                var lvl = new level_1.Level("tutorial_lvl_2", ["k", "l"], [[[1, 2], [2, 3], [3, 4]], [], []], { atleast: 1 }, "", false, []);
                gameLogic.loadLvl(lvl);
            }
        },
        { setup: function (cs) {
                //removeLabel(curL);
                //$('#next-lvl').hide();
                var lvl = new level_1.Level("tutorial_lvl_3", ["k", "l"], [[[1, 3], [2, 6], [3, 9]], [], []], { atleast: 1 }, "", false, []);
                gameLogic.loadLvl(lvl);
            }
        },
    ];
    var negativeScript = [
        { setup: function (cs) {
                $('.overlay').html("<h2>Sometimes you will see levels with 'red' rows.<br>" +
                    "You need an expression the evaluates to false on those rows.<br>" +
                    "Let's see an example! (space/click to continue)</h2>");
                $('.overlay').fadeIn(fadeDelay, function () {
                    cs.nextStepOnKeyClickOrTimeout(stepTimeout, () => { }, 32);
                });
            }
        },
        { setup: function (cs) {
                $(".overlay").fadeOut(fadeDelay, function () { });
                //$('#next-lvl').hide();
                // gameLogic can be null here because we allow tutorial re-runs to begin with conditionals
                //  $('#score-div-row').fadeIn(fadeDelay, function() {});
                tracesW = new ctrexTracesWindow_1.CounterexTracesWindow($('#data-display').get()[0]);
                $('#sticky').addClass("box stickyWindow");
                stickyW = new stickyWindow_1.StickyWindow($('#sticky').get()[0]);
                gameLogic = new gameLogic_1.StaticGameLogic(tracesW, progW, scoreW, stickyW, 3);
                gameLogic.onLvlPassed(() => $('#next-lvl').fadeIn(fadeDelay, () => {
                    curL = util_1.label({ of: $('#next-lvl'), at: "right center" }, "Click Here!", "left");
                }));
                var lvl = new level_1.Level("tutorial_lvl_4", ["i", "j"], [[[1, 2], [2, 3], [3, 4], [4, 5]], [], [[6, 6]]], { atleast: 2 }, "", false, []);
                gameLogic.loadLvl(lvl);
                curL = util_1.label($('#0_1.false'), "Notice the red row when i=j (space/click to continue)", "left", 0, 0);
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($('#formula-entry'), "Type 'i&lt=j'", "left");
                gameLogic.onUserInput(function (inv) {
                    if (tempCb != null)
                        tempCb(inv.replace(/\s/g, ""));
                });
                nextStepOnInvariant(cs, "i<=j", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                util_1.removeLabel(curL);
                curL = util_1.label($('#neg_0'), "This row is not all red!<br> (space/click to continue)", "left", 0, 0);
                gameLogic.onUserInput(function (inv) {
                    if (tempCb != null)
                        tempCb(inv.replace(/\s/g, ""));
                });
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($('#formula-entry'), "Type 'i&ltj' now", "left");
                gameLogic.onUserInput(function (inv) {
                    if (tempCb != null)
                        tempCb(inv.replace(/\s/g, ""));
                });
                nextStepOnInvariant(cs, "i<j", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                util_1.removeLabel(curL);
                curL = util_1.label($('#neg_0'), "Now row is all red! (space/click to continue)", "left", 0, 0);
                gameLogic.onUserInput(function (inv) {
                    if (tempCb != null)
                        tempCb(inv.replace(/\s/g, ""));
                });
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                util_1.removeLabel(curL);
                curL = util_1.label($('#neg_0'), "Press Enter", "left", 0, 0);
                gameLogic.onUserInput(function (inv) {
                    if (tempCb != null)
                        tempCb(inv.replace(/\s/g, ""));
                });
                cs.nextStepOnKeyClickOrTimeout(-1, labelRemover(curL), 13);
            }
        },
    ];
    var conditionalsScript = [
        { setup: function (cs) {
                $('.overlay').html("<h2>Sometimes there is a pattern that only holds under some conditions.<br>" +
                    "You can capture this with an 'if' expression.<br>" +
                    "Let's see an example! (space/click to continue)</h2>");
                $('.overlay').fadeIn(fadeDelay, function () {
                    cs.nextStepOnKeyClickOrTimeout(stepTimeout, () => { }, 32);
                });
            }
        },
        { setup: function (cs) {
                $(".overlay").fadeOut(fadeDelay, function () { });
                //$('#next-lvl').hide();
                // gameLogic can be null here because we allow tutorial re-runs to begin with conditionals
                if (gameLogic === null) {
                    $('#score-div-row').fadeIn(fadeDelay, function () { });
                    tracesW = new traceWindow_1.PositiveTracesWindow($('#data-display').get()[0]);
                    $('#sticky').addClass("box stickyWindow");
                    stickyW = new stickyWindow_1.StickyWindow($('#sticky').get()[0]);
                    gameLogic = new gameLogic_1.StaticGameLogic(tracesW, progW, scoreW, stickyW, 3);
                    gameLogic.onLvlPassed(() => $('#next-lvl').fadeIn(fadeDelay, () => {
                        curL = util_1.label({ of: $('#next-lvl'), at: "right center" }, "Click Here!", "left");
                    }));
                }
                var lvl = new level_1.Level("tutorial_lvl_4", ["i", "x", "y"], [[[1, 4, 5], [2, 5, 6], [3, 7, 7], [4, 8, 8], [5, 9, 9]], [], []], { atleast: 2 }, "", false, []);
                gameLogic.loadLvl(lvl);
                tracesW.highlightRect(1, 2, 2, 3, 'solid 3px blue', "lightcyan");
                curL = util_1.label($('#3_2'), "See how x = y here (space/click to continue)", "left", 0, 0);
                setTimeout(function () { cs.nextStepOnKeyClickOrTimeout(stepTimeout, () => { }, 32); }, 500);
            }
        },
        { setup: function (cs) {
                tracesW.highlightRect(1, 0, 2, 2, 'solid 3px purple', "F9F2F9");
                curL1 = util_1.label({ of: '#0_2', at: "right bottom" }, "But not here (space/click to continue)", "left", 0, 0);
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, () => { }, 32);
            }
        },
        { setup: function (cs) {
                tracesW.highlightRect(0, 2, 1, 3, 'solid 3px red', "FFEFF2");
                curL2 = util_1.label({ of: '#4_0', at: "left bottom" }, "Also note that i >= 3 here. In summary: x=y <i>if</i> i >= 3<br>(space/click to continue)", "up", 0, 0);
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, () => { }, 32);
            }
        },
        { setup: function (cs) {
                util_1.removeLabel(curL);
                util_1.removeLabel(curL1);
                util_1.removeLabel(curL2);
                tracesW.clearRect(1, 2, 2, 3);
                tracesW.clearRect(1, 0, 2, 2);
                tracesW.clearRect(0, 2, 1, 3);
                curL = util_1.label($('#formula-entry'), "Type 'x=y'", "left");
                gameLogic.onUserInput(function (inv) {
                    if (tempCb != null)
                        tempCb(inv.replace(/\s/g, ""));
                });
                nextStepOnInvariant(cs, "x=y", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                curL = util_1.label({ of: "#4 .temp_expr_eval", at: "left+10 bottom" }, "Notice results (space/click to continue)", "up");
                cs.nextStepOnKeyClickOrTimeout(stepTimeout, labelRemover(curL), 32);
            }
        },
        { setup: function (cs) {
                curL = util_1.label($('#formula-entry'), "Add ' if i>=3'", "left");
                nextStepOnInvariant(cs, "x=yifi>=3", labelRemover(curL));
            }
        },
        { setup: function (cs) {
                gameLogic.onCommit(function () {
                    cs.nextStep();
                });
            }
        },
        { setup: function (cs) {
                gameLogic.onCommit(null);
                setTimeout(function () {
                    tracesW.highlightRect(0, 0, 3, 2, 'solid 3px purple', "F9F2F9");
                    curL = util_1.label($('#0_2'), "See how y=x+1 if i < 3<br>(space/click to continue)", "left", 0, 0);
                    cs.nextStepOnKeyClickOrTimeout(stepTimeout, () => { }, 32);
                }, 700);
            }
        },
        { setup: function (cs) {
                util_1.removeLabel(curL);
                tracesW.clearRect(0, 0, 3, 2);
                curL = util_1.label($('#formula-entry'), "Try 'y=x+1 if i<3'", "left");
                nextStepOnInvariant(cs, "y=x+1ifi<3", labelRemover(curL));
            }
        },
        { setup: function (cs) {
            }
        },
    ];
    var conclusionScript = [
        // Conclusion ----------------------------------------------------------
        { setup: function (cs) {
                var elmts = $('#data-display table').add('#score-div-row').add('#discovered-invariants-div')
                    .add('#sticky').add('.kill-switch');
                var numElmts = elmts.length;
                elmts.fadeOut(fadeDelay, function () {
                    if (--numElmts > 0)
                        return;
                    util_1.removeLabel(curL);
                    cs.nextStep();
                });
            }
        },
        { setup: function (cs) {
                $('#next-lvl').hide();
                var ops = [['+', 'Integer Addition', '3+4=7, i+1'],
                    ['-', 'Integer Subtraction', '4-3=1, j-1'],
                    ['*', 'Integer Multiplication', '4*3=12, n*2'],
                    ['/', 'Integer Division', '5/2=2, n/3'],
                    ['%', 'Remainder of Integer Division', '5%2=1, n%2'],
                    ['()', 'Parenthesis', '3*(2+3)=15, 2*(n+1)'],
                    ['=', 'Equality', '3=3, n=2'],
                    ['!=', 'Inequality', '3!=2, n!=0'],
                    ['&lt <br> &gt', 'Less than<br>Greater than', '2<3, n>0'],
                    ['&lt= <br> &gt=', 'Less than or equal<br>Greater than or equal', '2<=2, n>=0'],
                    ['&&', 'Logical And', '(n<5) && (n>0)'],
                    ['||', 'Logical Or', '(n>=5) || (n<=0)'],
                ];
                if (!util_1.Args.get_noifs()) {
                    ops.push(['if', 'Conditional', 'x=y if x > y']);
                }
                $('#data-display').html('<div stype="display: none">' +
                    '<h2><p>You can use all of the following operators:</p></h2><h3>' +
                    '<table class="table table-stripped"><thead><tr><th>Operator</th><th>Description</th><th>Examples</th></tr></thead>' +
                    '<tbody>' +
                    ops.map(((x) => '<tr><td>' + x[0] + '</td><td>' + x[1] + '</td><td>' + x[2] + '</td></tr>'))
                        .join('\n') +
                    '</tbody></table></h3>' +
                    '</div>');
                if (util_1.Args.get_tutorial_action() != "redo-cond" &&
                    util_1.Args.get_tutorial_action() != "redo-all")
                    cs.nextStep();
            }
        },
        { setup: function (cs) {
                rpc_2.rpc.call('App.setTutorialDone', [util_1.Args.get_worker_id()], function (res) {
                    rpc_1.logEvent("TutorialDone", null);
                    $('#next-lvl').html("Start Playing");
                    $('#next-lvl').off("click");
                    $('#next-lvl').click(function () {
                        var queryStr = window.location.search;
                        if (util_1.Args.get_noifs()) {
                            queryStr = util_1.queryAppend(queryStr, "noifs");
                        }
                        window.location.replace('game.html' + queryStr);
                    });
                    $('#next-lvl').fadeIn(fadeDelay, function () {
                        curL = util_1.label({ of: $("#next-lvl"), at: "left center" }, "Proceed to the game!", "right");
                    });
                }, util_1.log);
            }
        },
    ];
    if (util_1.Args.get_mode() == "rounds") {
        // Add negative steps to tutorial
        mainScript = mainScript.concat(negativeScript);
    }
    let tutorialScript;
    if (util_1.Args.get_tutorial_action() == "redo-cond") {
        tutorialScript = conditionalsScript;
    }
    else if (util_1.Args.get_noifs()) {
        tutorialScript = mainScript.concat(conclusionScript);
    }
    else {
        tutorialScript = mainScript.concat(conditionalsScript).concat(conclusionScript);
    }
    $(document).ready(function () {
        if (util_1.Args.get_assignment_id() == "ASSIGNMENT_ID_NOT_AVAILABLE") {
            $("#hit-preview-warning").html("<p class='lead'><b>This is just a preview of the HIT. The work you do here will have to be redone when you accept the HIT.</b></p>");
        }
        let di_div = $('#discovered-invariants-div').get()[0];
        progW = new progressWindow_1.ProgressWindow(di_div);
        $('#discovered-invariants-div').hide();
        $('.ignoreWindow').hide();
        scoreW = new scoreWindow_1.ScoreWindow($('#score-div').get()[0]);
        $('#score-div-row').hide();
        $('#next-lvl').hide();
        $('#overlay').hide();
        var curScript = new util_1.Script(tutorialScript);
        $('#next-lvl').click(function () {
            $('#next-lvl').hide();
            if (curL != null)
                util_1.removeLabel(curL);
            curScript.nextStep();
        });
    });
});
//# sourceMappingURL=tutorial.js.map