function StickyWindow(div) {
  var stickyW = this;
  stickyW.element = div;
  stickyW.idMap = {};
  var ctr = 0;

  $(div).addClass("box");
  $(div).addClass("stickyWindow");
  $(div).addClass("col-md-1");
  
  stickyW.add = function (html) {
    var id = ctr
    ctr++
    $(div).append("<div class='row' id='sticky_"  + id + "'> " + html + "</div>");
    stickyW.idMap[id] = $('sticky_' + id)
    return id;
  }

  stickyW.remove = function(id) {
    stickyW.idMap[id].remove();
  }

  stickyW.clear = function () {
    ctr = 0;
    stickyW.idMap = {}
    $(div).html("&nbsp");
  }

  stickyW.clear();
}
