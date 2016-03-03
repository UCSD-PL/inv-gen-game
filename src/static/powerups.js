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

  this.highlight = function() {
    pwup.element.effect("highlight");
  }
}

function mkMultiplierPwup(id, html, holds, applies, mult, tip) {
  return new Powerup(id + "x" + mult, 
                      "<div class='pwup box'>" + html + "<div class='pwup-mul'>" +
                      "x" + mult + "</div></div>",
                      holds,
                      applies,
                      function (s) { return s * mult; }, tip);
}

function mkVarOnlyPwup(mult = 2) {
  return mkMultiplierPwup("var only", "V", 
    function (inv) {
      return setlen(literals(inv)) == 0;
    }, 
    function (data) { return true; }, mult,
    mult + "x the points if expression contains only variables!")
}

function mkXVarPwup(nvars, mult = 2) {
  return mkMultiplierPwup("NVars=" + nvars, nvars + "V", 
    function (inv) {
      return setlen(identifiers(inv)) == nvars;
    },
    function (data) { return data.variables.length >= nvars; },
    mult,
    mult + "x the points if you use " + nvars +  " variables!")
}

function mkUseOpPwup(op, mult = 2) {
  return mkMultiplierPwup("Use Op: " + op, op, 
    function (inv) {
      return op in operators(inv);
    },
    function (data) { return true; },
    mult,
    mult + "x the points if you use the " + op + " operator!")
}
