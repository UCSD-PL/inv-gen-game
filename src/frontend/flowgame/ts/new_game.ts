import {rpc_loadLvl, rpc_checkSoundness} from "./rpc";
import {Fun, BB, Expr_T} from "./boogie";
import * as Phaser from "phaser-ce"
import {Node, buildGraph, removeEmptyNodes, NodeMap, moveLoopsToTheLeft,
  AssumeNode, AssertNode, IfNode, UserNode, AssignNode} from "./game_graph"
import {InvGraphGame, TraceLayout, Trace, InvNetwork, InputOutputIcon, Violation, BranchIcon} from "./invgraph_game"
import {ccast, assert, repeat, structEq, StrMap, single} from "../../ts/util"
import {parse} from "esprima"
import { TextIcon } from "ts/texticon";
import { PositiveTracesWindow } from "../../ts/traceWindow";
import {Level} from "../../ts/level";
import {invPP} from "../../ts/pp"
import {invToJS, esprimaToStr, invEval, evalResultBool, interpretError} from "../../ts/eval"
import {invariantT} from "../../ts/types"

class SimpleGame extends InvGraphGame {
  public onNodeFocused: Phaser.Signal;
  public onFocusedClick: Phaser.Signal;
  public onNodeUnfocused: Phaser.Signal;
  public onFoundInv: Phaser.Signal;
  public focusedNode: Node;

  protected sideWindowContent: StrMap<any>;

  static buildGame(container: string, f: Fun, t: any, lvlName: string): SimpleGame {
    let [graph_entry, mapping] = buildGraph(f);
    graph_entry = moveLoopsToTheLeft(graph_entry);
    console.log("Initial:", graph_entry);
    [graph_entry, mapping] = removeEmptyNodes(graph_entry, mapping, true);
    console.log("After cleanup of empty nodes:", graph_entry);

    return new SimpleGame(container, graph_entry, mapping, lvlName)
  }

  constructor(container: string, graph: Node, n: NodeMap, lvlId: string) {
    super(container, 600, 500, graph, n, lvlId);
    this.onNodeFocused = new Phaser.Signal();
    this.onFocusedClick = new Phaser.Signal();
    this.onNodeUnfocused = new Phaser.Signal();
    this.onFoundInv = new Phaser.Signal();
    this.focusedNode = null;
    this.sideWindowContent = {};
  }

  getHelp(nd: Node): string {
    if (nd instanceof AssumeNode) {
      return "<div class='help'> A source node can produce any orb, as long as it satisfies the node's expression. For example, the source below <br>" +
        "<img src='/game/flowgame/img/example_source.png'/> <br>" +
        "can produce an orb with value n=1, but not an orb with value n=0 or n=-5 since 0 and -5 are not greater than 0.</div>"
    }
    if (nd instanceof AssertNode) {
      return "<div class='help'> A sink node can conusme any orb, as long as it satisfies the node's expression. For example, the snik below <br>" +
        "<img src='/game/flowgame/img/example_sink.png'/> <br>" +
        "can consume an orb with value n=1, but not an orb with value n=0 or n=-5 since 0 and -5 are not greater than 0.</div>"
    }
    if (nd instanceof AssignNode) {
      return "A transformer node changes the values of an orb. If you click on a transformer node you can see the sequence of changes it performs on an orb."
    }
    if (nd instanceof IfNode) {
      return "A branch node changes the direction an orb goes to."
    }
    if (nd instanceof UserNode) {
      return "An accumulator can act as both a source and a sink node. It can consume orbs that satisfy its expression, and it can produce ANY orbs that satisfy its expressions."
    }
  }

  buildContent(nd: Node): any {
    let ndType = (nd: Node): string => {
      if (nd instanceof AssumeNode) return "Source";
      if (nd instanceof AssertNode) return "Sink";
      if (nd instanceof IfNode) return "Branch";
      if (nd instanceof AssignNode) return "Transformer";
      if (nd instanceof UserNode) return "Accumulator";
    }

    let ndIcon = (nd: Node): string => {
      let a = "<div style='background-image: url(\"",
          b = "\"); width:",
          c = "px; height: ",
          d = "px; overflow: hidden; float: left'/>"
      if (nd instanceof AssumeNode) return a + "/game/flowgame/img/source.png" + b + 48 + c + 42 + d;
      if (nd instanceof AssertNode) return a + "/game/flowgame/img/sink.png" + b + 48 + c + 42 + d;
      if (nd instanceof IfNode) return a + "/game/flowgame/img/branch.png" + b + 72 + c + 28 + d;
      if (nd instanceof AssignNode) return a + "/game/flowgame/img/gearbox.png" + b + 48 + c + 42 + d;
      if (nd instanceof UserNode) return a + "/game/flowgame/img/funnel.png" + b + 82 + c + 42 + d;
    }
    let s = "<div id='side_" + nd.id + "' class='side_desc'>"
    let ti = this.textSprites[nd.id];
    s +=  "<span class='side_header'>" +  ndIcon(nd) + ndType(nd) + '</span>'
    s += "</div>"

    let tabs = [['info', 'Info', this.getHelp(nd), true]];
    let tabHeader = '<ul class="nav nav-tabs" role="tablist">',
      tabsContent = '<div class="tab-content">';

    for (let [tabName, tabTittle, tabContent, selected] of tabs) {
      tabHeader += (selected ? '<li class="nav-item active">' : '<li class="nav-item">')
      tabHeader += '<a class="nav-link active" id="' + tabName + '-tab" data-toggle="tab" href="#' + tabName +
        '" role="tab" aria-controls="home" aria-selected="true" aria-expanded="true">' + tabTittle + '</a></li>'
      tabsContent += (selected ? '<div class="tab-pane fade show active in" id="': '<div class="tab-pane fade show active" id="')
      tabsContent += tabName + '" role="tabpanel" aria-labelledby="' + tabName + '-tab">' + tabContent + '</div>'
    }
  
    tabHeader += '</ul>'
    tabsContent += '</div>'
    s += tabHeader + tabsContent;
    return $(s)
  }

