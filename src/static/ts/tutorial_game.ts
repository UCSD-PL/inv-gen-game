import {rpc_loadLvlBasic, rpc_checkSoundness} from "./rpc";
import {Fun, BB, Expr_T} from "./boogie";
import * as Phaser from "phaser-ce"
import {Node, AssumeNode, AssertNode, AssignNode, buildGraph, removeEmptyNodes, UserNode} from "./game_graph"
import {InvGraphGame, TraceLayout, Trace, InvNetwork, InputOutputIcon, Violation} from "./invgraph_game"
import {getUid, assert, repeat, structEq, StrMap} from "./util"
import {parse} from "esprima"
import {Point} from "phaser-ce";
import { TextIcon } from "ts/texticon";

class TutorialGame extends InvGraphGame {
  unselect(): void {
    $("#inv").val("");
    $("#inv").prop("disabled", true);
    $("#overlay").prop("display", "none");
  }

  select(n: UserNode):void {
    $("#inv").val(n.exprs.join("&&"));
    $("#inv").prop("disabled", false);
    $("#overlay").prop("display", "none");
  }

  create(): void {
    super.create();
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
    this.forEachUserNode((nd: UserNode) => {
      this.textSprites[nd.id].onChanged.add((gameEl: TextIcon, newLines: string[])=> {
        assert (newLines.length >= nd.sound.length)
        let soundLines = newLines.slice(newLines.length-nd.sound.length);
        let unknownLines = newLines.slice(0, newLines.length-nd.sound.length);
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

        let invNet: InvNetwork = this.getInvNetwork();
        this.checkInvs(invNet, ()=> {});
      })
    })
  }

  forEachUserNode(cb: (nd: UserNode) => any): void {
    this.entry.forEachReachable((nd: Node) => {
      if (!(nd instanceof UserNode))  return;
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
    let res = [v];
    this.setViolations(res, () => {
      this.transformLayout(() => {
        let soundnessViolations: StrMap<Violation[]> = {};
        for (let v of res) {
          let t: Trace = this.getTrace(v);
          let end: UserNode = (t[t.length-1][0] instanceof UserNode ? t[t.length-1][0] as UserNode: null);
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
      }, onDone);
    });
  }

  onFirstUpdate(): void {
    super.onFirstUpdate();
    this.checkInvs(this.getInvNetwork(), ()=>{});
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
