import { rpc_loadLvlBasic, rpc_checkSoundness } from "./rpc";
import { Fun, BB, Expr_T } from "./boogie";
import * as Phaser from "phaser-ce"
import { Node, AssumeNode, AssertNode, AssignNode, buildGraph, removeEmptyNodes, UserNode, PlaceholderNode, NodeMap } from "./game_graph"
import { InvGraphGame, TraceLayout, Trace, InvNetwork, InputOutputIcon, Violation } from "./invgraph_game"
import { getUid, assert, repeat, structEq, StrMap, Script, IStep } from "./util"
import { parse } from "esprima"
import { Point } from "phaser-ce";
import { TextIcon } from "./texticon";

class TutorialText extends TextIcon {
  constructor(game: InvGraphGame, text: (string | string[]), x?: number, y?: number) {
    super(game.game, game.getSprite("whitespace", 0, 0, true), text, "tuttext", x, y);
  }
}

class TutorialHighlight extends TextIcon {
  constructor(game: InvGraphGame, text: (string | string[]), x?: number, y?: number) {
    let arrow = game.getSprite("arrow_left", 0, 0, true);
    let animation = arrow.animations.add('animate');
    arrow.animations.play('animate', 60, true);
    super(game.game, arrow, text, "tuthigh", x, y);
  }
}

var global_tutorial_steps: IStep[];

class TutorialGame extends InvGraphGame {

  protected counter_example: any[][];
  protected currScript: Script;

  // < 0 means allow going forward, no tutorial stepping
  // 0 means disable going forward 
  // > 0 means that's the number of going forward required until next tutorial step 
  protected forwardCount: number;

  // Same meaning as forward
  protected backwardsCount: number;

  constructor(container: string, graph: Node, n: NodeMap, lvlId: string, steps: IStep[]) {
    super(container, graph, n, lvlId);
    this.forwardCount = 0;
    this.backwardsCount = 0;
  }

  unselect(): void {
    $("#inv").val("");
    $("#inv").prop("disabled", true);
    $("#overlay").prop("display", "none");
  }

  select(n: UserNode): void {
    $("#inv").val(n.exprs.join("&&"));
    $("#inv").prop("disabled", false);
    $("#overlay").prop("display", "none");
  }

  create(): void {
    super.create();
    this.forEachUserNode((nd: UserNode) => {
      this.textSprites[nd.id].onChanged.add((gameEl: TextIcon, newLines: string[]) => {
        assert(newLines.length >= nd.sound.length)
        let soundLines = newLines.slice(newLines.length - nd.sound.length);
        let unknownLines = newLines.slice(0, newLines.length - nd.sound.length);
        // newLines must have nd.unsound as its suffix (since those are immutable)
        assert(structEq(soundLines, nd.sound))

        unknownLines = unknownLines.filter((ln: string) => ln.trim().length != 0);

        for (let i = 0; i < unknownLines.length; i++) {
          try {
            parse(unknownLines[i]);
          } catch (err) {
            // Couldn't parse i-th line
            console.log("Error parsing: " + err);
            gameEl.edit(i);
            return;
          }
        }
        nd.sound = soundLines;
        nd.unsound = unknownLines;

        this.checkInvs(() => { });
      })
    })
  }

  forEachUserNode(cb: (nd: UserNode) => any): void {
    this.entry.forEachReachable((nd: Node) => {
      if (!(nd instanceof UserNode)) return;
      cb(nd);
    })
  }

  _controlsPlaying(): void {
    $("#step").prop("disabled", true);
    $("#back").prop("disabled", true);
    $("#play").prop("disabled", true);
    $("#stop").prop("disabled", false);
  }

  _controlsStopped(): void {
    $("#step").prop("disabled", false);
    $("#back").prop("disabled", false);
    $("#play").prop("disabled", false);
    $("#stop").prop("disabled", true);
  }

  _controlsDisable(): void {
    $("#step").prop("disabled", true);
    $("#back").prop("disabled", true);
    $("#play").prop("disabled", true);
    $("#stop").prop("disabled", true);
  }

  hideViolation(): void {
    super.hideViolation();
    this._controlsDisable();
  }

  showViolation(traceLayout: TraceLayout, trace: Trace): void {
    super.showViolation(traceLayout, trace);
    this._controlsStopped();
  }

  playBug(onComplete?: () => any) {
    super.playBug(() => {
      this._controlsStopped();
      if (onComplete !== undefined) {
        onComplete();
      }
    });
  }

