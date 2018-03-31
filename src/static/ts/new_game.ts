import {rpc_loadLvlBasic, rpc_checkSoundness} from "./rpc";
import {Fun, BB} from "./boogie";
import * as Phaser from "phaser"
import {Node, buildGraph, removeEmptyNodes, UserNode} from "./game_graph"
import {InvGraphGame, TraceLayout, Trace, InvNetwork, InputOutputIcon} from "./invgraph_game"
import {assert} from "./util"
import {parse} from "esprima"
import {Point} from "phaser";

class SimpleGame extends InvGraphGame {
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
    rpc_checkSoundness("unsolved-new-benchmarks2", this.lvlId, invs, (res) => {
      this.setViolations(res, () => {
        this.transformLayout(() => {
          if (this.selected !== null) {
            this.nodeSprites[this.selected.id] = this.drawNode(this.selected, new Point(800, 600), 15)
          }
        }, onDone);
      });
    });
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

  let lvlName = "i-sqrt"
  let lvlSet = "unsolved-new-benchmarks2"
  /*
  let lvlName = "tut01"
  let lvlSet = "tutorial"
  */
  rpc_loadLvlBasic(lvlSet, lvlName, (lvl) => {
    let fun = Fun.from_json(lvl[1]);
    let [graph_entry, mapping] = buildGraph(fun);
    console.log("Initial:", graph_entry);
    [graph_entry, mapping] = removeEmptyNodes(graph_entry, mapping, true);
    console.log("After cleanup of empty nodes:", graph_entry);
    let game = new SimpleGame("content", graph_entry, mapping, fun, lvlName);
  })
})