  create(): void {
    super.create();
    this.forEachNode((nd: Node) => {
      this.textSprites[nd.id].onChildInputDown.add(() => {
        if (this.focusedNode == nd) {
          this.onFocusedClick.dispatch(nd);
          return;
        }

        if (this.focusedNode != null && this.focusedNode != undefined) {
          this.onNodeUnfocused.dispatch(nd);
        }

        this.focusedNode = nd;
        this.onNodeFocused.dispatch(nd);
      });
      this.sideWindowContent[nd.id] = this.buildContent(nd);
    })

    this.onNodeFocused.add((nd: Node) => {
      this.textSprites[nd.id].select();
      $('#sidewindow').html(this.sideWindowContent[nd.id]);
      /*
      if (!(nd instanceof UserNode)) {
        return;
      }
      let [vars, trace] = traceMap[nd.id];
      let oldLvl = new Level(lvlName, vars, [trace, [], []], "", "", "", lvl.typeEnv, []);
      tracesW.setVariables(oldLvl);
      tracesW.addData(oldLvl.data);
      $(tracesW.parent).show();
      $("#progress").show();
      */
    })
    this.onFocusedClick.add((nd: Node) => {
      if (!(nd instanceof AssignNode))  return;
      let ti = this.textSprites[nd.id];
      this.transformLayout(() => ti.toggleText());
    })
    this.onNodeUnfocused.add((nd: Node) => {
      if (this.focusedNode != null) {
        this.textSprites[this.focusedNode.id].deselect();
      }
      /*
      let [vars, trace] = [[], []];
      let oldLvl = new Level(lvlName, vars, [trace, [], []], "", "", "", lvl.typeEnv, []);
      tracesW.setVariables(oldLvl);
      tracesW.addData(oldLvl.data);
      $("#progress").hide();
      */
    })
    this.onFoundInv.add((nd: UserNode, inv: string) => {
      $("#progress").append("<span class='good'>" + inv + "</span>")
      this.focusedNode = null;
      this.onNodeUnfocused.dispatch(nd);
      //$(tracesW.parent).hide();
    })
  }

  forEachUserNode(cb: (nd: UserNode) => any): void {
    this.entry.forEachReachable((nd: Node) => {
      if (!(nd instanceof UserNode))  return;
      cb(nd);
    })
  }

  forEachNode(cb: (nd: Node) => any): void {
    this.entry.forEachReachable(cb)
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
          spriteNode.setInvariants([], []);
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
    let nd: UserNode = ccast(this.focusedNode, UserNode);
    let gameNd: InputOutputIcon = ccast(this.nodeSprites[nd.id], InputOutputIcon)
    nd.unsound = [esprimaToStr(expr)];
    let invNet: InvNetwork = this.getInvNetwork();
    this.checkInvs(invNet, (violations)=> {
      console.log(violations);
      gameNd.setInvariants(nd.sound, nd.unsound);
    });
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
  rpc_loadLvl(lvlSet, lvlName, (lvl) => {
    let fun = Fun.from_json(lvl.fun);
    let vars = []
    if (lvl.data) {
      for (let varName in lvl.data[0]) {
        vars.push(varName)
      }
    }
    let trace = convertTrace(vars, lvl.data);

    let game = SimpleGame.buildGame('graph', fun, trace, lvlName)
    /*
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
    */
    // For each user node, on click select it and display the data for it
    // on the right hand windows

    /*
    function userInput(commit: boolean): void {
      tracesW.disableSubmit();
      tracesW.clearError();
      let rawInv = tracesW.curExp().trim()

      let inv = invPP(rawInv);
      let desugaredInv = invToJS(inv)
      let parsedInv:invariantT = null

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
    */
  })
})
