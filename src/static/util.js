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
  s.cancelCb = null;
  s.nextStep = function () {
    s.step ++;
    s.cancelCb = null;
    s.steps[s.step].setup(s);
  }

  s.nextStepOnKeyOrTimeout = function(timeout, destructor, keyCode = null) {
   if (timeout > 0) {
     s.timeoutId = setTimeout(function() {
       destructor();
       $('body').off('keyup');
       $('body').off('keypress');
       s.nextStep();
     }, timeout);
   }
   s.cancelCb = function () {
     if (timeout > 0)
       clearTimeout(s.timeoutId);
     $('body').off('keyup');
     $('body').off('keypress');
     destructor();
   }
   $('body').keypress(function (ev) {
     if (keyCode === null || ev.which == keyCode) {
       ev.stopPropagation();
       return false;
     }
   })
   $('body').keyup(function (ev) {
     if (keyCode === null || ev.which == keyCode) {
       $('body').off('keyup');
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

  s.cancel = function() { if (s.cancelCb) s.cancelCb(); }
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

function assert(c, msg) {
  if (!c)
    throw msg || "Assertion failed."
}

function forAll(boolL) {
  return boolL.map(x => x ? 1 : 0).reduce((x,y)=>x+y, 0) == boolL.length
}

function zip(a1, a2) {
  return a1.map((_,i) => [a1[i], a2[i]])
}

function KillSwitch(pt) {
  var ks = this;
  ks.pt  = pt;
  ks.pos = 0; //Up
  ks.html = $('<div class="kill-switch" style="position: absolute;"></div>')
  pOff = $(pt).offset();
  pW =  $(pt).width(); 
  das.position(ks.html, {
    my: 'right top ',
    of: pt,
    at: 'right-40 top+10' 
  })
  $('body').append(ks.html)

  this.onFlipCb = (i)=>0;
  this.onFlip = function (cb) {
    ks.onFlipCb = cb;
  }
  this.refresh = function () {
    if (ks.pos == 0) {
      ks.html.html("<img src='knife-up.gif' style='width: 30; height: 60px;'/>")
    } else {
      ks.html.html("<img src='knife-down.gif' style='width: 30; height: 60px;'/>")
    }
  }

  $(ks.html).click(function () {
    if (ks.pos == 0) {
      ks.pos = 1;
    } else {
      ks.pos = 0;
    }
    ks.refresh()
    ks.onFlipCb(ks.pos)
  })

  this.destroy = function () {
    $(ks.html).remove()
    das.remove(ks.html)
  }

  this.flip = function () { ks.html.click(); }

  this.refresh()
}

function DynamicAttachments(div) {
  var da = this;
  da.objs = []
  da.position = function(target, spec) {
    var htmlTarget = $(target)[0]
    for (var i in da.objs) {
      if (da.objs[i][0] == htmlTarget) {
        da.objs[i][1] = spec;
        $(htmlTarget).position(spec)
        return
      }
    }
    da.objs.push([htmlTarget, spec])
    $(htmlTarget).position(spec)
  }
  da.reflowAll = () => { 
    for (var i in da.objs) {
      $(da.objs[i][0]).position(da.objs[i][1])
    }
  };
  da.remove = (elmt) => { da.objs = da.objs.filter( (item) => $(item)[0] != $(elmt)[0] ) }
}

var das = new DynamicAttachments();
