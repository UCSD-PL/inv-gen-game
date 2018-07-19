import { info as facebook_info } from "./facebook";

import { Args, disableBackspaceNav, Script, assert, queryAppend, label, removeLabel, log } from './util';
import { StickyWindow } from "./stickyWindow";
import { PatternGameLogic, curLvlSet, setCurLvlSet } from "./gameLogic"
import { invEval, evalResultBool } from "./eval"
import { BaseTracesWindow, PositiveTracesWindow } from "./traceWindow";
import { ScoreWindow } from "./scoreWindow";
import { ProgressWindow } from "./progressWindow";
import { mturkId, rpc, logEvent } from "./rpc";
import { Level } from "./level";
import * as Cookies from "js-cookie";

let traceW: BaseTracesWindow = null;
let stickyW: StickyWindow = null;
let scoreW: ScoreWindow = null;
let progW: ProgressWindow = null;

var mode = Args.get_mode();
var curLvl = null;
var curLvlId;
var curL = null;
var lvls = null;
var gameLogic = null;
var stepTimeout = 5000;
var curScript = null;
var numLvlPassed = 0;

disableBackspaceNav();



function doneScreen(alldone) {
    let assignment_id = Args.get_assignment_id();
    if (assignment_id == "ASSIGNMENT_ID_NOT_AVAILABLE") {
        $("#done-screen").html("<h2 class='text-center'><b>You are previewing the HIT. To perform this HIT, please accept it.</b></h2>");
        $("#done-screen").fadeIn(1000);
        return;
    }
    if (assignment_id !== undefined) {
        let form_elem1 = $("#assignment-id-in-form")[0];
        let form_elem = document.getElementById("assignment-id-in-form");
        (form_elem as HTMLInputElement).value = assignment_id;
    }
    let turk_submit_to = Args.get_turk_submit_to();
    let form = document.getElementById("turk-form");
    if (turk_submit_to !== undefined) {
        (form as HTMLFormElement).action = turk_submit_to + "/mturk/externalSubmit";
    } else {
        (form as HTMLFormElement).action = "end.html";
    }

    function getSelected(category) {
        return $('#turk-form input[name=' + category + ']:checked');
    }

    $("#final-submit").click(function (evt) {
        $("label").removeClass("highlight");
        $('#turk-form-error').html("");
        var categories = ["fun", "challenging", "prog_experience", "math_experience"];
        var selected = $.map(categories, getSelected);
        var answered = $.map(selected, (s) => s.length > 0);

        var missing = false;
        for (var i in answered) {
            if (!answered[i]) {
                $("label." + categories[i]).addClass("highlight");
                missing = true;
            }
        }

        if (missing) {
            $('#turk-form-error').html("Please answer the required questions (highlighted in red)");
            evt.preventDefault();
        }
    });
    let msg = "Good job! You finished " + numLvlPassed + " level(s)! Your score is: " + gameLogic.score + "!";
    if (alldone) {
        msg = "There are no more levels to play at this moment.<br>" + msg;
    }
    $("#done-screen").prepend("<h2 class='good text-center'>" + msg + "</h2>");
    logEvent("GameDone", [numLvlPassed]);

    $("#done-screen").fadeIn(1000);
    //$("#done-screen").click(function() {
    //  window.location.replace('survey.html' + window.location.search);
    //});
}

//const fbSnippet = '<h1>You need to authenticate with Facebook first!</h1><div class="fb - login - button" data-max-rows="1" data-size="large" data-button-type="login_with" data-show-faces="false" data-auto-logout-link="false" data-use-continue-as="false"></div>';
let fbReq: boolean = false;
function facebookLoginAsk() {
    if (fbReq) return;
    fbReq = true;
    $('#facebook-login').show();
}
function facebookLoginDone() {
    if (!fbReq) return;
    fbReq = false;
    $('#facebook-login').hide();
    //curScript.redoStep();
}

$(document).ready(function () {
    console.log("About to start");

    $("#problem_form").submit(function (e) {
        e.preventDefault();
    });

    $("#problem_send").click(function () {
        var errorMessage = $("#problem_form_error");
        var desc = $("#problem_input").val();

        if (desc === "") {
            errorMessage
                .text("Please enter a description of the problem.")
                .show();
            return;
        }

        rpc.call("App.reportProblem", [mturkId(), curLvlId, desc],
            function (res) {
                $("#problem_screen").fadeOut(1000, () => { window.open("game.html?noifs"); });
            }, function () {
                errorMessage
                    .text("An error occurred. Please try again.")
                    .show();
            });
    });

    $("#problem_close").click(function () {
        $("#problem_screen").fadeOut(1000, () => { window.open("game.html?noifs");});
        $("#problem_input").val("");
    });


    let user_id_element: HTMLSpanElement = $('#user-id').get()[0] as HTMLSpanElement;
    facebook_info.setLoginEvents(
        () => {
            user_id_element.textContent = facebook_info.userId;
            Cookies.set("FBID", facebook_info.userId);
            facebookLoginDone();
        },
        () => {
            user_id_element.textContent = "";
            Cookies.remove("FBID");
            facebookLoginAsk();
        });
    facebook_info.getStatus();
    //user_id_element.textContent = facebook_info.userId;
    //if (facebook_info.status !== "connected") {
    //    facebookLoginAsk();
    //}
});

