import { rpc_loadNextLvl, rpc_checkSoundness, rpc_logEvent, rpc_isTautology } from "./rpc";
import { Fun, BB, Expr_T, Stmt_T } from "./boogie";
import * as Phaser from "phaser-ce"
import {
  Node, buildGraph, removeEmptyNodes, NodeMap, moveLoopsToTheLeft,
  AssumeNode, AssertNode, IfNode, UserNode, AssignNode
} from "./game_graph"
import { InvGraphGame, Trace, InvNetwork, InputOutputIcon, Violation, BranchIcon } from "./invgraph_game"
import { ccast, assert, repeat, structEq, StrMap, single } from "../../ts/util"
import { parse } from "esprima"
import { PositiveTracesWindow } from "../../ts/traceWindow";
import { Level } from "../../ts/level";
import { invPP } from "../../ts/pp"
import { invToJS, esprimaToStr, invEval, evalResultBool, interpretError } from "../../ts/eval"
import { invariantT, TypeEnv } from "../../ts/types"

type TraceMapT = StrMap<[string[], any[]]>;
type BoogieTrace = any[][];

class SimpleGame extends InvGraphGame {
  public onNodeFocused: Phaser.Signal;
  public onFocusedClick: Phaser.Signal;
  public onNodeUnfocused: Phaser.Signal;
  public onFoundInv: Phaser.Signal;
  public focusedNode: [Node, number];
  public onLevelSolved: Phaser.Signal;

  protected traceMap: TraceMapT;
  protected typeEnv: TypeEnv;
  protected sideWindowContent: StrMap<JQuery>;
  protected traceWindowM: StrMap<PositiveTracesWindow>;
  protected lvlSet: string;

  static buildSingleLoopGame(container: string, f: Fun, lvlSet: string, lvlName: string, trace: BoogieTrace, vars: string[]): SimpleGame {
    let [graph_entry, mapping] = buildGraph(f);
    graph_entry = moveLoopsToTheLeft(graph_entry);
    console.log("Initial:", graph_entry);
    [graph_entry, mapping] = removeEmptyNodes(graph_entry, mapping, true);
    console.log("After cleanup of empty nodes:", graph_entry);

    let nodes: Set<Node> = graph_entry.reachable();
    let userNodes: UserNode[] = [];
    for (let nd of nodes) {
      if (nd instanceof UserNode) {
        userNodes.push(nd);
      }
    }
    let traceMap: TraceMapT = {}
    traceMap[single(userNodes).id] = [vars, trace];

    return new SimpleGame(container, graph_entry, mapping, lvlSet, lvlName, traceMap, f.getTypeEnv())
  }

  constructor(container: string, graph: Node, n: NodeMap, lvlSet: string, lvlId: string, traceMap: TraceMapT, typeEnv: TypeEnv) {
    super(container, 600, 500, graph, n, lvlId);
    this.onNodeFocused = new Phaser.Signal();
    this.onFocusedClick = new Phaser.Signal();
    this.onNodeUnfocused = new Phaser.Signal();
    this.onFoundInv = new Phaser.Signal();
    this.onLevelSolved = new Phaser.Signal();
    this.focusedNode = null;
    this.sideWindowContent = {};
    this.traceMap = traceMap;
    this.typeEnv = typeEnv;
    this.traceWindowM = {};
    this.lvlSet = lvlSet;
  }

