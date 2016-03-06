/*
 * A powerup is an object with 3 fields:
 *  html:str - the html to display
 *  holds(inv:str) -> bool  - function that determines if it holds to an invariant. 
 *  transform(score:int) -> int - how it transforms the score
 */ 
function Powerup(id, html, holds, applies, transform, tip) {
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
    pwup.element.effect("highlight", { color: "#008000" }, 500, cb);
  }
}

function mkMultiplierPwup(id, html, holds, applies, mult, tip) {
  return new Powerup(id + "x" + mult, 
                      "<div class='pwup box'>" + html + "<div class='pwup-mul'>" +
                      mult + "X</div></div>",
                      holds,
                      applies,
                      function (s) { return s * mult; }, tip);
}

function mkVarOnlyPwup(mult = 2) {
  return mkMultiplierPwup("var only", "<span style='position: absolute; left:13px'>1</span>" +
                                      "<span style='position: absolute;color:red; left:10px'>&#10799;</span>", 
    function (inv) {
      return setlen(literals(inv)) == 0;
    }, 
    function (data) { return true; }, mult,
    "x" + mult + " if you don't use constants!")
}

function mkXVarPwup(nvars, mult = 2) {
  return mkMultiplierPwup("NVars=" + nvars, nvars + "V", 
    function (inv) {
      return setlen(identifiers(inv)) == nvars;
    },
    function (data) { return data.variables.length >= nvars; },
    mult,
    "x " + mult + " if you use " + nvars +  " variable(s)!")
}

function mkUseOpPwup(op, mult = 2) {
  var ppOp = op;

  if (op == "<" || op == ">")
    ppOp = "an inequality"
  else if (op == "==" || op == "=")
    ppOp = "an equality"
  else if (op == "*")
    ppOp = "multiplication"
  else if (op == "+")
    ppOp = "addition"
    
  return mkMultiplierPwup("Use Op: " + op, op, 
    function (inv) {
      return op in operators(inv);
    },
    function (data) { return true; },
    mult,
    "x" + mult + " if you use " + ppOp)
}

function mkUseOpsPwup(ops, html, name, mult = 2) {
  return mkMultiplierPwup("Use Ops: " + ops, html, 
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
    "x" + mult + " if you use " + name)
}

function PowerupSuggestion(gl) {
  var pwupS = this;
  pwupS.gameLogic = gl;
  var all_pwups = [
    mkVarOnlyPwup(),
    mkXVarPwup(1,2),
    mkXVarPwup(2,2),
    mkXVarPwup(3,2),
    mkXVarPwup(4,2),
    mkUseOpsPwup(["<", ">"], "<", "strict inequality"),
    mkUseOpsPwup(["<=", "=>"], "&#8804;", "inequality"),
    mkUseOpsPwup(["=="], "=", "equality"),
    mkUseOpPwup("*"),
    mkUseOpPwup("+"),
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
        pwupS.age[all_pwups[i].id] = 0;
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

      pwupS.gameLogic.addPowerup(pwupS.actual[i]);
    }    
  }
}
