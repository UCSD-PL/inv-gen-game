function ScoreWindow(div) {
  var progW = this;
  progW.element = div;
  progW.score = 0;

  $(div).html("")
  $(div).addClass("scoreWindow")

  progW.add = function (num) {
    progW.score += num;
    $(progW.element).html("<span>" + progW.score + "</span>");
  }

  progW.clear = function () {
    progW.score = 0;
    $(progW.element).html("<span>0</span>");
  }

  progW.clear();
}
