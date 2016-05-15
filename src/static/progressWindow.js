function ProgressWindow(div, has_ignores = false) {
  var progW = this;
  var ctr = 0;
  var invMap = {}

  progW.element = div;

  //$(div).addClass('.progessWindow')
  //$(div).addClass('box')
  $(div).html("<div class='progressWindow box good centered positioned'> Accepted expressions<br>" +
    "<ul id='good-invariants' style='font-family: monospace; list-style-type: none; padding: 0px; text-align: center;'></ul></div>")
  invUL = $('#good-invariants')

  if (has_ignores) {
    $(div).append("<div class='ignoreWindow box warn centered positioned'>Ignored expressions<br>" +
      "<ul id='ignored-invariants' style='font-family: monospace; list-style-type: none; padding: 0px; text-align: center;'></ul></div>")
    ignUL = $('#ignored-invariants')
  }

  progW.addInvariant = function (inv) {
      // if arrows are running, then stop them

      $(invUL).append("<li class='good-invariant' id='good_" +
        ctr + "'>" + invToHTML(inv) + "</li>")
      invMap[inv] = $('#good_' + ctr)
      ctr++;
  }

  if (has_ignores) {
    progW.addIgnored = function (inv) {
        // if arrows are running, then stop them

        $(ignUL).append("<li class='ignored-invariant' id='ign_" +
          ctr + "'>" + invToHTML(inv) + "</li>")
        invMap[inv] = $('#ign_' + ctr)
        ctr++;
    }
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
      } else if (state == "implies") {
        div.addClass('error')
      } else if (state == "counterexampled") {
        div.addClass('error')
      } else if (state == "ok") {
        div.removeClass('error')
      }
  }

  progW.clearMarks = function () {
    for (var i in invMap) {
      invMap[i].removeClass("error")
    }
  }

  progW.clear = function () {
    $(invUL).html('')
    if (has_ignores)
      $(ignUL).html('')
    invMap = {}
    ctr = 0
  }

  progW.contains = function (inv) {
    return invMap.hasOwnProperty(inv);
  }

}
