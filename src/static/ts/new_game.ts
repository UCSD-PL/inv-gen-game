import {rpc_loadLvlNew, rpc_checkSoundness} from "./rpc";
import {Fun, BB, Expr_T} from "./boogie";
import * as Phaser from "phaser-ce"
import {Node, buildGraph, removeEmptyNodes, UserNode, NodeMap} from "./game_graph"
import {InvGraphGame, TraceLayout, Trace, InvNetwork, InputOutputIcon, Violation} from "./invgraph_game"
import {assert, repeat, structEq, StrMap, single} from "./util"
import {parse} from "esprima"
import {Point} from "phaser-ce";
import { TextIcon } from "ts/texticon";
import { PositiveTracesWindow } from "traceWindow";
import {Level} from "level";
import {invPP} from "pp"
import {invToJS, esprimaToStr, invEval, evalResultBool, interpretError} from "eval"
import {invariantT} from "types"

class SimpleGame extends InvGraphGame {
  public onNodeFocused: Phaser.Signal;
  public onNodeUnfocused: Phaser.Signal;
  public onFoundInv: Phaser.Signal;
  public onTriedInv: Phaser.Signal;
  public focusedNode: TextIcon;
  public onUserTypedInv: Phaser.Signal;

  constructor(container: string, graph: Node, n: NodeMap, lvlId: string) {
    super(container, 600, 400, graph, n, lvlId);
    this.onNodeFocused = new Phaser.Signal();
    this.onNodeUnfocused = new Phaser.Signal();
    this.onFoundInv = new Phaser.Signal();
    this.onTriedInv = new Phaser.Signal();
    this.onUserTypedInv = new Phaser.Signal();
    this.focusedNode = null;
  }

  create(): void {
    super.create();
    this.forEachUserNode((nd: UserNode) => {
      this.textSprites[nd.id].onChildInputDown.add(() => {
        this.onNodeFocused.dispatch(nd);
        this.focusedNode = this.textSprites[nd.id];
      })
      this.textSprites[nd.id].onChanged.add((gameEl: TextIcon, newVal: string) => {
        this.onUserTypedInv.dispatch(gameEl, newVal);
      })
      this.textSprites[nd.id].onSubmitted.add((gameEl: TextIcon, newLines: string[])=> {
        this.onTriedInv.dispatch(gameEl, gameEl.getEditedString());
      })
    })
  }

  forEachUserNode(cb: (nd: UserNode) => any): void {
    this.entry.forEachReachable((nd: Node) => {
      if (!(nd instanceof UserNode))  return;
      cb(nd);
    })
  }

  checkInvs: any = (invs: InvNetwork, onDone: ()=>void) => {
    rpc_checkSoundness("unsolved-new-benchmarks2", this.lvlId, invs, (res: Violation[]) => {
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
            this.onFoundInv.dispatch(un, un.unsound);
            un.sound = un.unsound.concat(un.sound);
            un.unsound = [];
          }
          let spriteNode = this.nodeSprites[un.id] as InputOutputIcon;
          spriteNode.setInvariants(un.sound, un.unsound);
        })
      }, () => {
        this.setViolations(res, onDone);
      });
    });
  }

  onFirstUpdate(): void {
    super.onFirstUpdate();
    this.checkInvs(this.getInvNetwork(), ()=>{});
  }

  setExpr(expr: invariantT): void {
    assert(this.userNodes.length == 1);
    let nd: UserNode = this.userNodes[0];
    let gameNd: TextIcon = this.nodeSprites[nd.id];

    nd.unsound = [esprimaToStr(expr)];
    let invNet: InvNetwork = this.getInvNetwork();
    this.checkInvs(invNet, ()=> {});
  }
}

function convertTrace(vs: string[], t: any): any {
  let res = [];
  for (let store of t) {
    let row = [];
    for (let v of vs) {
      row.push(store[v]);
    }
    res.push(row);
  }
  return res
}

