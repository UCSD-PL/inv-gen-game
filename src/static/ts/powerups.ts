type holdsT = (inv: invariantT) => boolean
type transformT = (score: number) => number
type appliesT = (lvl: Level) => boolean

interface IPowerup {
  id: string;
  html: string;
  element: JQuery;
  holds(inv: invariantT): boolean;
  transform(score: number): number;
  applies(lvl: Level): boolean;
  highlight(cb: () => any): void;
}

class BasePowerup implements IPowerup {
  element: JQuery;

  constructor(public id: string,
              public html: string,
              public holds: holdsT,
              public transform: transformT,
              public applies: appliesT,
              public tip: string) {
    this.element = $(html);
    this.element.attr("title", tip);
    this.element.tooltip({ position: {
      within: $(".container"), // TODO: Ugly hack refers to external element
      my: "center top+15",
      at: "center bottom",
      collision: "none none",
    }});
  }
  highlight(cb: () => any): void {
    this.element.effect("highlight", { color: "#008000" }, 500, cb);
  }
}

class MultiplierPowerup extends BasePowerup {
  constructor(id: string,
              html: string,
              holds: holdsT,
              mult: number,
              applies: appliesT,
              tip: string) {
    super(id + "x" + mult,
          "<div class='pwup box'>" + html + "<div class='pwup-mul'>" + mult + "X</div></div>",
          holds,
          (x) => x * mult,
          applies,
          tip);
  }
}

class VarOnlyPowerup extends MultiplierPowerup {
  constructor(multiplier: number = 2) {
    super("var only",
      "<span style='position: absolute; left:13px'>1</span>" +
      "<span style='position: absolute;color:red; left:10px'>&#10799;</span>",
      (inv: invariantT) => setlen(literals(inv)) === 0,
      multiplier,
      (lvl) => true,
      multiplier + "X if you don't use constants");
  }
}

class UseXVarsPwup extends MultiplierPowerup {
  constructor(nvars: number, multiplier: number = 2) {
    super("NVars=" + nvars,
      nvars + "V",
      (inv: invariantT) => setlen(identifiers(inv)) === nvars,
      multiplier,
      (lvl) => lvl.variables.length >= nvars && lvl.variables.length !== 1,
      multiplier + "X if you use " + nvars +  " variable(s)");
  }
}

class UseOpsPwup extends MultiplierPowerup {
  constructor(ops: [ string ], html: string, name: string, multiplier: number = 2) {
    super("Use ops: " + ops,
      html,
      (inv: invariantT) => {
        let inv_ops = operators(inv);
        for (let i in ops) {
          if (ops[i] in inv_ops) return true;
        }
        return false;
      },
      multiplier,
      (lvl) => true,
      multiplier + "X if you use " + name);
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
  age: { [ind: string]: number } = {};

  constructor(public threshold: number) {
    this.all_pwups = [
      new VarOnlyPowerup(2),
      new UseXVarsPwup(1, 2),
      new UseXVarsPwup(2, 2),
      new UseXVarsPwup(3, 2),
      new UseXVarsPwup(4, 2),
      new UseOpsPwup(["<=", ">=", "<", ">"], "<>", "inequality"),
      new UseOpsPwup(["=="], "=", "equality"),
      new UseOpsPwup(["*"], "*", "multiplication"),
      new UseOpsPwup(["+"], "+", "addition"),
    ];
  }

  clear(lvl: Level): void {
    this.actual = [ ];
    this.age = {};
    for (let i in this.all_pwups) {
      let p = this.all_pwups[i];
      this.actual.push(p);
      this.age[p.id] = this.threshold + 1;
    }
  }

  invariantTried(inv: invariantT): void {
    for (let i in this.actual) {
      if (!this.actual[i].holds(inv))
        this.age[this.actual[i].id] ++;
      else {
        this.age[this.actual[i].id] = 0;
      }
    }
  }

  getPwups(): IPowerup[] {
    return this.actual.filter(function (pwup) {
      return this.age[pwup.id] >= this.threshold;
    });
  }
}

class PowerupSuggestionFullHistory implements IPowerupSuggestion {
  all_pwups: IPowerup[] = [];
  actual: IPowerup[] = [];
  age: { [ind: string]: number } = {};
  private gen: number = 0;
  private nUses: { [ind: string]: number } = { };
  private lastUse: { [ind: string]: number } = { };
  private sortFreq: [number, IPowerup][] = []; // TODO: Rename
  private sortLast: [number, IPowerup][] = []; // TODO: Rename

  constructor(public nDisplay: number,
              public type: string) {
    this.all_pwups = [
      new VarOnlyPowerup(2),
      new UseXVarsPwup(1, 2),
      new UseXVarsPwup(2, 2),
      new UseXVarsPwup(3, 2),
      new UseXVarsPwup(4, 2),
      new UseOpsPwup(["<=", ">=", "<", ">"], "<>", "inequality"),
      new UseOpsPwup(["=="], "=", "equality"),
      new UseOpsPwup(["*"], "*", "multiplication"),
      new UseOpsPwup(["+"], "+", "addition"),
    ];

    for (let i in this.all_pwups) {
      this.nUses[this.all_pwups[i].id] = 0;
      this.lastUse[this.all_pwups[i].id] = -1;
    }
  }

