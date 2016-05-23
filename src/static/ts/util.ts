type directionT = "up" | "down" | "left" | "right"
function log(arg: any): void { console.log(arg); }
function error(arg: any): void { log(arg); }
function assert(c: boolean, msg?: any): void {
  if (msg === undefined)
    msg = "Oh-oh";

  if (!c)
    throw msg || "Assertion failed.";
}


function fst<T1, T2>(x: [T1, T2]): T1 { return x[0]; }
function snd<T1, T2>(x: [T1, T2]): T2 { return x[1]; }

function shuffle<T>(arr: T[]): void {
  let j: number = null;
  for (let i: number = 0; i < arr.length; i++) {
    j = Math.floor(Math.random() * arr.length);
    let x = arr[i];
    arr[i] = arr[j];
    arr[j] = x;
  }
};

class Label {
  public pos: JQueryUI.JQueryPositionOptions;
  public elem: JQuery;
  public timer: any;

  constructor(pos_arg: (JQueryUI.JQueryPositionOptions | HTMLElement),
    public txt: string,
    public direction: directionT,
    public pulseWidth = 5,
    public pulse = 500) {

    if (pos_arg.hasOwnProperty("of")) {
      this.pos = <JQueryUI.JQueryPositionOptions>pos_arg;
    } else {
      this.pos = {
        of: <HTMLElement>pos_arg
      };
      if (direction === "up") {
        this.pos["at"] = "center bottom";
      } else if (direction === "down") {
        this.pos["at"] = "center top";
      } else if (direction === "left") {
        this.pos["at"] = "right center";
      } else if (direction === "right") {
        this.pos["at"] = "left center";
      }
    }

    let clazz: string = "", text_pos: string = "", arrow_pos: string = "",
      arrow_div_pos: string = "", arrow_div_pos1: string = "";

    if (direction === "up") {
      clazz = "arrow_up";
      text_pos = "top:  30px;";
      arrow_pos = "left:  20px; top:  20px;";
      arrow_div_pos = "left-10 top";
      arrow_div_pos1 = "left-10 top+" + pulseWidth;
    } else if (direction === "down") {
      clazz = "arrow_down";
      text_pos = "top:  0px;";
      arrow_pos = "left:  20px; top:  40px;";
      arrow_div_pos = "center bottom";
      arrow_div_pos1 = "center bottom-" + pulseWidth;
    } else if (direction === "left") {
      clazz = "arrow_left";
      text_pos = "left:  30px; top: -10px;";
      arrow_pos = "left:  0px; top:  0px;";
      arrow_div_pos = "left top-7";
      arrow_div_pos1 = "left+" + pulseWidth + " top-7";
    } else if (direction === "right") {
      clazz = "arrow_right";
      text_pos = "float:  left;";
      arrow_pos = "float: right;";
      arrow_div_pos = "right center";
      arrow_div_pos1 = "right-" + pulseWidth + " center";
    }

    let div = $("<div class='absolute'><div class=" + clazz +
      " style='" + arrow_pos + "'></div><div style='" + text_pos +
      "position: relative; text-align: center;'>" + txt + "</div></div>");

    $("body").append(div);

    let arrowDiv = $(div).children("div")[0];
    let apos = $(arrowDiv).position();

    this.pos.my = arrow_div_pos;
    $(div).position(this.pos);
    this.pos.using = (css, dummy) => $(div).animate(css, pulse / 2);

    let ctr = 0;
    let lbl = this;

    this.timer = setInterval(function() {
      let v = (ctr % 2 === 0 ? arrow_div_pos : arrow_div_pos1);
      lbl.pos.my = v;
      $(div).position(lbl.pos);
      ctr++;
    }, this.pulse / 2);
    this.elem = div;
  }

  remove(): void {
    this.elem.remove();
    clearInterval(this.timer);
  }
}
function removeLabel(l: Label) {
  l.remove();
}

function label(arg: (JQueryUI.JQueryPositionOptions | HTMLElement),
  txt: string,
  direction: directionT) {
  return new Label(arg, txt, direction);
}

interface IStep {
  setup(cs: any): any;
}

class Script {
  step: number = -1;
  cancelCb: () => void = null;
  timeoutId: any;

  constructor(public steps: IStep[]) { this.nextStep(); }
  nextStep(): void {
    this.step++;
    this.cancelCb = null;
    this.steps[this.step].setup(this);
  }

