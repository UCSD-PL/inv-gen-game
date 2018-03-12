import {rpc_loadLvlBasic, rpc_checkSoundness} from "./rpc";
import {Fun, BB} from "./boogie";
import {parse} from "esprima"
import {invariantT} from "./types"
import * as Phaser from "phaser"
import {topo_sort, bfs} from "./graph";
import {getUid, StrMap, assert, max, intersection, single} from "./util"
import {Node, ExprNode, AssignNode, IfNode, AssumeNode,
        AssertNode, buildGraph, removeEmptyNodes, exit} from "./game_graph"

interface Size {
  w: number;
  h: number;
}
interface Point {
  x: number;
  y: number;
}
type Vector = Point;

function add(p1: Point, p2: Point): Point {
  return { x: p1.x+p2.x, y: p1.y+p2.y };
}

class SimpleGame {
  entry: Node;

  constructor(graph: Node) {
    this.game = new Phaser.Game(800, 600, Phaser.AUTO, 'content',
      { preload: this.preload, create: this.create });
    this.entry = graph;
  }

  f: Fun;
  game: Phaser.Game;

  preload: any = () => {
    this.game.stage.backgroundColor = "#ffffff";
  }

  draw(nd: Node, pos: Point, size: number): any {
    let style = { font: size + "px Courier New, Courier, monospace", align: "center", fill: "#000000" }
    let text: string;
    if (nd instanceof AssignNode) {
      text = nd.stmts.join("\n");
    } else if (nd instanceof ExprNode) {
      text = nd.expr
    } else {
      throw new Error("NYI" + nd);
    }
    return this.game.add.text(pos.x, pos.y, text, style);
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
        g.moveTo(start.x, start.y);
        g.lineTo(p.x, p.y);
      }
    }

    let drawBackedge = (prev: Node, next: Node): void => {
      let path : Point[];
      let fromP: Point = pos[prev.id];
      let toP: Point = pos[next.id];
      let fromS: Size = ownSizeMap[prev.id];
      let toS: Size = ownSizeMap[next.id];

      if (prev.successors[0].reachable().has(next)) {
        // LHS
        let toBlockS: Size = sizeMap[next.successors[0].id];
        let start = add(fromP, { x: -fromS.w/2, y: fromS.h/2 });
        let j1: Point = {x: toP.x - toBlockS.w,  y: start.y};
        let j2: Point = {x: j1.x,  y: (toP.y + toS.h/2)};
        let end: Point = {x: toP.x - toS.w/2,  y: (toP.y + toS.h/2)};
        path = [start, j1, j2, end];
      } else {
        // RHS
        throw new Error("NYI");
      }

      for (var i in path) {
        if (i == "0") {
          g.moveTo(path[i].x, path[i].y);
        } else {
          g.lineTo(path[i].x, path[i].y);
        }
      }
    }

    bfs(this.entry, drawNode, drawBackedge);
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
    let game = new SimpleGame(graph_entry);

    /*
    let headers: string[] = [];

    for (let k in lvl[2]) {
      if (lvl[2].hasOwnProperty(k)) {
        headers.push(k);
      }
    }
    console.log(headers)

    let invNetwork : { [label: string] : invariantT[] } = { };

    for (let lbl of headers) {
      invNetwork[lbl] = [parse("false")];
    }
    rpc_checkSoundness("unsolved-new-benchmarks2", "i-sqrt", invNetwork, (res) => {
      console.log("checkSoundness: ", res);
    })
    */

  })
})
