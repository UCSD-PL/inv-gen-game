type holdsT = (inv:invariantT) => boolean
type transformT = (score:number) => number
type appliesT = (lvl: Level) => boolean

interface IPowerup {
  id: string;
  html: string;
  element: JQuery;
  holds(inv:invariantT): boolean;
  transform(score:number): number;
  applies(lvl: Level): boolean;
  highlight(cb: ()=>any): void;
}

class BasePowerup implements IPowerup {
  element: JQuery; 

  constructor(public id: string,
              public html: string,
              public holds:holdsT,
              public transform:transformT,
              public applies: appliesT,
              public tip: string) {
    this.element = $(html)
    this.element.attr("title", tip)
    this.element.tooltip({ position: {
      within: $(".container"), // TODO: Ugly hack refers to external element
      my: "center top+15",
      at: "center bottom",
      collision: "none none",
    }})
  }
  highlight(cb: ()=>any): void {
    this.element.effect("highlight", { color: "#008000" }, 500, cb);
  }
}

class MultiplierPowerup extends BasePowerup {
  constructor(public id: string,
              public html: string,
              public holds: holdsT,
              public mult: number,
              public applies: appliesT,
              public tip: string) {
    super(id + "x",
          "<div class='pwup box'>" + html + "<div class='pwup-mul'>" + mult + "X</div></div>",
          holds,
          (x)=>x*mult,
          applies,
          mult + "X if you " + tip)
  }

  highlight(cb: ()=>any): void {
    this.element.effect("highlight", { color: "#008000" }, 2000, ()=>0);
    let mulSpan = $("<span class='scoreText scoreFloat'>x" + this.mult + "</span>") 
    $(this.element).append(mulSpan);
    $(mulSpan).position({ "my": "right center", "at": "left-10 center", "of": this.element });
    mulSpan.hide({ effect: "puff", easing:"swing", duration:2000, complete: () => { mulSpan.remove(); cb(); }})
  }

  setMultiplier(newm: number): void {
    this.mult = newm;
    this.tip = newm + "X if you " + this.tip;
    this.transform = (x)=>x*newm;
    this.element.children("div").html(newm + "X");
  }
}

class VarOnlyPowerup extends MultiplierPowerup {
  constructor(multiplier : number = 2) {
    super("var only",
      "<span style='position: absolute; left:13px'>1</span>" +
      "<span style='position: absolute;color:red; left:10px'>&#10799;</span>",
      (inv: invariantT) => setlen(literals(inv)) == 0,
      multiplier,
      (lvl)=>true,
      multiplier + "X if you don't use constants")
  }
}

class UseXVarsPwup extends MultiplierPowerup {
  constructor(nvars: number, multiplier : number = 2) {
    super("NVars=" + nvars,
      nvars + "V",
      (inv: invariantT) => setlen(identifiers(inv)) == nvars,
      multiplier,
      (lvl)=> lvl.variables.length >= nvars && lvl.variables.length != 1,
      multiplier + "X if you use " + nvars +  " variable(s)")
  }
}

class UseOpsPwup extends MultiplierPowerup {
  constructor(ops: [ string ], html: string, name: string, multiplier : number = 2) {
    super("Use ops: " + ops,
      html,
      (inv: invariantT) => {
        let inv_ops = operators(inv);
        for (var i in ops) {
          if (ops[i] in inv_ops) return true
        }
        return false
      },
      multiplier,
      (lvl)=> true,
      multiplier + "X if you use " + name)
  }
}

interface IPowerupSuggestion {
  clear(lvl: Level): void;
  invariantTried(inv: invariantT): void;
  getPwups(): IPowerup[];
}

class PowerupSuggestionAll implements IPowerupSuggestion {
  all_pwups: IPowerup[];
  actual: IPowerup[] = [];
  age: { [ind: string] : number } = {};

  constructor(public threshold: number) {
    this.all_pwups = [
      new VarOnlyPowerup(2),
      new UseXVarsPwup(1,2),
      new UseXVarsPwup(2,2),
      new UseXVarsPwup(3,2),
      new UseXVarsPwup(4,2),
      new UseOpsPwup(["<=", ">=", "<", ">"], "<>", "inequality"),
      new UseOpsPwup(["=="], "=", "equality"),
      new UseOpsPwup(["*"], "*", "multiplication"),
      new UseOpsPwup(["+"], "+", "addition"),
    ]
  }

