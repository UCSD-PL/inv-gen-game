requirejs.config({
  paths: {
    "jquery": "//code.jquery.com/jquery-1.12.0",
    "jquery_color": "//code.jquery.com/color/jquery.color-2.1.2",
    "jquery_ui": "//code.jquery.com/ui/1.11.4/jquery-ui",
    "bootstrap": "//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap",
    '../../ts/facebook': "/game/build/ts/facebook",
    'facebook-js-sdk': "//connect.facebook.net/en_US/sdk",
    "jsonrpcclient": "/game/js/jquery.jsonrpcclient",
    "esprima": '/game/js/esprima',
    "phaser-ce": "/game/flowgame/js/phaser",
    "bonus": "/game/build/ts/bonus",
    "container": "/game/build/ts/container",
    "ctrexGameLogic": "/game/build/ts/ctrexGameLogic",
    "ctrexTracesWindow": "/game/build/ts/ctrexTracesWindow",
    "curvedarrow": "/game/build/ts/curvedarrow",
    "../../ts/eval": "/game/build/ts/eval",
    "gameLogic": "/game/build/ts/gameLogic",
    "../../ts/level": "/game/build/ts/level",
    "logic": "/game/build/ts/logic",
    "powerups": "/game/build/ts/powerups",
    "../../ts/pp": "/game/build/ts/pp",
    "progressWindow": "/game/build/ts/progressWindow",
    "roundsGameLogic": "/game/build/ts/roundsGameLogic",
    "../../ts/rpc": "/game/build/ts/rpc",
    "scoreWindow": "/game/build/ts/scoreWindow",
    "stickyWindow": "/game/build/ts/stickyWindow",
    "../../ts/traceWindow": "/game/build/ts/traceWindow",
    "tutorial": "/game/build/ts/tutorial",
    "../../ts/util": "/game/build/ts/util",
    "boogie": "/game/build/flowgame/ts/boogie",
    "game_graph": "/game/build/flowgame/ts/game_graph",
    "graph": "/game/build/flowgame/ts/graph",
    "geometry": "/game/build/flowgame/ts/geometry",
    "texticon": "/game/build/flowgame/ts/texticon",
    "invgraph_game": "/game/build/flowgame/ts/invgraph_game",
    "new_game": "/game/build/flowgame/ts/new_game",
    "rpc": "/game/build/flowgame/ts/rpc"
  },
  shim: {
    'phaser-ce': { exports: 'Phaser' },
    'facebook-js-sdk': { exports: "FB" },
    "bootstrap": { deps: ["jquery"] },
    "jquery_ui": { deps: ["jquery"] },
    "jquery_color": { deps: ["jquery"] },
    "jsonrpcclient": { deps: ["jquery"] },
    "rpc": { deps: ["jsonrpcclient"] }
  },
  waitSeconds: 0,
});

requirejs(
  [
    "new_game"
  ],
  () => {
	console.log("Loaded...");
  }
);
