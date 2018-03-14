import {rpc_loadLvlBasic, rpc_checkSoundness} from "./rpc";
import {Fun, BB} from "./boogie";
import {parse} from "esprima"
import {Node as ESNode} from "estree";
import {invariantT} from "./types"
import * as Phaser from "phaser"
import {topo_sort, bfs, path} from "./graph";
import {Expr_T} from "./boogie";
import {getUid, StrMap, assert, max, intersection, single} from "./util"
import {Node, ExprNode, AssignNode, IfNode, AssumeNode, UserNode,
        AssertNode, buildGraph, removeEmptyNodes, exit, NodeMap} from "./game_graph"
import {Size, Point, Vector, Path, add} from "./geometry"
import {FiniteAnimation, Move} from "./animation"

type InvNetwork = StrMap<ESNode[]>;
type Violation = any[];

type GameMode = "selected" | "waiting" | "animation" | "unselected";

class SimpleGame {
  entry: Node;
  selected: UserNode;
  userNodes: UserNode[];
  bbToNode: NodeMap;
  edges: StrMap<StrMap<Path>>;
  curAnim: FiniteAnimation;
  f: Fun;
  mode: GameMode;

  constructor(graph: Node, n: NodeMap, f: Fun) {
    this.game = new Phaser.Game(800, 600, Phaser.AUTO, 'content',
      { preload: this.preload, create: this.create, update: this.update});
    this.entry = graph;
    this.userNodes = []
    console.log("bbNode: ", n);
    this.bbToNode = n;
    this.edges = {};
    this.curAnim = null;
    this.f = f;
    this.unselect();
  }

  game: Phaser.Game;

  unselect():void {
    this.mode = "unselected";
    this.selected = null;
    $("#inv").val("");
    $("#inv").prop("disabled", true);
    $("#overlay").prop("display", "none");
  }

  select(n: UserNode):void {
    this.mode = "selected";
    this.selected = n;
    $("#inv").val(n.expr);
    $("#inv").prop("disabled", false);
    $("#overlay").prop("display", "none");
  }

  waiting(): void {
    $("#overlay").prop("display", "block");
  }

  animate(a: FiniteAnimation): void {
    $("#overlay").prop("display", "block");
    this.mode = "animation";
    this.curAnim = a;
    a.onDone(() => {
      this.curAnim = null;
      this.unselect();
    });
    a.start();
  }

  preload: any = () => {
    this.game.stage.backgroundColor = "#ffffff";
    this.game.load.image('bug', 'img/ladybug.png');
  }

  update: any = () => {
    if (this.curAnim != null) {
      this.curAnim.tick();
    }
  }

  draw(nd: Node, pos: Point, size: number): any {
    let style = { font: size + "px Courier New, Courier, monospace", align: "center", fill: "#000000" }
    let text: string;
    if (nd instanceof AssignNode) {
      style.fill = "#000000";
      text = nd.stmts.join("\n");
    } else if (nd instanceof ExprNode) {
      text = nd.expr
      console.log(nd.id, nd.expr);
      if (nd instanceof AssumeNode) {
        style.fill = "#00ff00"
      } else if (nd instanceof AssertNode) {
        style.fill = "#ff0000"
      } else if (nd instanceof UserNode) {
        style.fill = "#0000ff"
      } else if (nd instanceof IfNode) {
        style.fill = "#8b4513"
      }
    } else {
      throw new Error("NYI" + nd);
    }
    let body = this.game.add.text(pos.x, pos.y, text, style);
    if (nd instanceof UserNode) {
      // Add onclick handler
      console.log(body);
      body.inputEnabled = true;
      body.events.onInputDown.add(() => { this.select(nd); }, this);
    }
    return body
  }

  userInput: any = (inv: string) => {
    let invNet: InvNetwork = {};
    assert(this.selected != null);
    try {
      let pinv = parse($("#inv").val());
    } catch (e) {
      console.log("Couldn't parse");
      return
    }

    this.selected.expr = $("#inv").val();

    for (let nd of this.userNodes) {
      assert(nd.successors.length == 1 &&
        nd.successors[0] instanceof IfNode);
      let bbLbl = nd.label;
      invNet[bbLbl] = [parse(nd.expr)];
    }
    console.log(invNet);
    rpc_checkSoundness("unsolved-new-benchmarks2", "i-sqrt", invNet, (res) => {
      console.log("rpc_checkSoundness(): ", res);
      // TODO: Disable clicks
      // TODO: Show all violations
      // Show one violations
      if (res.length == 0) {
        // Yay win!
        console.log("YAY");
      } else {
        console.log("Got", res.length, "violations.");
        console.log("Showing", res[0]);
        this.animate(this.mkAnimation(res[0]));
      }
    });
  }