  private computeOrders(): void {
    let sugg = this;
    if (this.gen > 0)
      this.sortFreq = this.actual.map(function (x, ind)  { return <[number, IPowerup]>[ sugg.nUses[x.id] / sugg.gen, x ]; });
    else
      this.sortFreq = this.actual.map(function (x, ind)  { return <[number, IPowerup]>[ 0, x ]; });

    this.sortLast = this.actual.map(function (x, ind)  { return <[number, IPowerup]>[ sugg.lastUse[x.id] , x ]; });

    this.sortFreq.sort(function (a, b) { return a[0] - b[0]; });
    this.sortLast.sort(function (a, b) { return a[0] - b[0]; });
  }

  clear(lvl: Level) {
    this.actual = [];
    this.age = {};

    for (let i in this.all_pwups) {
      if (this.all_pwups[i].applies(lvl)) {
        this.actual.push(this.all_pwups[i]);
      }
    }

    this.computeOrders();
  }

  invariantTried(inv: invariantT): void {
    for (let i in this.actual) {
      if (this.actual[i].holds(inv)) {
        this.nUses[this.actual[i].id] ++;
        this.lastUse[this.actual[i].id] = this.gen;
      }
    }
    this.gen ++;
    this.computeOrders();
  }

  getPwups(): IPowerup[] {
    if (this.type === "lru") {
      return this.sortLast.slice(0, this.nDisplay).map(([fst, snd]: [number, IPowerup]) => snd);
    } else {
      assert(this.type === "lfu");
      return this.sortFreq.slice(0, this.nDisplay).map(([fst, snd]: [number, IPowerup]) => snd);
    }
  }
}

class TwoPlayerBasePowerup implements IPowerup {
  element: JQuery;
  player: number;

  constructor(public playerNum: number,
              public id: string,
              public html: string,
              public holds: holdsT,
              public transform: transformT,
              public applies: appliesT,
              public tip: string) {
    this.player = playerNum;
    this.element = $(html);
    this.element.attr("title", tip);
    this.element.tooltip({ position: {
      within: $(".container"), // TODO: Ugly hack refers to external element
      my: "center top+15",
      at: "center bottom",
      collision: "none none",
    }});
  }

  highlight(cb: () => any): void {
    if (this.player === 1) {
      this.element.effect("highlight", { color: "#f00000" }, 500, cb);
    }
    else if (this.player === 2) {
      this.element.effect("highlight", { color: "#0000f0" }, 500, cb);
    }
  }
}

class TwoPlayerMultiplierPowerup extends TwoPlayerBasePowerup {
  constructor(playerNum: number,
              id: string,
              html: string,
              holds: holdsT,
              mult: number,
              applies: appliesT,
              tip: string) {
    super(playerNum, id + "x" + mult,
          (playerNum === 1) ?
            ("<div class='pwup1 box'>" + html + "<div class='pwup-mul'>" +
            mult + "X</div></div>")
            :
            ("<div class='pwup2 box'>" + html + "<div class='pwup-mul'>" +
            mult + "X</div></div>"),
          holds,
          (x) => x * mult,
          applies,
          tip);
  }
}

class TwoPlayerVarOnlyPowerup extends TwoPlayerMultiplierPowerup {
  constructor(playerNum: number, multiplier: number = 2) {
    super(playerNum, "var only",
      "<span style='position: absolute; left:13px'>1</span>" +
      "<span style='position: absolute;color:red; left:10px'>&#10799;</span>",
      (inv: invariantT) => setlen(literals(inv)) === 0,
      multiplier,
      (lvl) => true,
      multiplier + "X if you don't use constants");
  }
}

class TwoPlayerUseXVarsPwup extends TwoPlayerMultiplierPowerup {
  constructor(playerNum: number, nvars: number, multiplier: number = 2) {
    super(playerNum,
      "NVars=" + nvars,
      nvars + "V",
      (inv: invariantT) => setlen(identifiers(inv)) === nvars,
      multiplier,
      (lvl) => lvl.variables.length >= nvars && lvl.variables.length !== 1,
      multiplier + "X if you use " + nvars +  " variable(s)");
  }
}

class TwoPlayerUseOpsPwup extends TwoPlayerMultiplierPowerup {
  constructor(playerNum: number,
              ops: [ string ],
              html: string,
              name: string,
              multiplier: number = 2) {
    super(playerNum,
      "Use ops: " + ops,
      html,
      (inv: invariantT) => {
        let inv_ops = operators(inv);
        for (let i in ops) {
          if (ops[i] in inv_ops) return true;
        }
        return false;
      },
      multiplier,
      (lvl) => true,
      multiplier + "X if you use " + name);
  }
}

class TwoPlayerPowerupSuggestionAll implements IPowerupSuggestion {
  all_pwups: IPowerup[];
  actual: IPowerup[] = [];
  age: { [ind: string]: number } = {};

