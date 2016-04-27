/*
 * A powerup is an object with 3 fields:
 *  html:str - the html to display
 *  holds(inv:str) -> bool  - function that determines if it holds to an invariant.
 *  transform(score:int) -> int - how it transforms the score
 */
function Powerup(player, id, html, holds, applies, transform, tip) {
  var pwup = this;
  this.id = id;
  this.html = html;
  this.element = $(html);
  $(this.element).attr("title", tip)
  $(this.element).tooltip({ position: {
    within: $(".container"),
    my: "center top+15",
    at: "center bottom",
    collision:  "none none",
  }})
  this.holds = holds;
  this.applies = applies;
  this.transform = transform;

  this.highlight = function(cb) {
    if(player == 1) {
      pwup.element.effect("highlight", { color: "#f00000" }, 1000, cb);
    }
    else if(player == 2) {
      pwup.element.effect("highlight", { color: "#0000f0" }, 1000, cb);
    }
    else {
      pwup.element.effect("highlight", { color: "#00d000" }, 1000, cb);
    }
  }
}

function mkMultiplierPwup(player, id, html, holds, applies, mult, tip) {
  var htmlContent = html + "<div class='pwup-mul'>" +
  mult + "X</div></div>";

  if(player == 1) {
    htmlContent = "<div class='pwup1 box'>" + htmlContent
  }
  else if(player == 2) {
    htmlContent = "<div class='pwup2 box'>" + htmlContent
  }
  else {
    htmlContent = "<div class='pwup box'>" + htmlContent
  }

  return new Powerup(player, id + "x" + mult,
                      htmlContent,
                      holds,
                      applies,
                      function (s) { return s * mult; }, tip);
}

function mkVarOnlyPwup(player, mult = 2) {
  return mkMultiplierPwup(player, "var only", "<span style='position: absolute; left:13px'>1</span>" +
                                      "<span style='position: absolute;color:black; left:10px;'>&#10799;</span>",
    function (inv) {
      return setlen(literals(inv)) == 0;
    },
    function (data) { return true; }, mult,
    mult + "X if you don't use constants")
}

function mkXVarPwup(player, nvars, mult = 2) {
  return mkMultiplierPwup(player, "NVars=" + nvars, nvars + "V",
    function (inv) {
      return setlen(identifiers(inv)) == nvars;
    },
    function (data) { return data.variables.length >= nvars && data.variables.length != 1; },
    mult,
    mult + "X if you use " + nvars +  " variable(s)")
}

function mkUseOpPwup(player, op, mult = 2) {
  var ppOp = op;

  if (op == "<" || op == ">" || op == "<=" || op == ">=")
    ppOp = "an inequality"
  else if (op == "==" || op == "=")
    ppOp = "an equality"
  else if (op == "*")
    ppOp = "multiplication"
  else if (op == "+")
    ppOp = "addition"

  return mkMultiplierPwup(player, "Use Op: " + op, op,
    function (inv) {
      return op in operators(inv);
    },
    function (data) { return true; },
    mult,
    mult + "X if you use " + ppOp)
}

function mkUseOpsPwup(player, ops, html, name, mult = 2) {
  return mkMultiplierPwup(player, "Use Ops: " + ops, html,
    function (inv) {
      var inv_ops = operators(inv);
      for (var i in ops) {
        if (ops[i] in inv_ops)
          return true;
      }

      return false;
    },
    function (data) { return true; },
    mult,
    mult + "X if you use " + name)
}

/*
 * First iteration on powerup suggestion -
 * show all applicable powerups, that haven't
 * been used in threshold moves.
 */