$(document).ready(function() {
  let lvlName = "i-sqrt"
  let lvlSet = "unsolved-new-benchmarks2"
  /*
  let lvlName = "tut01"
  let lvlSet = "tutorial"
  */
  rpc_loadLvlNew(lvlSet, lvlName, (lvl) => {
    let fun = Fun.from_json(lvl[1]);
    let vars = lvl[3]
    let traces = lvl[4];
    let trace = convertTrace(vars, traces[0]);
    let [graph_entry, mapping] = buildGraph(fun);
    console.log("Initial:", graph_entry);
    [graph_entry, mapping] = removeEmptyNodes(graph_entry, mapping, true);
    console.log("After cleanup of empty nodes:", graph_entry);
    let game = new SimpleGame("graph", graph_entry, mapping, lvlName);
    let tracesW = new PositiveTracesWindow($('#traces').get()[0]);

    let nodes: Set<Node> = graph_entry.reachable();
    let userNodes: UserNode[] = [];
    for (let nd of nodes) {
      if (nd instanceof UserNode) {
        userNodes.push(nd);
      }
    }
    let traceMap: StrMap<any> = {};
    traceMap[single(userNodes).id] = [vars, trace];
    // For each user node, on click select it and display the data for it
    // on the right hand windows
    game.onNodeFocused.add((nd: UserNode) => {
      let [vars, trace] = traceMap[nd.id];
      let oldLvl = new Level(lvlName, vars, [trace, [], []], "", "", "", []);
      tracesW.setVariables(oldLvl);
      tracesW.addData(oldLvl.data);
      $(tracesW.parent).show();
      $("#progress").show();
    })
    game.onNodeUnfocused.add((nd: UserNode) => {
      let [vars, trace] = [[], []];
      let oldLvl = new Level(lvlName, vars, [trace, [], []], "", "", "", []);
      tracesW.setVariables(oldLvl);
      tracesW.addData(oldLvl.data);
      $("#progress").hide();
    })
    game.onFoundInv.add((nd: UserNode, inv: string) => {
      $("#progress").append("<span class='good'>" + inv + "</span>")
      game.onNodeUnfocused.dispatch(nd);
      game.focusedNode = null;
      $(tracesW.parent).hide();
    })
    game.onUserTypedInv.add((nd: TextIcon, inv: string) => {
      tracesW.setExp(inv);
    });
    game.onTriedInv.add((nd: TextIcon, inv: string) => {
      tracesW.setExp(inv);
      userInput(true);
    })

    function userInput(commit: boolean): void {
      tracesW.disableSubmit();
      tracesW.clearError();
      let rawInv = tracesW.curExp().trim()

      let inv = invPP(rawInv);
      let desugaredInv = invToJS(inv)
      let parsedInv:invariantT = null

      if (!commit) {
        console.log("Set: ", game.focusedNode, inv)
        game.focusedNode.setEditedString(inv);
      }


      try {
        parsedInv = parse(desugaredInv);
      } catch (err) {
        tracesW.delayedError(inv + " is not a valid expression.");
        return;
      }

      if (inv.length === 0) {
        tracesW.evalResult({ clear: true });
        return;
      }

      var jsInv = esprimaToStr(parsedInv);

      try {
        let pos_res = invEval(parsedInv, vars, trace);
        let res: [any[], [any, any][], any[]] = [pos_res, [], []];
        tracesW.evalResult({ data: res });

        if (!evalResultBool(res))
          return;
        
        let all = pos_res.length
        let hold = pos_res.filter(function (x) { return x; }).length
  
        if (hold < all)
          tracesW.error("Holds for " + hold + "/" + all + " cases.")
        else {
          tracesW.enableSubmit(); 
          if (!commit) {
            tracesW.msg("<span class='good'>Press Enter...</span>");
            return;
          } else {
            game.setExpr(parsedInv);
          }
        }
      } catch (err) {
        console.log(err);
        tracesW.delayedError(<string>interpretError(err));
      }
    }
    tracesW.onChanged(() => { userInput(false); })
    tracesW.onCommit(() => { userInput(true); })
  })
})
