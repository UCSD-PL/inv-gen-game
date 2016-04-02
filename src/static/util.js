log = function(arg) { console.log(arg); }
error = function(arg) { log (arg); }
assert = function (b, msg) {
  if (!b)
    error(msg);
}

function fst(x) { return x[0]; }
function snd(x) { return x[1]; }

function shuffle(arr) {
    var j;
    for (var i = 0; i < arr.length; i++) {
        j = Math.floor(Math.random() * arr.length);
        var x = arr[i];
        arr[i] = arr[j];
        arr[j] = x;
    }
};

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
    text_pos = "left:  30px; top: -10px;"
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
    "position: relative; text-align: center;'>" + txt + "</div></div>")

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

function Script(steps) {
  var s = this;
  s.step = -1;
  s.steps = steps;
  s.nextStep = function () {
    s.step ++;
    s.steps[s.step].setup(s);
  }

  s.nextStepOnKeyOrTimeout = function(timeout, destructor, keyCode = null) {
   if (timeout > 0) {
     s.timeoutId = setTimeout(function() {
       destructor();
       $('body').off('keypress');
       s.nextStep();
     }, timeout);
   }
   $('body').keypress(function (ev) {
     if (keyCode === null || ev.which == keyCode) {
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

/* In-place union - modifies s1 */
function union(s1, s2) {
  for (var e in s2) {
    s1[e] = true;
  }

  return s1;
}

function setlen(s) {
  var l = 0;
  for (var i in s) {
    if (s.hasOwnProperty(i))  l++;
  }
  return l;
}

function onFirstCall(firstCb, laterCb, registerFn) {
  function wrapped_cb() {
    firstCb.call(arguments)
    regusterFn(laterCb)
  }
  return wrapped_cb;
}
