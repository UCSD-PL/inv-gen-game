function ScoreWindow(div) {
  var progW = this;
  progW.element = div;
  progW.score = 0;

  $(div).html("")
  $(div).addClass("scoreWindow")
  $(div).addClass("scoreText")

  progW.add = function (num) {
    progW.score += num;
    var addSpan = $("<span class='scoreText scoreFloat'>+" + num + "</span>")
    $(progW.element).html("<span>" + progW.score + "</span>");
    $(div).append(addSpan)
    addSpan.hide("puff", {}, 1000, function() { $(addSpan).remove(); })
  }

  progW.clear = function () {
    progW.score = 0;
    $(progW.element).html("<span>0</span>");
  }

  progW.clear();
}
