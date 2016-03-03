function StickyWindow(div) {
  var stickyW = this;
  stickyW.element = div;

  $(div).addClass("box");
  $(div).addClass("stickyWindow");
  $(div).addClass("col-md-1");
  
  stickyW.add = function (pwup) {
    $(div).append(pwup.element);
  }

  stickyW.clear = function () {
    $(div).html("Powerups:<br><hr>");
  }

  stickyW.clear();
}
