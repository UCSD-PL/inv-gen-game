function ScoreWindow(player, div) {
  var progW = this;
  progW.element = div;
  progW.score = 0;

  $(div).html("")
  if(player == 1) {
    $(div).addClass("scoreWindow1")
    $(div).addClass("scoreText1")
  }
  else if(player == 2) {
    $(div).addClass("scoreWindow2")
    $(div).addClass("scoreText2")
  }

  progW.add = function (num) {
    progW.score += num;
    $(progW.element).html("<span>" + progW.score + "</span>");
    var addSpan = null;
    if(player == 1) {
      addSpan = $("<span class='scoreText1 scoreFloat'>+" + num + "</span>")
    }
    else if(player == 2) {
      addSpan = $("<span class='scoreText2 scoreFloat'>+" + num + "</span>")
    }
    else {
      addSpan = $("<span class='scoreText scoreFloat'>+" + num + "</span>")
    }
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