  clear(lvl: Level): void {
    this.actual = [ ]
    this.age = {}
    for (var i in this.all_pwups) {
      let p = this.all_pwups[i]
      this.actual.push(p);
      this.age[p.id] = this.threshold + 1;
    }
  }

  invariantTried(inv: invariantT): void {
    for (var i in this.actual) {
      if (!this.actual[i].holds(inv))
        this.age[this.actual[i].id] ++;
      else {
        this.age[this.actual[i].id] = 0;
      }
    }
  }

  getPwups(): IPowerup[] {
    return this.actual.filter(function (pwup) {
      return this.age[pwup.id] >= this.threshold
    })
  }
}

class PowerupSuggestionFullHistory implements IPowerupSuggestion {
  all_pwups: IPowerup[] = [];
  actual: IPowerup[] = [];
  age: { [ind: string]: number } = {};
  protected gen: number = 0;
  protected nUses: { [ind: string]: number } = { };
  protected lastUse: { [ind: string]: number } = { };
  protected sortFreq: [number, IPowerup][] = []; // TODO: Rename
  protected sortLast: [number, IPowerup][] = []; // TODO: Rename

  constructor(public nDisplay: number,
              public type: string) {
    this.all_pwups = [
      new VarOnlyPowerup(2),
      new UseOpsPwup(["<=", ">=", "<", ">", "!=="], "<>", "inequality"),
      new UseOpsPwup(["=="], "=", "equality"),
      new UseOpsPwup(["*", "/"], "*/", "multiplication or division"),
      new UseOpsPwup(["+", "-"], "&plusmn;", "addition or subtraction"),
    ]

    for (var i in this.all_pwups) {
      this.nUses[this.all_pwups[i].id] = 0;
      this.lastUse[this.all_pwups[i].id] = -1;
    }
  }

  protected computeOrders(): void {
    let sugg = this;
    if (this.gen > 0)
      this.sortFreq = this.actual.map(function (x, ind)  { return <[number, IPowerup]>[ sugg.nUses[x.id] / sugg.gen, x ]})
    else
      this.sortFreq = this.actual.map(function (x, ind)  { return <[number, IPowerup]>[ 0, x ] })

    this.sortLast = this.actual.map(function (x, ind)  { return <[number, IPowerup]>[ sugg.lastUse[x.id] , x ] })

    this.sortFreq.sort(function (a,b) { return a[0] - b[0] })
    this.sortLast.sort(function (a,b) { return a[0] - b[0] })
  }

  clear(lvl: Level) {
    this.actual = [];
    this.age = {};

    for (var i in this.all_pwups) {
      if (this.all_pwups[i].applies(lvl)) {
        this.actual.push(this.all_pwups[i])
      }
    }

    this.computeOrders();
  }

  invariantTried(inv: invariantT): void {
    for (var i in this.actual) {
      if (this.actual[i].holds(inv)) {
        this.nUses[this.actual[i].id] ++;
        this.lastUse[this.actual[i].id] = this.gen;
      }
    }
    this.gen ++
    this.computeOrders();
  }

  getPwups(): IPowerup[] {
    if (this.type == "lru") {
      return this.sortLast.slice(0, this.nDisplay).map(([fst,snd]:[number, IPowerup])=>snd);
    } else {
      assert(this.type == "lfu");
      return this.sortFreq.slice(0, this.nDisplay).map(([fst,snd]:[number, IPowerup])=>snd);
    }
  }
}

class PowerupSuggestionFullHistoryVariableMultipliers extends PowerupSuggestionFullHistory {
  invariantTried(inv: invariantT): void {
    super.invariantTried(inv);
    let age : { [ k: string ] : number } = { }

    for (let pwup of this.all_pwups) {
      let age : number = this.gen - this.lastUse[pwup.id];
      let newM : number = 2 * (Math.floor(age / 3) + 1)
      let mPwup : MultiplierPowerup = <MultiplierPowerup> pwup;
      mPwup.setMultiplier(newM);
    }
  }
}
