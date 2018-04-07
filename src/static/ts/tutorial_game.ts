import {rpc_loadLvlBasic, rpc_checkSoundness} from "./rpc";
import {Fun, BB} from "./boogie";
import * as Phaser from "phaser-ce"
import {Node, AssumeNode, buildGraph, removeEmptyNodes, UserNode, AssignNode, AssertNode} from "./game_graph"
import {InvGraphGame, TraceLayout, Trace, InvNetwork, InputOutputIcon} from "./invgraph_game"
import {assert, getUid} from "./util"
import {parse} from "esprima"
import {Point} from "phaser-ce";

class TutorialGame extends InvGraphGame {
  unselect(): void {
    super.unselect();
    $("#inv").val("");
    $("#inv").prop("disabled", true);
    $("#overlay").prop("display", "none");
  }

  select(n: UserNode):void {
    super.select(n);
    $("#inv").val(n.expr);
    $("#inv").prop("disabled", false);
    $("#overlay").prop("display", "none");
  }

  create(): void {
    super.create();
    let invBox = $("#inv")
    invBox.keyup((e) => {
      if(e.keyCode == 13)
      {
        this.userInput(invBox.val());
      } else if (e.keyCode == 27) {
        this.unselect();
      }
    })

    $("#step").on("click", (e) => { this.stepForward();})
    $("#back").on("click", (e) => { this.stepBackwards();})
    $("#play").on("click", (e) => {
      this.playBug();
      this._controlsPlaying();
    })
    $("#stop").on("click", (e) => {
      this.animationStopRequested = true;
      this._controlsStopped();
    })
    this._controlsDisable();
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

  playBug(onComplete?: ()=>any) {
    super.playBug(()=>{
      this._controlsStopped();
      if (onComplete !== undefined) {
        onComplete();
      }
    });
  }

  checkInvs: any = (invs: InvNetwork, onDone: ()=>void) => {
    let v = [];
    v[0] = ["anon0"];
    v[1] = [[{n:1}, {n:1}, {n:2}, {n:2}]];
    this.setViolations([v], onDone);
    // rpc_checkSoundness("unsolved-new-benchmarks2", this.lvlId, invs, (res) => {
    //   this.setViolations(res, () => {
    //     this.transformLayout(() => {
    //       if (this.selected !== null) {
    //         this.nodeSprites[this.selected.id] = this.drawNode(this.selected, new Point(800, 600), 15)
    //       }
    //     }, onDone);
    //   });
    // });
  }

  onFirstUpdate(): void {
    super.onFirstUpdate();
    this.checkInvs(this.getInvNetwork(), ()=>{});
  }

  userInput: any = (inv: string) => {
    assert(this.selected != null);
    try {
      let pinv = parse(inv);
    } catch (e) {
      console.log("Couldn't parse");
      return
    }

    this.selected.expr = inv;
    let invNet: InvNetwork = this.getInvNetwork();
    this.checkInvs(invNet, ()=> {});
  }

}

$(document).ready(function() {
  console.log("Sorin Says Hi");
  let entry: Node = new AssumeNode(getUid("nd"), "n>0");
  let assign: Node = new AssignNode(getUid("nd"), ["n := n+1"]);
  let assert: Node = new AssertNode(getUid("nd"), "n > 10");
  entry.addSuccessor(assign);
  assign.addSuccessor(assert);
  let bbMap = {"anon0": [entry, assign, assert]};
  let game = new TutorialGame("content", entry, bbMap, "bogus");
})