  constructor(public playerNum: number, public threshold: number) {
    this.all_pwups = [
      new TwoPlayerVarOnlyPowerup(playerNum, 2),
      new TwoPlayerUseXVarsPwup(playerNum, 1, 2),
      new TwoPlayerUseXVarsPwup(playerNum, 2, 2),
      new TwoPlayerUseXVarsPwup(playerNum, 3, 2),
      new TwoPlayerUseXVarsPwup(playerNum, 4, 2),
      new TwoPlayerUseOpsPwup(playerNum, ["<=", ">=", "<", ">"], "<>", "inequality"),
      new TwoPlayerUseOpsPwup(playerNum, ["=="], "=", "equality"),
      new TwoPlayerUseOpsPwup(playerNum, ["*"], "*", "multiplication"),
      new TwoPlayerUseOpsPwup(playerNum, ["+"], "+", "addition"),
    ];
  }

  clear(lvl: Level): void {
    this.actual = [ ];
    this.age = {};
    for (let i in this.all_pwups) {
      let p = this.all_pwups[i];
      this.actual.push(p);
      this.age[p.id] = this.threshold + 1;
    }
  }

  invariantTried(inv: invariantT): void {
    for (let i in this.actual) {
      if (!this.actual[i].holds(inv))
        this.age[this.actual[i].id] ++;
      else {
        this.age[this.actual[i].id] = 0;
      }
    }
  }

  getPwups(): IPowerup[] {
    return this.actual.filter(function (pwup) {
      return this.age[pwup.id] >= this.threshold;
    });
  }
}

class TwoPlayerPowerupSuggestionFullHistory implements IPowerupSuggestion {
  all_pwups: IPowerup[] = [];
  actual: IPowerup[] = [];
  age: { [ind: string]: number } = {};
  player: number;
  private gen: number = 0;
  private nUses: { [ind: string]: number } = { };
  private lastUse: { [ind: string]: number } = { };
  private sortFreq: [number, IPowerup][] = []; // TODO: Rename
  private sortLast: [number, IPowerup][] = []; // TODO: Rename

  constructor(public playerNum: number,
              public nDisplay: number,
              public type: string) {
    this.all_pwups = [
      new TwoPlayerVarOnlyPowerup(playerNum, 2),
      new TwoPlayerUseXVarsPwup(playerNum, 1, 2),
      new TwoPlayerUseXVarsPwup(playerNum, 2, 2),
      new TwoPlayerUseXVarsPwup(playerNum, 3, 2),
      new TwoPlayerUseXVarsPwup(playerNum, 4, 2),
      new TwoPlayerUseOpsPwup(playerNum, ["<=", ">=", "<", ">"], "<>", "inequality"),
      new TwoPlayerUseOpsPwup(playerNum, ["=="], "=", "equality"),
      new TwoPlayerUseOpsPwup(playerNum, ["*"], "*", "multiplication"),
      new TwoPlayerUseOpsPwup(playerNum, ["+"], "+", "addition"),
    ];

    for (let i in this.all_pwups) {
      this.nUses[this.all_pwups[i].id] = 0;
      this.lastUse[this.all_pwups[i].id] = -1;
    }
  }

  private computeOrders(): void {
    let sugg = this;
    if (this.gen > 0)
      this.sortFreq = this.actual.map(function (x, ind)  { return <[number, IPowerup]>[ sugg.nUses[x.id] / sugg.gen, x ]; });
    else
      this.sortFreq = this.actual.map(function (x, ind)  { return <[number, IPowerup]>[ 0, x ]; });

    this.sortLast = this.actual.map(function (x, ind)  { return <[number, IPowerup]>[ sugg.lastUse[x.id] , x ]; });

    this.sortFreq.sort(function (a, b) { return a[0] - b[0]; });
    this.sortLast.sort(function (a, b) { return a[0] - b[0]; });
  }

  clear(lvl: Level) {
    this.actual = [];
    this.age = {};

    for (let i in this.all_pwups) {
      if (this.all_pwups[i].applies(lvl)) {
        this.actual.push(this.all_pwups[i]);
      }
    }

    this.computeOrders();
  }

  invariantTried(inv: invariantT): void {
    for (let i in this.actual) {
      if (this.actual[i].holds(inv)) {
        this.nUses[this.actual[i].id] ++;
        this.lastUse[this.actual[i].id] = this.gen;
      }
    }
    this.gen ++;
    this.computeOrders();
  }

  getPwups(): IPowerup[] {
    if (this.type === "lru") {
      return this.sortLast.slice(0, this.nDisplay).map(([fst, snd]: [number, IPowerup]) => snd);
    } else {
      assert(this.type === "lfu");
      return this.sortFreq.slice(0, this.nDisplay).map(([fst, snd]: [number, IPowerup]) => snd);
    }
  }
}
