function ProgressWindow(player, div) {
  var progW = this;
  var ctr = 0;
  var invMap = {}

  progW.element = div;
  var invUL = null;

  $(div).addClass('.progessWindow')
  if (player == 1) {
    $(div).html("Discovered invariants<br>" +
      "<ul id='good-invariants' style='font-family: monospace; list-style-type: none; padding: 0px; text-align: center;'></ul>");
    invUL = $('#good-invariants');
  }
  else {
    $(div).html("Discovered invariants<br>" +
      "<ul id='good-invariants2' style='font-family: monospace; list-style-type: none; padding: 0px; text-align: center;'></ul>");
    invUL = $('#good-invariants2');
  }

  progW.addInvariant = function (inv) {
      $(invUL).append("<li class='good-invariant' id='good_" + player +
        ctr + "'>" + invToHTML(inv) + "</li>")
      invMap[inv] = $('#good_' + player + ctr)
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
        //div.addClass('error')
        div.addClass('bold')
      } else if (state == "tautology") {
      } else if (state == "implies") {
        //div.addClass('error')
        div.addClass('bold')
      } else if (state == "ok") {
      }
  }

  progW.clearMarks = function () {
    for (var i in invMap) {
      //invMap[i].removeClass("error")
      invMap[i].removeClass("bold")
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

  $(div).addClass('box')
  $(div).addClass('progressWindow')
}