  checkInvs: any = (onDone: () => void) => {
    let res = this.counter_example;
    this.transformLayout(() => {
      let soundnessViolations: StrMap<Violation[]> = {};
      for (let v of res) {
        let t: Trace = this.getTrace(v);
        let end: UserNode = (t[t.length - 1][0] instanceof UserNode ? t[t.length - 1][0] as UserNode : null);
        if (end == null) continue;
        if (!(end.id in soundnessViolations)) {
          soundnessViolations[end.id] = [];
        }
        soundnessViolations[end.id].push(v);
      }

      this.forEachUserNode((un: UserNode) => {
        if (!(un.id in soundnessViolations) ||
          soundnessViolations[un.id].length == 0) {
          un.sound = un.unsound.concat(un.sound);
          un.unsound = [];
        }
        let spriteNode = this.nodeSprites[un.id] as InputOutputIcon;
        spriteNode.setInvariants(un.sound, un.unsound);
      })
    }, () => {
      this.setViolations(res, onDone);
    });
  }

  onFirstUpdate(): void {
    super.onFirstUpdate();
    this.currScript = new Script(global_tutorial_steps);
    // let v = [];
    // v[0] = ["anon0"];
    // // v[1] = [[{n:1}, {n:1}, {n:2}, {n:2}]];
    // v[1] = [[{n:1}, {n:1}, {n:1}]];
    // let res = [v];
    // this.counter_example = res;
    // this.checkInvs(this.getInvNetwork(), ()=>{});
  }

  addHighlight(elmt: Node | TextIcon, str: (string | string[])) {
    let sprite = elmt instanceof TextIcon ? elmt : this.textSprites[elmt.id];
    return new TutorialHighlight(this, str, sprite.getX() + sprite.getWidth(), sprite.getY());
  }

  addText(elmt: Node | TextIcon, str: (string | string[])) {
    let sprite = elmt instanceof TextIcon ? elmt : this.textSprites[elmt.id];
    return new TutorialText(this, str, sprite.getX() + sprite.getWidth(), sprite.getY());
  }

  setCounterExample(ce: any[][]): void {
    this.counter_example = ce;
  }

  getOrb(): TextIcon {
    return this.selectedViolation[0];
  }

  stepForward(): void {
    if (this.forwardCount == 0) return;
    if (this.forwardCount > 0) {
      super.stepForward();
      this.forwardCount--;
      if (this.forwardCount == 0) {
        this.currScript.nextStep();
      }
    }
    if (this.forwardCount < 0) {
      super.stepForward();
    }
  }

  stepBackwards(): void {
    if (this.backwardsCount == 0) return;
    if (this.backwardsCount > 0) {
      super.stepBackwards();
      this.backwardsCount--;
      if (this.backwardsCount == 0) {
        this.currScript.nextStep();
      }
    }
    if (this.backwardsCount < 0) {
      super.stepBackwards();
    }
  }

  nextStepOnForwardN(n:number): void {
    this.forwardCount = n;
  }

  nextStepOnBackwardsN(n:number): void {
    this.backwardsCount = n;
  }

  updateGraph(container: string, graph: Node, n: NodeMap, lvlId: string): void {
    this.width = 800;
    this.height = 600;
    // this.game = new Phaser.Game(this.width, this.height, Phaser.AUTO, container,
    //   { preload: ()=>{this.preload()},
    //     create: ()=>{this.create()},
    //     update: ()=>{this.update()}
    //   });
    this.hideViolation();
    this.entry = graph;
    this.userNodes = []
    this.bbToNode = n;
    this.edges = {};
    this.edgeStates = {};
    this.nodeSprites = {};
    this.textSprites = {};
    this.spritePool = {};
    this.curViolations = [];
    this.animationStopRequested = false;
    this.lvlId = lvlId;
    this.selectedViolation = null;
    this.create();
  }
}

