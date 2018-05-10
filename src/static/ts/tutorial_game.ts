import { rpc_loadLvlBasic, rpc_checkSoundness } from "./rpc";
import { Fun, BB, Expr_T } from "./boogie";
import * as Phaser from "phaser-ce"
import { Node, AssumeNode, AssertNode, AssignNode, buildGraph, removeEmptyNodes, UserNode, PlaceholderNode, NodeMap, IfNode } from "./game_graph"
import { InvGraphGame, TraceLayout, Trace, InvNetwork, InputOutputIcon, Violation, SinkIcon } from "./invgraph_game"
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

  initUserNodes():void {
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
  create(): void {
    super.create();
    // this.initUserNodes();
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

  addHighlight(elmt: Node | TextIcon, str: (string | string[]), deltax = 0, deltay = 0) {
    let sprite = elmt instanceof TextIcon ? elmt : this.textSprites[elmt.id];
    return new TutorialHighlight(this, str,
      sprite.getX() + sprite.getWidth() + deltax,
      sprite.getY() + deltay);
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
    console.log("stepForward: ", this.forwardCount);
    if (this.forwardCount == 0) return;
    if (this.forwardCount > 0) {
      super.stepForward();
      this.forwardCount--;
      if (this.forwardCount == 0) {
        console.log("stepForward: going to next step");
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
    console.log("nextStepOnForwardN: ", this.forwardCount);
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
    if (this.selectedViolation != null) {
      this.hideViolation();
    }
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
    this.create_core();
    // this.initUserNodes();
  }

  onNodeClick(n: Node): Phaser.Signal {
    return this.textSprites[n.id].icon().events.onInputDown;
  }

  // onNodeClickOnce(n: Node, onClick: ()=>any): void {
  //   this.textSprites[n.id].icon().events.onInputDown.addOnce(() => {
  //     onClick();
  //   });
  // }
  onNodeChanged(n: Node): Phaser.Signal {
    return this.textSprites[n.id].onChanged;
  }

  getTextIcon(n: Node): TextIcon {
    return this.textSprites[n.id];
  }
}

$(document).ready(function () {
  // assume/stmt/placeholder
  let entry: Node;
  let placeholder: Node;
  let assign: Node;
  let assert: Node;
  let usernode: UserNode;
  let branch: Node;
  let loopbody: Node;

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
  let tutorial_steps_1 = null;
  let tutorial_steps_2 = null;
  let tutorial_steps_3 = null;
  let tutorial_steps_4 = null;

  tutorial_steps_1 = [{
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
      v[1] = [[{ n: 1 }, { n: 1 }, { n: 1 }]];
      let res = [v];
      game.setCounterExample(res);
      game.checkInvs(() => {
        text = game.addHighlight(game.getOrb(),
          ["For example, here is an orb that",
            "carries the value n = 1. [press space]"]);
        cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      });
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

      global_tutorial_steps = tutorial_steps_2;
      game.updateGraph("content", entry, bbMap, "bogus");
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
          ["Let's see what happens to this orb, which",
            "carries the value n = 1. [press down]"]);
        game.nextStepOnForwardN(1);
      });
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(game.getOrb(),
          ["Press down again, and look at the value of n"]);
        game.nextStepOnForwardN(1);
      },1200);
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(game.getOrb(),
          ["The value of n went up by one!", 
          "The gear box adds one! [press space]"]);
      },1200);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(game.getOrb(), ["Now move the orb back up"]);
      game.nextStepOnBackwardsN(1);
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(game.getOrb(),
          ["The value of n went back to 1!",
          "Now move the orb back one"]);
        game.nextStepOnBackwardsN(1);
      },1200);
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(assign,
          ["Great work!",
          "Let's click on the gear box to see what's inside"]);
        game.onNodeClick(assign).addOnce(() => { cs.nextStep() });
      },1200);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      setTimeout(function() {
        text = game.addHighlight(assign,
          ["You can now see inside: The gear box",
          "increments n by one [press space]"]);
        cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      },1200);
    }
  }, {
    setup: function(cs) {
      text.destroy();
      text = game.addText(game.getOrb(),
        ["Good job, let's go to the next example!", "[press space]"]);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    },
  }, {
    setup: function(cs) {
      text.destroy();
      entry = new AssumeNode(getUid("nd"), "n>0");
      assign = new AssignNode(getUid("nd"), ["n := n+1"]);
      assert = new AssertNode(getUid("nd"), "n > 10");
      entry.addSuccessor(assign);
      assign.addSuccessor(assert);
      let bbMap = {"anon0": [entry, assign, assert]};

      game.updateGraph("content", entry, bbMap, "bogus");
      global_tutorial_steps = tutorial_steps_3;
    }
  }];
  tutorial_steps_3 = [{
    setup: function (cs) {
      text = game.addHighlight(assert,
        ["This a gate that absorbs orbs.",
        "[press space]"]);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }    
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(assert,
        ["'n>10' says that the gate can only absorb",
          "orbs carrying 'n' > 10 [press space]"]);
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
          ["Let's see what happens to this orb, which",
            "carries the value n = 1. [press down twice]"]);
        game.nextStepOnForwardN(2);
      });
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(game.getOrb(),
          ["Notice how the value of n is now 2",
          "[press down again]"]);
          game.nextStepOnForwardN(1);
      },1200);
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(assert,
          ["The value n = 2 makes n > 10 false, so the",
          "orb cannot be absorbed [press space]"]);
          cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      },1200);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(entry,
        ["We show that this orb cannot be absorbed",
        "on this path by coloring the path red [press space]"],
        -50, 40);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(assert, ["Let's make the path green! [press space]"]);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      (game.getTextIcon(assert) as SinkIcon).makeEditable();
      text = game.addHighlight(assert, ["Click on the funnel next to the expression"]);
      game.onNodeClick(assert).addOnce(() => { cs.nextStep() });
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(assert, ["Change text to 'n>1'","and press enter"]);
      game.onNodeChanged(assert).addOnce((gameEl: TextIcon, newLines: string[]) =>  {
        if (newLines[0].replace(/\s+/gm,'') === "n>1") {
          cs.nextStep();
        } else {
          cs.nextStep(-2);
        }
      });
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(game.getOrb(),
        ["Yay! This orb with n = 2 passes through the",
        "gate. But not so quick... [press space]"]);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      let v = [];
      v[0] = ["anon0"];
      v[1] = [[{n:0}, {n:0}, {n:1}, {n:1}]];
      let res = [v];
      game.setCounterExample(res);
      game.checkInvs(() => {
        text = game.addHighlight(game.getOrb(),
          ["The path is still red!!!",
          "We are now given a new orb to look at",
          "carrying the value n = 0. [press down twice]"]);
        game.nextStepOnForwardN(2);
      });
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(game.getOrb(),
          ["Here the value of n becomes 1",
          "[press down again]"]);
          game.nextStepOnForwardN(1);
      },1200);
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(assert,
          ["n = 1 makes n > 1 false, so again the",
          "orb cannot be absorbed [press space]"]);
          cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      },1200);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(assert, ["Let's try something different! [press space]"]);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      (game.getTextIcon(assert) as SinkIcon).makeEditable();
      text = game.addHighlight(assert, ["Click on the funnel next to the expression"]);
      game.onNodeClick(assert).addOnce(() => { cs.nextStep() });
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(assert, ["Change text to 'n>0'","and press enter"]);
      game.onNodeChanged(assert).addOnce((gameEl: TextIcon, newLines: string[]) =>  {
        if (newLines[0].replace(/\s+/gm,'') === "n>0") {
          cs.nextStep();
        } else {
          cs.nextStep(-2);
        }
      });
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(game.getOrb(),
        ["Yay! This orb with n = 1 now passes",
        "through the gate. [press space]"]);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      game.setCounterExample([]);
      game.checkInvs(() => {
        text = game.addHighlight(entry,
          ["And the path is green!"],
          -50, 40);
        cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      });
    }
  }, {
    setup: function(cs) {
      let user
      text.destroy();
      entry = new AssumeNode(getUid("nd"), "true");
      assign = new AssignNode(getUid("nd"), ["n := 0"]);
      usernode = new UserNode(getUid("nd"), [], [], "anon3_LoopHead");
      loopbody = new AssignNode(getUid("nd"), ["n := n + 1"]);
      branch = new IfNode(getUid("nd"), "n < 10");
      assert = new AssertNode(getUid("nd"), "n == 10");
      entry.addSuccessor(assign);
      assign.addSuccessor(usernode);
      (usernode as Node).addSuccessor(branch);
      branch.addSuccessor(loopbody);
      branch.addSuccessor(assert);
      loopbody.addSuccessor(usernode);

      let bbMap = {
        "anon0": [entry, assign],
        "anon3_LoopBody": [branch, loopbody],
        "anon3_LoopDone": [branch],
        "anon3_LoopHead": [usernode],
        "_assert_0": [assert]
      };
      game.updateGraph("content", entry, bbMap, "bogus");
      global_tutorial_steps = tutorial_steps_4;
    }
  }];

  tutorial_steps_4 = [{
    setup: function (cs) {
      text = game.addHighlight(usernode,
        ["This a gate that both absorbs and",
        "generates orbs. [press space]"]);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }    
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(branch,
        ["This gate asks: is n < 10?",
        "If YES orb goes to 'Y'", 
        "If NO orb goes to 'N' [press space]"]);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(assign,
        ["Let's click on this gear box"]);
      game.onNodeClick(assign).addOnce(() => { cs.nextStep() });
    }
  }, {
    setup: function (cs) {
      text.destroy();
      setTimeout(function() {
        text = game.addHighlight(assign,
          ["It sets n to zero [press space]"]);
        cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      },600);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(loopbody,
        ["Let's click on this gear box"]);
      game.onNodeClick(loopbody).addOnce(() => { cs.nextStep() });
    }
  }, {
    setup: function (cs) {
      text.destroy();
      setTimeout(function() {
        text = game.addHighlight(loopbody,
          ["It increments n by one [press space]"]);
        cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      },600);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(usernode, ["Click on the gate"]);
      game.onNodeClick(usernode).addOnce(() => { cs.nextStep() });
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(usernode, ["Change text to 'n==0'","and press enter"]);
      game.onNodeChanged(usernode).addOnce((gameEl: TextIcon, newLines: string[]) =>  {
        if (newLines[0].replace(/\s+/gm,'') === "n==0") {
          cs.nextStep();
        } else {
          cs.nextStep(-2);
        }
      });
    }
  }, {
    setup: function(cs) {
      text.destroy();
      usernode.unsound = ["n == 0"];
      let v = [];
      v[0] = ["anon3_LoopHead", "anon3_LoopBody", "anon3_LoopHead"];
      v[1] = [[{n:0}],[{n:0},{n:0},{n:1}],[]];
      // v[2] = [];
      let res = [v];
      game.setCounterExample(res);
      game.checkInvs(() => {
        text = game.addHighlight(game.getOrb(),
          ["You are given an orb with value n = 0",
          "[press down]"]);
        game.nextStepOnForwardN(1);
      });
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(game.getOrb(),
          ["Is n<10? YES so go left",
          "[press down three times]"]);
          game.nextStepOnForwardN(3);
      },1200);
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(game.getOrb(),
          ["n goes up to 1",
          "[press down twice]"]);
          game.nextStepOnForwardN(2);
      },1200);
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(usernode,
          ["n == 0 cannot absorb the orb n = 1",
          "[press space]"]);
        cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      },2700);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(usernode,
        ["To summarize:",
        "  n == 0 produces the value 0",
        "  0 goes around the loop to become 1",
        "  1 cannot be absorbed by n == 0",
        "Let's fix it! [press space]"]);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(usernode, ["Click on the gate"]);
      game.onNodeClick(usernode).addOnce(() => { cs.nextStep() });
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(usernode, ["Change text to 'n>=0'","and press enter"]);
      game.onNodeChanged(usernode).addOnce((gameEl: TextIcon, newLines: string[]) =>  {
        if (newLines[0].replace(/\s+/gm,'') === "n>=0") {
          cs.nextStep();
        } else {
          cs.nextStep(-2);
        }
      });
    }
  }, {
    setup: function(cs) {
      text.destroy();
      usernode.unsound = [];
      usernode.sound = ["n >= 0"];
      game.setCounterExample([]);
      game.checkInvs(() => {
        text = game.addHighlight(usernode,
          ["The loop and 'n>=0' are both green!",
          "Why? Well, if n>=0 and",
          "n increases by 1 around the loop,",
          "then n>=0 will still be true",
          "[press space]"]);
          cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      });
    }
  }, {
    setup: function(cs) {
      text.destroy();
      let v = [];
      v[0] = ["anon3_LoopHead", "anon3_LoopDone", "_assert_0"];
      v[1] = [[{n:11}],[{n:11},{n:11}],[{n:11},{n:11}]];
      // v[2] = [];
      let res = [v];
      game.setCounterExample(res);
      game.checkInvs(() => {
        text = game.addHighlight(game.getOrb(),
          ["But... now an orb with value n = 11",
          "[press down]"]);
        game.nextStepOnForwardN(1);
      });
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(game.getOrb(),
          ["With n being 11, is n<10?",
          "NO so go right",
          "[press down twice]"]);
          game.nextStepOnForwardN(2);
      },1200);
    }
  }, {
    setup: function (cs) {
      setTimeout(function() {
        text.destroy();
        text = game.addHighlight(assert,
          ["n == 10 can't absorb the orb",
          "n = 11. Let's fix! [press space]"]);
        cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
      },1200);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(usernode,
        ["We want to prevent n = 11 from being",
        "produced [press space]"]);
      cs.nextStepOnKeyClickOrTimeout(0, () => 0, 32);
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(usernode, ["Click on the gate"]);
      game.onNodeClick(usernode).addOnce(() => { cs.nextStep() });
    }
  }, {
    setup: function (cs) {
      text.destroy();
      text = game.addHighlight(usernode,
        ["Change text to 'n<=10'",
        "(which won't produce 11)",
        "and press enter"]);
      game.onNodeChanged(usernode).addOnce((gameEl: TextIcon, newLines: string[]) =>  {
        if (newLines[0].replace(/\s+/gm,'') === "n<=10") {
          cs.nextStep();
        } else {
          cs.nextStep(-2);
        }
      });
    }
  }, {
    setup: function(cs) {
      text.destroy();
      usernode.unsound = [];
      usernode.sound = ["n <= 10", "n >= 0"];
      game.setCounterExample([]);
      game.checkInvs(() => {
        text = game.addHighlight(usernode,
          ["Hurray, all paths are green",
          "and no more orbs appear!",
          "You passed the level!",
          "[press space]"]);
      });
    }
  }]
  
  global_tutorial_steps = tutorial_steps_1;
  let game = new TutorialGame("content", entry, bbMap, "bogus", tutorial_steps_1);

})