  mkAnimation(v: Violation): FiniteAnimation {
    let bbLabels: string[] = v[0];
    let values: any[] = v[1];
    let script: any[] = [];
    let valArr: [Node, number, any][] = [];

    for (let i = 0; i < values.length; i++) {
      for (let j = 0; j < values[i].length; j++) {
        let lbl = bbLabels[i];
        let node: Node;

        assert(lbl in this.bbToNode, "Label " + lbl + " missing.");
        assert(j <= this.bbToNode[lbl].length, "Too many values: " + j + " for " + lbl);

        if (j == this.bbToNode[lbl].length) {
          if (i == values.length - 1) {
            // We are at the value after the exit block
            continue;
          }
          node = this.bbToNode[bbLabels[i+1]][0];
        } else {
          node = this.bbToNode[lbl][j];
        }

        valArr.push([node, j, values[i][j]]);
      }
    }

    for (let i = 0; i < valArr.length-1; i++) {
      let [node, stmtIdx, vals] = valArr[i];
      let [nextNode, nextStmtIdx, nextVals] = valArr[i+1];

      if (node == nextNode) continue;
      let leg = path(node, nextNode);

      for (let j = 0; j < leg.length-1; j++) {
        let legN = leg[j], legN1 = leg[j+1];
        script.push([this.edges[legN.id][legN1.id], vals]);
      }
    }

    let points : Point[] = [];
    for (let [path, vals] of script) {
      points = points.concat(path);
    }

    let bug = this.game.add.sprite(points[0].x, points[0].y, "bug")
    let anim = new Move(bug, points, 30);
    anim.onDone(() => { bug.destroy(); });

    return anim;
  }

  create: any = () => {
    let fontSize = 15;
    let [sizeMap, ownSizeMap, relPosMap] = this.computeLayout(fontSize);
    console.log("Size Map: ", sizeMap);
    console.log("relPosMap: ", relPosMap);
    let pos: StrMap<Point> = {};
    let g = this.game.add.graphics(0, 0);
    g.lineStyle(10, 0xffd900, 1);

    let drawNode = (prev: Node, next: Node): void => {
      let [dummy, relp] = relPosMap[next.id];
      let prevP;
      let p: Point;

      assert(dummy == prev);
      if (prev == null) {
        assert(next == this.entry);
        p = { x: sizeMap[this.entry.id].w/2, y: 0 };
      } else {
        prevP = pos[prev.id];
        p = add(prevP, relp);
      }

      pos[next.id] = p;
      this.draw(next, add(p, {y:0, x: -ownSizeMap[next.id].w/2}), fontSize);
      if (prev != null) {
        let start: Point = add(prevP, { x: 0, y: sizeMap[prev.id].h });
        if (!(prev.id in this.edges)) {
          this.edges[prev.id] = {};
        }
        this.edges[prev.id][next.id] = [start, p];
        g.moveTo(start.x, start.y);
        g.lineTo(p.x, p.y);
      }
    }

    let drawBackedge = (prev: Node, next: Node): void => {
      let path : Path;
      let fromP: Point = pos[prev.id];
      let toP: Point = pos[next.id];
      let fromS: Size = ownSizeMap[prev.id];
      let toS: Size = ownSizeMap[next.id];

      if (prev.successors[0].reachable().has(next)) {
        // LHS
        let toBlockS: Size = sizeMap[next.successors[0].successors[0].id];
        let start = add(fromP, { x: -fromS.w/2, y: fromS.h/2 });
        let j1: Point = {x: toP.x - toBlockS.w,  y: start.y};
        let j2: Point = {x: j1.x,  y: (toP.y + toS.h/2)};
        let end: Point = {x: toP.x - toS.w/2,  y: (toP.y + toS.h/2)};
        path = [start, j1, j2, end];
      } else {
        // RHS
        throw new Error("NYI");
      }
      if (!(prev.id in this.edges)) {
        this.edges[prev.id] = {};
      }
      this.edges[prev.id][next.id] = path;

      for (var i in path) {
        if (i == "0") {
          g.moveTo(path[i].x, path[i].y);
        } else {
          g.lineTo(path[i].x, path[i].y);
        }
      }
    }

    bfs(this.entry, drawNode, drawBackedge);
    console.log("Pos: ", pos);
    let invBox = $("#inv")
    invBox.keyup((e) => {
      if(e.keyCode == 13)
      {
        this.userInput(invBox.val());
      } else if (e.keyCode == 27) {
        this.unselect();
      }
    })
  }