  nextStepOnKeyOrTimeout(timeout: number,
    destructor: () => any,
    keyCode: number = null) {
    let s = this;
    if (timeout > 0) {
      this.timeoutId = setTimeout(function() {
        destructor();
        $("body").off("keyup");
        $("body").off("keypress");
        s.nextStep();
      }, timeout);
    }

    this.cancelCb = function() {
      if (timeout > 0)
        clearTimeout(this.timeoutId);
      $("body").off("keyup");
      $("body").off("keypress");
      destructor();
    };

    $("body").keypress(function(ev) {
      if (keyCode === null || ev.which === keyCode) {
        ev.stopPropagation();
        return false;
      }
    });

    $("body").keyup(function(ev) {
      if (keyCode === null || ev.which === keyCode) {
        $("body").off("keyup");
        $("body").off("keypress");
        destructor();
        if (timeout > 0)
          clearTimeout(this.timeoutId);
        s.nextStep();
        ev.stopPropagation();
        return false;
      }
    });
  }
  cancel(): void {
    if (this.cancelCb)
      this.cancelCb();

    this.step = this.steps.length + 1;
  }
}

/* In-place union - modifies s1 */
function union(s1: any, s2: any): any {
  for (let e in s2) {
    s1[e] = true;
  }

  return s1;
}

function setlen(s: any): number {
  let l = 0;
  for (let i in s) {
    if (s.hasOwnProperty(i)) l++;
  }
  return l;
}

function forAll(boolL: boolean[]): boolean {
  return boolL.map(x => x ? 1 : 0).reduce((x, y) => x + y, 0) === boolL.length;
}

function zip<T1, T2>(a1: T1[], a2: T2[]): [T1, T2][] {
  return a1.map((_, i: number) => <[T1, T2]>[a1[i], a2[i]]);
}

class KillSwitch {
  pos: number = 0;
  onFlipCb: (i: number) => any = (i) => 0;
  container: JQuery;

  constructor(public parent: HTMLElement) {
    this.container = $("<div class='kill-switch' style='position: absolute;'></div>");
    let pOff = $(this.parent).offset();
    let pW = $(this.parent).width();
    das.position(this.container[0], {
      my: "right center",
      of: this.parent,
      at: "right-40 bottom"
    });
    $("body").append(this.container);

    let ks = this;
    this.container.click(function() {
      if (ks.pos === 0) {
        ks.pos = 1;
      } else {
        ks.pos = 0;
      }
      ks.refresh();
      ks.onFlipCb(ks.pos);
    });
    this.refresh();
  }

  onFlip(cb: (i: number) => any): void {
    this.onFlipCb = cb;
  }

  refresh(): void {
    if (this.pos === 0) {
      this.container.html("<img src='knife-up.gif' style='width: 30; height: 60px;'/>");
    } else {
      this.container.html("<img src='knife-down.gif' style='width: 30; height: 60px;'/>");
    }
  }

  destroy(): void {
    this.container.remove();
    das.remove(this.container[0]);
  }

  flip(): void {
    this.container.click();
  }
}

class DynamicAttachments {
  objs: [HTMLElement, JQueryUI.JQueryPositionOptions][] = [];
  position(target: HTMLElement, spec: JQueryUI.JQueryPositionOptions) {
    for (let i in this.objs) {
      if (this.objs[i][0] === target) {
        this.objs[i][1] = spec;
        $(target).position(spec);
        return;
      }
    }
    this.objs.push([target, spec]);
    $(target).position(spec);
  }

  reflowAll(): void {
    for (let i in this.objs) {
      $(this.objs[i][0]).position(this.objs[i][1]);
    }
  }

  remove(elmt: HTMLElement): void {
    this.objs = this.objs.filter((item) => item[0] !== elmt);
  }
}

let das = new DynamicAttachments();

function disableBackspaceNav() {
  $(document).unbind("keydown").bind("keydown", function(event) {
    let doPrevent = false;
    if (event.keyCode === 8) {
      let d = event.srcElement || event.target;
      if (d.tagName.toUpperCase() === "INPUT") {
        let di = <HTMLInputElement>d;
        if (di.type.toUpperCase() === "TEXT" ||
          di.type.toUpperCase() === "PASSWORD" ||
          di.type.toUpperCase() === "FILE" ||
          di.type.toUpperCase() === "SEARCH" ||
          di.type.toUpperCase() === "EMAIL" ||
          di.type.toUpperCase() === "NUMBER" ||
          di.type.toUpperCase() === "DATE") {
          doPrevent = di.readOnly || di.disabled;
        } else {
          doPrevent = true;
        }
      } else if (d.tagName.toUpperCase() === "TEXTAREA") {
        let dta = <HTMLTextAreaElement>d;
        doPrevent = dta.readOnly || dta.disabled;
      } else {
        doPrevent = true;
      }

      if (doPrevent) {
        event.preventDefault();
      }
    }
  });
}