function PowerupSuggestionAll(player, gl, threshold) {
  var pwupS = this;
  pwupS.gameLogic = gl;
  pwupS.threshold = threshold;
  var all_pwups = [
    mkVarOnlyPwup(player),
    mkXVarPwup(player, 1,2),
    mkXVarPwup(player, 2,2),
    mkXVarPwup(player, 3,2),
    mkXVarPwup(player, 4,2),
    mkUseOpsPwup(player, ["<=", ">=", "<", ">"], "<>", "inequality"),
    mkUseOpsPwup(player, ["=="], "=", "equality"),
    mkUseOpPwup(player, "*"),
    mkUseOpPwup(player, "+"),
  ]
  pwupS.actual = []
  pwupS.age = {}

  // Called whenever a new level is loaded
  this.clear = function (lvl) {
    pwupS.actual = [];
    pwupS.age = {};

    for (var i in all_pwups) {
      if (all_pwups[i].applies(lvl)) {
        pwupS.actual.push(all_pwups[i])
        pwupS.age[all_pwups[i].id] = pwupS.threshold+1;
        pwupS.gameLogic.addPowerup(all_pwups[i]);
      }
    }
  }

  this.invariantTried = function (inv) {
    for (var i in pwupS.actual) {
      if (!pwupS.actual[i].holds(inv))
        pwupS.age[pwupS.actual[i].id] ++;
      else {
        pwupS.age[pwupS.actual[i].id] = 0;
      }
    }
  }

  this.getPwups = function() {
    return pwupS.actual.filter(function (pwup) {
      return pwupS.age[pwup.id] >= pwupS.threshold
    })
  }
}

/*
 * Second iteration on powerup suggestion -
 * consider the full history so far. Disply the top N
 * powerups, ordered by LRU/LFU.
 */
function PowerupSuggestionFullHistory(player, gl, n, type) {
  var pwupS = this;
  pwupS.gameLogic = gl;
  pwupS.nDisplay = n;
  pwupS.gen = 0;
  pwupS.nUses = {};
  pwupS.lastUse = {};
  pwupS.type = type;

  var all_pwups = [
    mkVarOnlyPwup(player),
    mkXVarPwup(player, 1,2),
    mkXVarPwup(player, 2,2),
    mkXVarPwup(player, 3,2),
    mkXVarPwup(player, 4,2),
    mkUseOpsPwup(player, ["<=", ">=", "<", ">"], "<>", "inequality"),
    mkUseOpsPwup(player, ["=="], "=", "equality"),
    mkUseOpPwup(player, "*"),
    mkUseOpPwup(player, "+"),
  ]

  for (var i in all_pwups) {
    pwupS.nUses[all_pwups[i].id] = 0;
    pwupS.lastUse[all_pwups[i].id] = -1;
  }

  pwupS.actual = []
  pwupS.age = {}

  function computeOrders () {
    if (pwupS.gen > 0)
      pwupS.sortFreq = pwupS.actual.map(function (x, ind)  { return [ pwupS.nUses[x.id] / pwupS.gen, x ]})
    else
      pwupS.sortFreq = pwupS.actual.map(function (x, ind)  { return [ 0, x ] })

    pwupS.sortLast = pwupS.actual.map(function (x, ind)  { return [ pwupS.lastUse[x.id] , x ] })

    pwupS.sortFreq.sort(function (a,b) { return a[0] - b[0] })
    pwupS.sortLast.sort(function (a,b) { return a[0] - b[0] })
  }

  // Called whenever a new level is loaded
  this.clear = function (lvl) {
    pwupS.actual = [];
    pwupS.age = {};

    for (var i in all_pwups) {
      if (all_pwups[i].applies(lvl)) {
        pwupS.actual.push(all_pwups[i])
      }
    }

    computeOrders();
  }

  this.invariantTried = function (inv) {
    for (var i in pwupS.actual) {
      if (pwupS.actual[i].holds(inv)) {
        pwupS.nUses[pwupS.actual[i].id] ++;
        pwupS.lastUse[pwupS.actual[i].id] = pwupS.gen;
      }
    }
    pwupS.gen ++
    computeOrders();
  }

  this.getPwups = function() {
    if (pwupS.type == "lru") {
      return pwupS.sortLast.slice(0, pwupS.nDisplay).map(snd);
    } else {
      assert(pwupS.type == "lfu");
      return pwupS.sortFreq.slice(0, pwupS.nDisplay).map(snd);
    }
  }
}