  computeLayout(fontSize: number): [StrMap<Size>, StrMap<Size>, StrMap<[Node, Point]>] {
    let topo: StrMap<number> = topo_sort(this.entry);
    let exitNode: Node = exit(this.entry);
    let size: StrMap<Size> = {};
    let width: StrMap<number> = {};
    let ifEndPoints: StrMap<[Node, Node, Node]> = {};
    let ft_width = fontSize*0.6;
    let ft_height = fontSize*1.5;
    let h_spacing = 50;
    let backedge_space = 30;
    let relPos: StrMap<[Node, Point]> = {};

    // Pass 1: For each IfNode, compute its lhs and rhs terminators, and union point (if any)
    function if_endpoints(prev: Node, next: Node) {
      if (!(next instanceof IfNode)) return;
      let lhs = next.successors[0], rhs = next.successors[1];
      let common = intersection(lhs.reachable(), rhs.reachable());
      let union_nd : Node = null;

      for (let nd of common) {
        if (union_nd == null || topo[nd.id] < topo[union_nd.id]) {
          union_nd = nd;
        }
      }

      assert(union_nd != null);

      if (union_nd == lhs) {
        console.log("rhs is a loop, lhs exits");
        let rhs_endpoint = single(intersection(new Set(next.predecessors), rhs.reachable()));
        ifEndPoints[next.id] = [exitNode, rhs_endpoint, null];
      } else if (union_nd == rhs) {
        console.log("lhs is a loop, rhs exits");
        let lhs_endpoint = single(intersection(new Set(next.predecessors), lhs.reachable()));
        ifEndPoints[next.id] = [lhs_endpoint, exitNode, null];
      } else {
        // If node with a union point
        console.log("if node with 2 halfs and a continuation");
        let lhs_endpoint = single(intersection(new Set(union_nd.predecessors), lhs.reachable()));
        let rhs_endpoint = single(intersection(new Set(union_nd.predecessors), rhs.reachable()));
        ifEndPoints[next.id] = [lhs_endpoint, rhs_endpoint, union_nd];
        throw new Error("NYI");
      }
    }

    bfs(this.entry, if_endpoints, null);
    console.log(ifEndPoints);

    // Pass 2: Cache estimated sizes
    function estimateSize(n: Node): Size {
      if (n instanceof AssignNode) {
        return { w: max(n.stmts.map((x)=>x.length))*ft_width,
                 h: n.stmts.length * ft_height }
      } else if (n instanceof ExprNode) {
        return { w: n.expr.length * ft_width, h: ft_height }
      } else {
        throw new Error("NYI node " + n);
      }
    }
    bfs(this.entry, (prev: Node, cur: Node): void => { size[cur.id] = estimateSize(cur); }, null);
    console.log("Size: ", size);

    // Pass 3: Compute the widhts for each part of the graph

    function computeWidth(start: Node, end: Node): number {
      let sz: Size = size[start.id];
      let res: number;

      if (start == end) {
        res = sz.w;
      } else {
        if (start instanceof IfNode) {
          let lhs_start = start.successors[0], rhs_start = start.successors[1];
          let [lhs_end, rhs_end, union_nd] = ifEndPoints[start.id];

          if (union_nd != null) {
            // if statement
            let lhs_width = computeWidth(lhs_start, lhs_end);
            let rhs_width = computeWidth(rhs_start, rhs_end);
            let rest_width = computeWidth(union_nd, exitNode);
            res = max([sz.w, lhs_width+rhs_width, rest_width]);
          } else {
            // loop header
            let lhs_width = computeWidth(lhs_start, lhs_end);
            let rhs_width = computeWidth(rhs_start, rhs_end);
            if (rhs_end == exitNode) {
              // Loop on lhs
              lhs_width += backedge_space;
              width[lhs_start.id] = lhs_width;
            } else {
              // Loop on rhs
              rhs_width += backedge_space;
              width[rhs_start.id] = rhs_width;
            }
            res = max([sz.w, lhs_width+rhs_width]);
          }
        } else {
          assert(start.successors.length == 1);
          res = Math.max(sz.w, computeWidth(start.successors[0], end));
        }
      }

      width[start.id] = res
      return res;
    }

    computeWidth(this.entry, exitNode);
    console.log(width);

    // Pass 4: Compute relative positions:
    function compute_rel_pos(prev: Node, next: Node): void {
      let p: Point;
      let myWidth = width[next.id];

      if (prev == null) {
        p = { x: 0, y: 0};
      } else {
        let rel_y = size[prev.id].h + h_spacing;
        if (prev instanceof IfNode) {
          if (next == prev.successors[0]) {
            // Lhs
            p = { x: -width[next.id]/2, y: rel_y };
          } else {
            // Rhs
            p = { x: width[next.id]/2, y: rel_y };
          }
        } else {
          p = { x: 0, y: rel_y }
        }
      }

      relPos[next.id] = [prev, p];
    }
    bfs(this.entry, compute_rel_pos, null);
    console.log(relPos);

    let final_size: StrMap<Size> = {}
    for(let id in size) {
      final_size[id] = { w: width[id], h: size[id].h };
    }

    // Gather user nodes
    bfs(this.entry, (p: Node, n: Node) => {
      if (n instanceof UserNode) {
        this.userNodes.push(n);
      }
    }, null)

    return [final_size, size, relPos];
  }
}

$(document).ready(function() {

  rpc_loadLvlBasic("unsolved-new-benchmarks2", "i-sqrt", (lvl) => {
    let fun = Fun.from_json(lvl[1]);
    let [graph_entry, mapping] = buildGraph(fun);
    [graph_entry, mapping] = removeEmptyNodes(graph_entry, mapping);
    console.log(graph_entry);
    console.log(mapping);
    let game = new SimpleGame(graph_entry, mapping, fun);
  })
})
