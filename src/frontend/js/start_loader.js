requirejs.config({
    paths: {
        "jquery": "//code.jquery.com/jquery-1.12.0",
        "jquery_color": "//code.jquery.com/color/jquery.color-2.1.2",
        "jquery_ui": "//code.jquery.com/ui/1.11.4/jquery-ui",
        "bootstrap": "//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap",
        'facebook-js-sdk': "//connect.facebook.net/en_US/sdk",
        'facebook': "../build/facebook",
        "jsonrpcclient": "../js/jquery.jsonrpcclient",
        "esprima": "esprima",
        "bonus": "../build/bonus",
        "container": "../build/container",
        "ctrexGameLogic": "../build/ctrexGameLogic",
        "ctrexTracesWindow": "../build/ctrexTracesWindow",
        "curvedarrow": "../build/curvedarrow",
        "eval": "../build/eval",
        "gameLogic": "../build/gameLogic",
        "level": "../build/level",
        "logic": "../build/logic",
        "powerups": "../build/powerups",
        "pp": "../build/pp",
        "progressWindow": "../build/progressWindow",
        "roundsGameLogic": "../build/roundsGameLogic",
        "rpc": "../build/rpc",
        "scoreWindow": "../build/scoreWindow",
        "stickyWindow": "../build/stickyWindow",
        "traceWindow": "../build/traceWindow",
        "tutorial": "../build/tutorial",
        "start": "../build/start",
        "util": "../build/util"
    },
    shim: {
        'facebook-js-sdk': { exports: "FB" },
        "bootstrap": { deps: ["jquery"] },
        "jquery_ui": { deps: ["jquery"] },
        "jquery_color": { deps: ["jquery"] },
        "jsonrpcclient": { deps: ["jquery"] },
        "rpc": { deps: ["jsonrpcclient"] }
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
        "facebook",
        "start"
    ],
    () => {
        console.log("Start page loaded...");
    }
);

