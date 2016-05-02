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

function label(arg, txt, direction) {
  var pulseWidth = 5;
  var pulse = 500;
  var pos = null
  
  if (arg.hasOwnProperty("of")) {
    pos = arg
  } else {
    pos = {
      of: arg
    }
    if (direction == "up") {
      pos['at'] = 'center bottom'
    } else if (direction == "down") {
      pos['at'] = 'center top'
    } else if (direction == "left") {
      pos['at'] = 'right center'
    } else if (direction == "right") {
      pos['at'] = 'left center'
    }
  }

  if (direction == "up") {
    clazz = "arrow_up"
    text_pos = "top:  30px;"
    arrow_pos = "left:  20px; top:  20px;"
    arrow_div_pos = "left-10 top"
    arrow_div_pos1 = "left-10 top+" + pulseWidth
  } else if (direction == "down") {
    clazz = "arrow_down"
    text_pos = "top:  0px;"
    arrow_pos = "left:  20px; top:  40px;"
    arrow_div_pos = "center bottom"
    arrow_div_pos1 = "center bottom-" + pulseWidth
  } else if (direction == "left") {
    clazz = "arrow_left"
    text_pos = "left:  30px; top: -10px;"
    arrow_pos = "left:  0px; top:  0px;"
    arrow_div_pos = "left top-7"
    arrow_div_pos1 = "left+" + pulseWidth + " top-7"
  } else if (direction == "right") {
    clazz = "arrow_right"
    text_pos = "float:  left;"
    arrow_pos = "float: right;"
    arrow_div_pos = "right center"
    arrow_div_pos1 = "right-" + pulseWidth +" center"
  }

  var div = $("<div class='absolute'><div class=" + clazz +
    " style='" + arrow_pos + "'></div><div style='" + text_pos +
    "position: relative; text-align: center;'>" + txt + "</div></div>")

  $('body').append(div);

  var arrowDiv = $(div).children('div')[0]
  var apos = $(arrowDiv).position();

  pos.my = arrow_div_pos
  $(div).position(pos)
  pos.using = (css, dummy) => $(div).animate(css, pulse / 2);
  var ctr = 0;
  function mkAnimF(pos, arrow_div_pos, arrow_div_pos1) {
    return function () {
    v = (ctr % 2 == 0 ? arrow_div_pos : arrow_div_pos1)
    pos.my = v;
    $(div).position(pos)
    ctr ++;
  }
  }
  var interval = setInterval(mkAnimF(pos, arrow_div_pos, arrow_div_pos1), pulse / 2)
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
    my: 'right center',
    of: pt,
    at: 'right-40 bottom' 
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