  getHelp(nd: Node): string {
    let src_help = "<div class='help " + nd.id + '_1' + "'> A source node can produce any orb, as long as it satisfies the node's expression. For example, the source below <br>" +
        "<img src='/game/flowgame/img/example_source.png'/> <br>" +
        "can produce an orb with value n=1, but not an orb with value n=0 or n=-5 since 0 and -5 are not greater than 0.</div>"
    let sink_help = "<div class='help " + nd.id + '_0' + "'> A sink node can conusme any orb, as long as it satisfies the node's expression. For example, the snik below <br>" +
        "<img src='/game/flowgame/img/example_sink.png'/> <br>" +
        "can consume an orb with value n=1. However if an orb with n=-1 reaches it, that causes an explosion since -1 is not greater than 0." +
        "<br><img src='/game/flowgame/img/example_sink_bad.png'/> <br>" +
        "</div>"
    if (nd instanceof AssumeNode) {
      return src_help;
    }
    if (nd instanceof AssertNode) {
      return sink_help;
    }
    if (nd instanceof AssignNode) {
      return "<div class='help'> A transformer node changes the values of an orb. " +
        "If you click on a transformer node you can expand it to see the changes it performs. For example the transformer below adds 1 to x" +
        "<br><img src='/game/flowgame/img/example_expanded_transfromer.png'/> <br>" +
        "As you move orbs across you can see the values change (see below). An orb that has x=4 before the above transformer will have x=5 afterwards." +
        "<br><img src='/game/flowgame/img/example_orb_collapsed_transformer.png'/><br>" +
        "If a transformer node is expanded, you can see the orb change after each line as shown below." +
        "<br><img src='/game/flowgame/img/example_orb_expanded_transformer.png'/><br>" +
        "</div>"
    }
    if (nd instanceof IfNode) {
      return "A branch node redirects each orb to the left or right," +
        "depending on how the branch's expression evaluates for the orb. For" +
        "example, in the below picture the branch goes left when x is less than" +
        "n. Since 4 is less than 5, that orb goes left." +
        "<br><img src='/game/flowgame/img/example_branch_left.png' style='float: center'/><br>" +
        "On the other hand, if an orb has x=5 and n=5 as in the below example," +
        "the orb would go right, as 5 is not less than 5." +
        "<br><img src='/game/flowgame/img/example_branch_right.png'/><br>"
    }
    if (nd instanceof UserNode) {
      return sink_help + src_help;
    }
  }

  updateInfo(nd: Node, root: JQuery): void {
    let infoDiv = $('div#updateable_info', root[2]);
    let info: string;

    if (nd instanceof AssumeNode) {
      if (nd.exprs.length == 0) {
        info = "<div class='info'> This source dosn't produces any orbs since it doesn't have an expression.</div>"
      } else {
        info = "<div class='info'> This source produces any orb whose values satisfy the expression <br><span class='bold'>" +
          nd.exprs[0] +
          "</span></div>"
      }
    }
    if (nd instanceof AssertNode) {
      if (nd.exprs.length == 0) {
        info = "<div class='info'> This sink will explode if any orb reaches it since it doesn't have an expression yet.</div>"
      } else {
        info = "<div class='info'> This sink consumes only orbs whose values satisfy the expression <br><span class='bold'>" +
        nd.exprs[0] +
        "</span></div>"
      }
    }
    if (nd instanceof AssignNode) {
      info = "<div class='info'> This transformer does the following transformations to orb values <br>" +
        nd.stmts.map((s: Stmt_T): string => { return "<span class='bold'>" + s + "</span>" }).join("<br>") +
        "</div>"
    }
    if (nd instanceof IfNode) {
      info = "<div class='info'> This branch sends orbs left if their values satisfy the expression <br><span class='bold'>" +
        nd.exprs[0] +
        "</span> and right otherwise.</div>"
    }
    if (nd instanceof UserNode) {
      if (nd.exprs.length == 0) {
        info = "<div class='info " + nd.id + "_0'> This sink will explode if any orb reaches it since it doesn't have an expression yet.</div>"
        info +=  "<div class='info " + nd.id + "_1'> This source dosn't produces any orbs since it doesn't have an expression.</div>"
      } else {
        info = "<div class='info " + nd.id + "_0'> This sink consumes only orbs whose values satisfy the expressions <br><span class='bold'>" +
        nd.exprs.join(",") +
        "</span></div>"
        info += "<div class='info " + nd.id + "_1'> This source produces any orb whose values satisfy the expressions <br><span class='bold'>" +
          nd.exprs.join(",")  +
          "</span></div>"
      }
    }
    infoDiv.html(info)
  }