$(document).ready(function () {
  // assume/stmt/placeholder
  let entry: Node;
  let placeholder: Node;
  let assign: Node;
  entry = new AssumeNode(getUid("nd"), "n>0");
  placeholder = new PlaceholderNode(getUid("placeholder"));
  entry.addSuccessor(placeholder);
  let bbMap = { "anon0": [entry, placeholder] };

  // assume/stmt/placeholder
  // let entry: Node = new AssumeNode(getUid("nd"), "n>0");
  // let assign: Node = new AssignNode(getUid("nd"), ["n := n+1"]);
  // let assert: Node = new PlaceholderNode(getUid("placeholder"));
  // entry.addSuccessor(assign);
  // assign.addSuccessor(assert);
  // let bbMap = {"anon0": [entry, assign, assert]};

  // assume/stmt/assert
  // let entry: Node = new AssumeNode(getUid("nd"), "n>0");
  // let assign: Node = new AssignNode(getUid("nd"), ["n := n+1"]);
  // let assert: Node = new AssertNode(getUid("nd"), "n > 10");
  // entry.addSuccessor(assign);
  // assign.addSuccessor(assert);
  // let bbMap = {"anon0": [entry, assign, assert]};

  let text = null;
  let tutorial_steps_2 = null;
  let tutorial_steps_1 = [{
    setup: function (cs) {
      text = game.addHighlight(entry, "This is a gate that drops orbs. [press space]");
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(entry,
        ["'n>0' says that orbs leaving this gate carry",
          "a value called 'n' that is > 0 [press space]"]);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function (cs) {
      text.destroy();

      let v = [];
      v[0] = ["anon0"];
      // v[1] = [[{n:1}, {n:1}, {n:2}, {n:2}]];
      v[1] = [[{ n: 1 }, { n: 1 }, { n: 1 }]];
      let res = [v];
      game.setCounterExample(res);
      game.checkInvs(() => {
        text = game.addHighlight(game.getOrb(),
          ["For example, here is an orb that",
            "carries the value n = 1. [press space]"]);
        cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      });
      // text = game.game.add.text(0, 0, "hello world", { font: "15px Courier New, Courier, monospace", align: "center", fill: "#000000", backgroundColor: "#ffffff" });
      // text = new TutorialText(game,"hello world",game.textSprites[entry.id].getX()+20,game.textSprites[entry.id].getY()+20);
      // text = game.addHighlight(entry, "hello world");
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(game.getOrb(),
        ["The orb can move, press the down arrow"]);
      game.nextStepOnForwardN(1);
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(game.getOrb(),
          ["Great! Now press the up arrow"]);
      },1200);
      game.nextStepOnBackwardsN(1);
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(game.getOrb(),
          ["Now you know how to move orbs! [press space]"]);
          cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      },1200);
    }
  }, {
    setup: function (cs) {
      text.destroy();

      let v = [];
      v[0] = ["anon0"];
      // v[1] = [[{n:1}, {n:1}, {n:2}, {n:2}]];
      v[1] = [[{ n: 2 }, { n: 2 }, { n: 2 }]];
      let res = [v];
      game.setCounterExample(res);
      game.checkInvs(() => {
        text = game.addHighlight(game.getOrb(),
          ["Here is another orb, with value n = 2",
            "This value of n is also > 0. [press space]"]);
        cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      });
    }
  }, {
    setup: function(cs) {
      text.destroy();
      text = game.addHighlight(game.getOrb(),
        ["Move the orb down once, and up once"]);
      game.nextStepOnForwardN(1);
    }
  }, {
    setup: function(cs) {
      game.nextStepOnBackwardsN(1);
    }
  }, {
    setup: function(cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addText(game.getOrb(),
          ["Good job, let's try another example!", "[press space]"]);
        cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      },1200);
    },
  }, {
    setup: function(cs) {
      text.destroy();
      entry = new AssumeNode(getUid("nd"), "n>0");
      assign = new AssignNode(getUid("nd"), ["n := n+1"]);
      placeholder = new PlaceholderNode(getUid("placeholder"));
      entry.addSuccessor(assign);
      assign.addSuccessor(placeholder);
      let bbMap = {"anon0": [entry, assign, placeholder]};

      game.updateGraph("content", entry, bbMap, "bogus");
      global_tutorial_steps = tutorial_steps_2;
    },
  }];
  tutorial_steps_2 = [{
    setup: function (cs) {
      text = game.addHighlight(assign, "This box is a value transformer. [press space]");
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function(cs) {
      text.destroy();
      let v = [];
      v[0] = ["anon0"];
      v[1] = [[{n:1}, {n:1}, {n:2}, {n:2}]];
      let res = [v];
      game.setCounterExample(res);
      game.checkInvs(() => {
        text = game.addHighlight(game.getOrb(),
          ["For example, here is an orb that",
            "carries the value n = 1. [press space]"]);
        cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      });
    }
  }];
  global_tutorial_steps = tutorial_steps_1;
  let game = new TutorialGame("content", entry, bbMap, "bogus", tutorial_steps_1);

})
