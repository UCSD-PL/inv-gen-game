function ScoreWindow(div) {
  var progW = this;
  progW.element = div;
  progW.score = 0;

  $(div).html("")
  $(div).addClass("scoreWindow")
  $(div).addClass("scoreText")

  progW.add = function (num) {
    progW.score += num;
    $(progW.element).html("<span>" + progW.score + "</span>");
    var addSpan = $("<span class='scoreText scoreFloat'>+" + num + "</span>")
    $(div).append(addSpan)
    addSpan.hide({ effect: "puff", easing:"swing", duration:1000, complete: function() {
      $(addSpan).remove();
    }})
  }

  progW.clear = function () {
    progW.score = 0;
    $(progW.element).html("<span>0</span>");
  }

  progW.clear();
}
