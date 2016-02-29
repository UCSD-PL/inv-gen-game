function ProgressWindow(div) {
  var progW = this;
  var ctr = 0;
  var invMap = {}

  progW.element = div;

  $(div).addClass('.progessWindow')
  $(div).html("Discovered invariants:<br>" +
    "<ul id='good-invariants' style='font-family:monospace;'></ul>")

  invUL = $('#good-invariants')

  progW.addInvariant = function (inv) {
      $(invUL).append("<li class='good-invariant' id='good_" +
        ctr + "'>" + invToHTML(inv) + "</li>")
      invMap[inv] = $('#good_' + ctr)
      ctr++;
  }

  progW.removeInvariant = function (inv) {
      $(invMap[inv]).remove();
  }

  progW.markInvariant = function (inv, state) {
      var div = invMap[inv]

      if (div === undefined) {
        console.log("Unknown invariant " + inv);
        return
      }

      if (state == "checking") {
      } else if (state == "duplicate") {
        div.addClass('error')
      } else if (state == "tautology") {
      } else if (state == "implied") {
      } else if (state == "ok") {
      }
  }

  progW.clearMarks = function () {
    for (var i in invMap) {
      invMap[i].removeClass("error")
    }
  }

  progW.clear = function () {
    $(invUL).html('')
    invMap = {}
    ctr = 0
  }

  progW.contains = function (inv) {
    return invMap.hasOwnProperty(inv);
  }
}