  buildTraceWindow(nd: UserNode): JQuery {
    let container = $("<div id='traces_" + nd.id + "'></div>")
    let tracesW = new PositiveTracesWindow(container[0], true);
    let [vars, trace] = this.traceMap[nd.id];
    let oldLvl = new Level(this.lvlId + "_" + nd.id, vars, [trace, [], []], "", "", "", this.typeEnv, []);
    tracesW.setVariables(oldLvl);
    tracesW.addData(oldLvl.data);
    tracesW.onChanged(() => { this.userInput(false); })
    tracesW.onCommit(() => { this.userInput(true); })
    this.traceWindowM[nd.id] = tracesW;
    return container;
  }

  buildContent(nd: Node): JQuery {
    let ndType = (nd: Node): string[] => {
      if (nd instanceof AssumeNode) return ["Source"];
      if (nd instanceof AssertNode) return ["Sink"];
      if (nd instanceof IfNode) return ["Branch"];
      if (nd instanceof AssignNode) return ["Transformer"];
      if (nd instanceof UserNode) return ["Sink", "Source"]
    }

    let ndIcon = (nd: Node): string[] => {
      let a = "<div style='background-image: url(\"",
        b = "\"); width:",
        c = "px; height: ",
        d = "px; overflow: hidden; float: left'/>"
      if (nd instanceof AssumeNode) return [a + "/game/flowgame/img/source.png" + b + 48 + c + 42 + d];
      if (nd instanceof AssertNode) return [a + "/game/flowgame/img/sink.png" + b + 48 + c + 42 + d];
      if (nd instanceof IfNode) return [a + "/game/flowgame/img/white_space.png" + b + 72 + c + 28 + d];
      if (nd instanceof AssignNode) return [a + "/game/flowgame/img/gearbox.png" + b + 48 + c + 42 + d];
      if (nd instanceof UserNode) return [
        (a + "/game/flowgame/img/sink.png" + b + 48 + c + 42 + d),
        (a + "/game/flowgame/img/sink.png" + b + 48 + c + 42 + d)
      ]
    }
    let s = "<div  class='side_desc'>";
    let icons = ndIcon(nd);
    let types = ndType(nd)
    for (let i=0; i<icons.length; i++ ) {
      let icon = icons[i]
      let type = types[i]
      s += "<span class='side_header  " + nd.id + "_" + i + "'>" + icon + type + '</span>'
    }
    s += "</div>"

    let tabs: [string, string, any][] = [];

    if (nd instanceof UserNode) {
      let traceWindowContainer = $('<div></div>')
      traceWindowContainer.append("<div id='updateable_info'></div>")
      let tw = this.buildTraceWindow(nd)
      traceWindowContainer.append(tw)
      tabs.push(["edit", "Edit", traceWindowContainer])
    } else {
      tabs.push(['info', 'Info', "<div id='updateable_info'></div>"])
    }

    tabs.push(['help', 'Help', this.getHelp(nd)])
    let selectedTab = tabs[0][0]

    let tabHeader = '<ul class="nav nav-tabs" role="tablist">',
      tabsContent = '<div class="tab-content">';

    for (let [tabName, tabTittle, _] of tabs) {
      let selected = tabName == selectedTab;
      tabHeader += (selected ? '<li class="nav-item active">' : '<li class="nav-item">')
      tabHeader += '<a class="nav-link active" id="' + tabName + '-tab" data-toggle="tab" href="#' + tabName +
        '" role="tab" aria-controls="home" aria-selected="true" aria-expanded="true" data-target="#' + nd.id + '_' + tabName + '">' + tabTittle + '</a></li>'
      tabsContent += (selected ? '<div class="tab-pane fade active in" id="' : '<div class="tab-pane fade" id="')
      tabsContent += nd.id + '_' + tabName + '" role="tabpanel" aria-labelledby="' + tabName + '-tab"></div>';
    }

    tabHeader += '</ul>'
    tabsContent += '</div>'
    s += tabHeader + tabsContent;

    let newDom: JQuery = $(s)
    for (let [tabName, _, tabContent] of tabs) {
      $("#" + nd.id + "_" + tabName, newDom).append(tabContent)
    }

    this.updateInfo(nd, newDom);
    $(newDom).addClass('hidden');
    return newDom
  }

