log = function(arg) { console.log(arg); }

error = function(arg) { log (arg); }

function removeLabel(l) {
  $(l.elem).remove();
  clearInterval(l.timer);
}

function label(elem, txt, direction) {
  p = $(elem).offset();
  var x = p.left, y = p.top;
  var w = $(elem).outerWidth(), h = $(elem).outerHeight();
  var pulseWidth = 5;
  var pulse = 500;

  if (direction == "up") {
    clazz = "arrow_up"
    animate_prop = "top"
    text_pos = "top:  30px;"
    arrow_pos = "left:  20px; top:  20px;"
    var ox = x;
    var oy = y + h + 5;
    var v1 = oy, v2 = v1 + pulseWidth;
  } else if (direction == "down") {
    clazz = "arrow_down"
    animate_prop = "top"
    text_pos = "top:  0px;"
    arrow_pos = "left:  20px; top:  40px;"
    var ox = x;
    var oy = y - 60;
    var v1 = oy, v2 = v1 - pulseWidth;
  } else if (direction == "left") {
    clazz = "arrow_left"
    animate_prop = "left"
    text_pos = "left:  30px;"
    arrow_pos = "left:  0px; top:  0px;"
    var ox = x + w + 5;
    var oy = y;
    var v1 = ox, v2 = ox + pulseWidth;
  } else if (direction == "right") {
    clazz = "arrow_right"
    animate_prop = "left"
    text_pos = "float:  left;"
    arrow_pos = "float: right;"
    var ox = x - 100;
    var oy = y;
    var v1 = ox, v2 = ox - pulseWidth;
  }

  var div = $("<div class='absolute'><div class=" + clazz + 
    " style='" + arrow_pos + "'></div><div style='" + text_pos +
    "position: relative;'>" + txt + "</div></div>")

  div.offset({ left:  ox, top: oy})
  $('body').append(div);
  var ctr = 0;
  var interval = setInterval(function () {
    v = (ctr % 2 == 0 ? v1 : v2) + "px"
    p = {}
    p[animate_prop] = v;
    $(div).animate(p, pulse / 2)
    ctr ++;
  }, pulse / 2)
  return { elem:  div, timer: interval };
}

function cover(elem, col='white', duration=0, cb = null) {
  p = $(elem).offset();
  var div = $("<div class='overlay_cover'></div>")
  div.offset({ left: 0, top: 0})
  $(elem).append(div);
  if (duration=0) {
    $(div).css({ 'background-color': col });
  } else {
    $(div).animate( { 'background-color': col }, duration, cb);
  }
  return div;
}

function uncover(cover, delay=1000, complete_cb) {
  $(cover).animate({ 'background-color': "rgba(255,255,255,0)" }, delay, 
    function () {
      $(cover).remove();
      complete_cb();
    });
}

function Script(steps) {
  var s = this;
  s.step = -1;
  s.steps = steps;
  s.nextStep = function () {
    s.step ++;
    s.steps[s.step].setup(s);
  }

  s.nextStepOnKeyOrTimeout = function(timeout, destructor, key = null) {
   if (timeout > 0) {
     s.timeoutId = setTimeout(function() {
       destructor();
       $('body').off('keypress');
       s.nextStep();
     }, timeout);
   }
   $('body').keypress(function (ev) {
     if (key == null || ev.key == key) {
       $('body').off('keypress');
       destructor();
       if (timeout > 0)
         clearTimeout(s.timeoutId);
       s.nextStep();
       ev.stopPropagation();
       return false;
     }
   });
  }

  s.nextStep();
}
