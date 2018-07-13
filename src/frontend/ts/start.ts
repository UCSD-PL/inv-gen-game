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
    let loginScreen = $('#login-screen');//.get()[0];
    let logoutScreen = $('#logout-screen');//.get()[0];
    let playScreen = $('#play-screen');//.get()[0];
    
    let user_id_element: HTMLSpanElement = $('#user-id').get()[0] as HTMLSpanElement;
    let user_name_element: HTMLSpanElement = $('#user-name').get()[0] as HTMLSpanElement;
    let user_picture_element: HTMLImageElement = $('#user-picture').get()[0] as HTMLImageElement;
    
    facebook_info.setLoginEvents(
        () => {
            user_id_element.textContent = facebook_info.userId;
            playScreen.show();
            loginScreen.hide();
            logoutScreen.show();
            FB.api('/me', { fields: 'name, picture' }, response => {
                user_name_element.textContent = response.name;
                user_picture_element.src = response.picture.data.url;
            });
            console.log("FB Logged in");
        },
        () => {
            user_id_element.textContent = "";
            user_name_element.textContent = "";
            loginScreen.show();
            logoutScreen.hide();
            playScreen.hide();
            console.log("FB Logged out");
        });
    facebook_info.autologin = false;
    facebook_info.getStatus();
});