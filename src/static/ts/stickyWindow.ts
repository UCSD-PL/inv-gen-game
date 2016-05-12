class StickyWindow {
  constructor(public parent:  HTMLElement) {
    $(this.parent).addClass("box")
    $(this.parent).addClass("stickyWindow");
    $(this.parent).addClass("col-md-1");
  }
}
/*function StickyWindow(div) {
  var stickyW = this;
  stickyW.element = div;

  $(div).addClass("box");
  $(div).addClass("stickyWindow");
  $(div).addClass("col-md-1");

  stickyW.add = function (pwup) {
    $(div).append(pwup.element);
  }

  stickyW.set = function (pwups) {
    var d = $("<div><p style='text-align: center; font-weight: bold; margin-top: 8px'>Powerups</p><br></div>")
    for (var i in pwups)
      $(d).append(pwups[i].element)

    $(div).html(d);
  }

  stickyW.clear = function () {
    $(div).html("<p style='text-align: center; font-weight: bold; margin-top: 8px'>Powerups</p><br>");
  }

  stickyW.clear();
}
*/
