requirejs.config({
    paths: {
        "jquery": "//code.jquery.com/jquery-1.12.0",
        "jquery_color": "//code.jquery.com/color/jquery.color-2.1.2",
        "jquery_ui": "//code.jquery.com/ui/1.11.4/jquery-ui",
        "bootstrap": "//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap",
        'js-cookie': "//cdn.jsdelivr.net/npm/js-cookie@2/src/js.cookie.min",
        'facebook-js-sdk': "//connect.facebook.net/en_US/sdk",
        'facebook': "../build/ts/facebook",
        "jsonrpcclient": "../js/jquery.jsonrpcclient",
        "esprima": "esprima",
        "bonus": "../build/ts/bonus",
        "container": "../build/ts/container",
        "ctrexGameLogic": "../build/ts/ctrexGameLogic",
        "ctrexTracesWindow": "../build/ts/ctrexTracesWindow",
        "curvedarrow": "../build/ts/curvedarrow",
        "eval": "../build/ts/eval",
        "gameLogic": "../build/ts/gameLogic",
        "level": "../build/ts/level",
        "logic": "../build/ts/logic",
        "powerups": "../build/ts/powerups",
        "pp": "../build/ts/pp",
        "progressWindow": "../build/ts/progressWindow",
        "roundsGameLogic": "../build/ts/roundsGameLogic",
        "rpc": "../build/ts/rpc",
        "scoreWindow": "../build/ts/scoreWindow",
        "stickyWindow": "../build/ts/stickyWindow",
        "traceWindow": "../build/ts/traceWindow",
        "tutorial": "../build/ts/tutorial",
        "start": "../build/ts/start",
        "util": "../build/ts/util"
    },
    shim: {
        'facebook-js-sdk': { exports: "FB" },
        "bootstrap": { deps: ["jquery"] },
        "jquery_ui": { deps: ["jquery"] },
        "jquery_color": { deps: ["jquery"] },
        "jsonrpcclient": { deps: ["jquery"] },
        "rpc": { deps: ["jsonrpcclient"] },
        "js-cookie": { deps: ["jquery"] }
    },
    onNodeCreated: function (node, config, module, path) {
        // Here's  alist of differet integrities for different scripts
        // Append to this list for all scripts that you want SRI for
        var sri = {
            jquery: "sha256-yFU3rK1y8NfUCd/B4tLapZAy9x0pZCqLZLmFL3AWb7s=",
            jquery_color: "sha256-1Cn7TdfHiMcEbTuku97ZRSGt2b3SvZftEIn68UMgHC8=",
            jquery_ui: "sha256-DI6NdAhhFRnO2k51mumYeDShet3I8AKCQf/tf7ARNhI=",
            bootstrap: "sha256-3vw5dArBhZ2OJ4XtRzIIQJYn6Hrd1fePLeqsuToS1R0="
        };
        if (sri[module]) {
            node.setAttribute("integrity", sri[module]);
            node.setAttribute("crossorigin", "anonymous");
        }
    },
    waitSeconds: 10
});


requirejs(
    [
        "jquery",
        "bootstrap",
        "jquery_color",
        "jquery_ui",
        "js-cookie",
        "facebook",
        "start"
    ],
    () => {
        console.log("Start page loaded...");
    }
);