  create(): void {
    super.create();
    this.forEachNode((nd: Node) => {
      this.textSprites[nd.id].onChildClick.add((sprite: any, pointer: Phaser.Pointer, bboxInd: number) => {
        if (this.focusedNode != null &&
            this.focusedNode[0] == nd &&
            this.focusedNode[1] == bboxInd) {
          this.onFocusedClick.dispatch(nd, bboxInd);
          return;
        }

        if (this.focusedNode != null && this.focusedNode != undefined) {
          this.onNodeUnfocused.dispatch(this.focusedNode[0], this.focusedNode[1]);
        }

        this.focusedNode = [nd, bboxInd];
        this.onNodeFocused.dispatch(nd, bboxInd);
      });

      this.sideWindowContent[nd.id] = this.buildContent(nd);
      $("#sidewindow").append(this.sideWindowContent[nd.id]);
    })

    this.onNodeFocused.add((nd: Node, bboxInd: number) => {
      let sideContent = this.sideWindowContent[nd.id];
      if (nd instanceof UserNode) {
        this.textSprites[nd.id].select(bboxInd + 1);
        $("." + nd.id + '_' + (1-bboxInd), sideContent).addClass('hidden')
        $("." + nd.id + '_' + bboxInd, sideContent).removeClass('hidden')
      } else {
        this.textSprites[nd.id].select(1);
      }

      this.sideWindowContent[nd.id].removeClass("hidden")
    })
    this.onFocusedClick.add((nd: Node, bboxInd: number) => {
      let sideContent = this.sideWindowContent[nd.id];
      if (nd instanceof UserNode) {
        $("." + nd.id + '_' + (1-bboxInd), sideContent).addClass('hidden')
        $("." + nd.id + '_' + bboxInd, sideContent).removeClass('hidden')
      }
      if (!(nd instanceof AssignNode)) return;
      let ti = this.textSprites[nd.id];
      this.transformLayout(() => ti.toggleText());
    })
    this.onNodeUnfocused.add((nd: Node, bboxInd: number) => {
      this.textSprites[nd.id].deselect(0);
      this.sideWindowContent[nd.id].addClass("hidden")
    })
    this.onFoundInv.add((nd: UserNode, inv: string) => {
      $("#progress").append("<span class='good'>" + inv + "</span>")
      this.updateInfo(nd, this.sideWindowContent[nd.id]);
      let bboxInd = this.focusedNode[1];
      $("." + nd.id + '_' + (1-bboxInd), this.sideWindowContent[nd.id]).addClass('hidden')
      $("." + nd.id + '_' + bboxInd, this.sideWindowContent[nd.id]).removeClass('hidden')
    })
  }

  forEachUserNode(cb: (nd: UserNode) => any): void {
    this.entry.forEachReachable((nd: Node) => {
      if (!(nd instanceof UserNode)) return;
      cb(nd);
    })
  }

  forEachNode(cb: (nd: Node) => any): void {
    this.entry.forEachReachable(cb)
  }

