/*
 * A powerup is an object with 3 fields:
 *  html:str - the html to display
 *  applies(inv:str) -> bool  - function that determines if it applies to an invariant. 
 *  transform(score:int) -> int - how it transforms the score
 */ 
function Powerup(id, html, applies, transform) {
  var pwup = this;
  this.id = id;
  this.html = html;
  this.element = $(html);
  this.applies = applies;
  this.transform = transform;

  this.highlight = function() {
    pwup.element.effect("highlight");
  }
}

function mkMultiplierPwup(id, html, applies, mult) {
  return new Powerup(id + "x" + mult, html, applies, function (s) { return s * mult; });
}

function mkVarOnlyPwup(mult = 2) {
  return mkMultiplierPwup("var only", "<span>Var Only</span>", 
    function (inv) {
      return setlen(literals(inv)) == 0;
    }, mult)
}

function mkXVarPwup(nvars, mult = 2) {
  return mkMultiplierPwup("NVars=" + nvars, "NVars=" + nvars, 
    function (inv) {
      return setlen(identifiers(inv)) == nvars;
    }, mult)
}

function mkUseOpPwup(op, mult = 2) {
  return mkMultiplierPwup("Use Op: " + op, "Use Op: " + op, 
    function (inv) {
      return op in operators(inv);
    }, mult)
}