  checkInvs: any = (invs: InvNetwork, onDone: () => void) => {
    rpc_checkSoundness(this.lvlSet, this.lvlId, invs, (res: Violation[]) => {
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
            this.onFoundInv.dispatch(un, un.unsound);
            un.sound = un.unsound.concat(un.sound);
            un.unsound = [];
            this.blowUp(this.adversary, () => {
              if (res.length > 0) {
                this.haha(this.adversary)
              }
            })
          } else {
            this.haha(this.adversary)
          }
          let spriteNode = this.nodeSprites[un.id] as InputOutputIcon;
          spriteNode.setInvariants([], []);
        })
      }, () => {
        this.setViolations(res, onDone);
        if (res.length == 0) {
          this.blowUpHard(this.adversary, () => {
            this.adversary.kill();
            this.onLevelSolved.dispatch();
          });
        }
      });
    });
  }

  onFirstUpdate(): void {
    super.onFirstUpdate();
    this.checkInvs(this.getInvNetwork(), () => { });
  }

  setExpr(expr: invariantT): void {
    assert(this.userNodes.length == 1);
    let nd: UserNode = ccast(this.focusedNode[0], UserNode);
    let gameNd: InputOutputIcon = ccast(this.nodeSprites[nd.id], InputOutputIcon)
    nd.unsound = [esprimaToStr(expr)];
    let invNet: InvNetwork = this.getInvNetwork();
    this.checkInvs(invNet, (violations) => {
      console.log(violations);
      gameNd.setInvariants(nd.sound, nd.unsound);
    });
  }

  userInput(commit: boolean): void {
    // Currently selected node must be a user node
    let nd: UserNode = ccast(this.focusedNode[0], UserNode);
    let tracesW: PositiveTracesWindow = this.traceWindowM[nd.id];
    let [vars, trace] = this.traceMap[nd.id];

    tracesW.disableSubmit();
    tracesW.clearError();
    let rawInv = tracesW.curExp().trim()

    let inv = invPP(rawInv);
    let desugaredInv = invToJS(inv)
    let parsedInv: invariantT = null

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
        rpc_isTautology(parsedInv, this.typeEnv, (res: boolean)=> {
          if (res) {
            tracesW.msg("<span class='error'>This is always true</span>");
            return;
          }
          tracesW.enableSubmit();

          if (!commit) {
            tracesW.msg("<span class='good'>Press Enter...</span>");
            return;
          } 

          this.setExpr(parsedInv);
        });
      }
    } catch (err) {
      console.log(err);
      tracesW.delayedError(<string>interpretError(err));
    }
  }

  destroy(): void {
    let canvas = this.game.canvas;
    let sidewindow = $("#sidewindow")
    sidewindow.empty();
    $(canvas).detach();
    this.game.destroy();
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

function showOverlay(html: (string | HTMLElement | JQuery)): void {
  $("#overlay").empty().append(html).fadeIn(1000);
}

function hideOverlay(): void {
  $("#overlay").fadeOut(1000);
}

$(document).ready(function () {
  let game: SimpleGame = null;
  let workerId = "foobar"

  function loadAndPlayNextLevel(): void {
    rpc_loadNextLvl(workerId, (lvl) => {
      if (lvl == null) {
        showOverlay("<h1 class='good'>You solved all the levels!!</h1>")
        return;
      }
      let fun = Fun.from_json(lvl.fun);
      let vars = []
      if (lvl.data) {
        for (let varName in lvl.data[0]) {
          vars.push(varName)
        }
      }
      let trace = convertTrace(vars, lvl.data);
      if (game != null) {
        game.destroy()
      }
      game = SimpleGame.buildSingleLoopGame('graph', fun, lvl.lvlSet, lvl.id, trace, vars);
      $('#next-level-bttn').click(() => {
        $('#bottom').hide();
        let nextlvlOverlay = $("<h1 class='good'>Good job! You solved the level! On to the next one!<br>" +
          "<button id='next-level-overlay' class='btn-next'>Next Level</button>" +
          "</h1>")
        $(".btn-next", nextlvlOverlay).click(() => { hideOverlay() })
        // TODO: Half the arguments are from old game. Re-work
        rpc_logEvent(workerId, "FinishLevel", [lvl.lvlSet, lvl.id, true, [], [], 0, false, game.getInvNetwork()], () => {
          $('#graph').html('')
          $('#sidewindow').html('')
          loadAndPlayNextLevel()
        })
      })
      game.onLevelSolved.add(() => {
        $('#bottom').show();
      })
    })
  }
  loadAndPlayNextLevel();
})
