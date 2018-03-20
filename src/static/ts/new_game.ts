import {rpc_loadLvlBasic, rpc_checkSoundness} from "./rpc";
import {Fun, BB} from "./boogie";
import {parse} from "esprima"
import {Node as ESNode} from "estree";
import {invariantT} from "./types"
import * as Phaser from "phaser"
import {Point} from "phaser";
import {topo_sort, bfs, path} from "./graph";
import {Expr_T} from "./boogie";
import {getUid, StrMap, assert, max, intersection, single, diff, diff2, arrEq, union2, copyMap2, mapMap2, copyMap, difference2, reversed} from "./util"
import {Node, ExprNode, AssignNode, IfNode, AssumeNode, UserNode,
        AssertNode, buildGraph, removeEmptyNodes, exit, NodeMap} from "./game_graph"

type InvNetwork = StrMap<ESNode[]>;
type Violation = any[];
type SpriteMap = StrMap<Phaser.Sprite>;
type PointMap = StrMap<Point>;
type Path = Point[];
type PathMap = StrMap<Point[]>;
type EdgeMap = StrMap<StrMap<Path>>
type EdgeState = "unknown" | "good" | "fail"
type EdgeStates = StrMap<StrMap<EdgeState>>
type Layout = [SpriteMap, PointMap, EdgeMap, EdgeStates];
type Color = number;

type TraceElement = [Node, number, any];
type Trace = TraceElement[]
type TraceLayoutStep =[number, (Point | Point[]), string]
type TraceLayout = TraceLayoutStep[]

type GameMode = "selected" | "waiting" | "animation" | "unselected" | "show_trace";
interface Size {
  w: number;
  h: number;
}

let bugWidth = 20;
let bugHeight = 25;

function edgeColor(st: EdgeState): Color {
  if (st == "unknown") {
    return 0xb4b4b4;
  } else if (st == "good") {
    return 0x006400
  } else {
    assert(st == "fail")
    return 0xff0000
  }
}

function isSound(vs: Violation[], nd: UserNode): boolean {
  // Return true if the invariants at node nd are sound despite
  // the potential failures
  for (let v of vs) {
    if (v[0][v[0].length-1] == nd.label) {
      return false;
    }
  }
  return true;
}

type SpritePool = StrMap<Set<Phaser.Sprite>>;
type ViolationInfo = [Phaser.Sprite, Violation, Trace, TraceLayout][];

class SimpleGame {
  entry: Node;
  selected: UserNode;
  userNodes: UserNode[];
  bbToNode: NodeMap;
  f: Fun;
  mode: GameMode;
  width: number;
  height: number;
  textSprites: SpriteMap;
  nodeSprites: SpriteMap;
  edges: StrMap<StrMap<Path>>;
  edgeStates: EdgeStates;
  pos: PointMap;
  graphics: Phaser.Graphics;
  curViolations: ViolationInfo;
  spritePool: SpritePool;
  selectedViolation: [Phaser.Sprite, Phaser.Text, number, number];
  animationStopRequested: boolean;

  constructor(graph: Node, n: NodeMap, f: Fun) {
    this.width = 800;
    this.height = 600;
    this.game = new Phaser.Game(this.width, this.height, Phaser.AUTO, 'content',
      { preload: this.preload, create: this.create, update: this.update});
    this.entry = graph;
    this.userNodes = []
    this.bbToNode = n;
    this.edges = {};
    this.edgeStates = {};
    this.f = f;
    this.nodeSprites = {};
    this.textSprites = {};
    this.unselect();
    this.spritePool = {};
    this.curViolations = [];
    this.animationStopRequested = false;
  }

  getSprite(img: string, x?: number, y?: number, show?: boolean): Phaser.Sprite {
    let s: Phaser.Sprite;
    if (x === undefined) x = 0;
    if (y === undefined) y = 0;
    if (show === undefined) show = false;

    if (!(img in this.spritePool)) {
      this.spritePool[img] = new Set();
    }

    if (this.spritePool[img].size == 0) {
      s = this.game.add.sprite(x, y, img);
    } else {
      s = this.spritePool[img].values().next().value;
      this.spritePool[img].delete(s);
      s.x = x; s.y = y;
    }
    s.exists = show;
    return s;
  }

  putSprite(s: Phaser.Sprite) {
    s.kill();
    let key = s.key;
    assert(key in this.spritePool);
    this.spritePool[key].add(s);
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

  updateLayout(oldL: Layout, newL: Layout, onUpdate: ()=>any): void {
    let [oldSpr, oldPos, oldEdges, oldEdgeState] = oldL;
    let [newSpr, newPos, newEdges, newEdgeState] = newL;
    let eraseEdges: Set<[string, string]>;
    let repaintEdges: Set<[string, string]>;
    // Todo: Better to render paths to textures and show them like that?

    // Compute sprites to disappear and edges that need removal/repaint
    let [removedSprites, changedSprites, addedSprites] = diff(oldSpr, newSpr);
    let [dummy3, movedSprites, dummy4] = diff(oldPos, newPos);
    let [removedEdges, changedEdges, addedEdges] = diff2(oldEdges, newEdges, arrEq);
    let [dummy1, changedEdgeStates, dummy2] = diff2(oldEdgeState, newEdgeState);

    changedEdges = union2(changedEdges, changedEdgeStates);
    movedSprites = difference2(movedSprites, changedSprites);

    let bye = this.game.add.group();
    let hello = this.game.add.group();

    // Compute sprites that need to disappear
    for (let id of union2(removedSprites, changedSprites)) {
      bye.add(oldSpr[id])
    }
    // Compute sprites that need to appear
    for (let id of union2(addedSprites, changedSprites)) {
      let s = newSpr[id];
      s.x = newPos[id].x;
      s.y = newPos[id].y;
      hello.add(s);
    }

    // Compute animations for sprites that need to move
    // TODO: fix this code when sprites change shape
    let moveTweens: Phaser.Tween[] = [];
    for (let id1 of movedSprites) {
      let moveTw = this.game.add.tween(oldSpr[id1]);
      moveTw.to({ x: newPos[id1].x, y: newPos[id1].y }, 1000, Phaser.Easing.Linear.None);
      moveTweens.push(moveTw);
    }

    // Compute edges to erase/repaint
    eraseEdges = union2(removedEdges, changedEdges);
    repaintEdges = union2(changedEdges, addedEdges);

    // Put it all toghether with continuations:
    // Step 1: Remove nodes that need removal and erase all paths that need erasing
    let step1 = (next: ()=>any) => {
      //console.log("Step1: erase edges ", eraseEdges, " and remove sprites ", bye);
      for (let toErase of eraseEdges) {
        let [id1, id2] = toErase;
        this.drawEdge(this.graphics, oldEdges[id1][id2], 0xffffff);
      }
      if (bye.length > 0) {
        let byeAnim = this.game.add.tween(bye);
        byeAnim.to({alpha: 0}, 100, Phaser.Easing.Linear.None);
        byeAnim.onComplete.add(() => { bye.kill(); next(); })
        byeAnim.start();
      } else {
        next();
      }
    }
    // Step 2: Move all sprites
    let step2 = (next: ()=>any) => {
      //console.log("Step2: move tweens ", moveTweens);
      if (moveTweens.length == 0) {
        next();
        return;
      }

      moveTweens[0].onComplete.add(next);
      for (let t of moveTweens) {
        t.start();
      }
    }

    // Step 3: Repaint paths that need it, fade in new sprites
    let step3 = (next: ()=>any) => {
      //console.log("Step3: repaint edges", repaintEdges, "and show sprites", hello);
      for (let toRepaint of repaintEdges) {
        let [id1, id2] = toRepaint;
        this.drawEdge(this.graphics, newEdges[id1][id2], edgeColor(newEdgeState[id1][id2]));
      }
      if (hello.length > 0) {
        let helloAnim = this.game.add.tween(hello);
        helloAnim.to({alpha: 1}, 100, Phaser.Easing.Linear.None);
        helloAnim.onComplete.add(() => { next(); })
        helloAnim.start();
      } else {
        next();
      }
    }

    // Kick it off
    step1( () => { step2(() => { step3(() => {
      this.nodeSprites = newSpr;
      this.pos = newPos;
      this.edges = newEdges;
      this.edgeStates = newEdgeState;
      onUpdate();
    }) }); });
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
    assert (this.selectedViolation != null)
    let [err, text, idx, step] = this.selectedViolation;
    let bug = err.children[0];
    err.remove(bug);
    this.game.add.existing(bug);
    this.putSprite(bug);
    err.destroy(true);
    text.destroy();
    this.selectedViolation = null;
    this._controlsDisable();
  }

  showViolation(idx: number): void {
    if (this.selectedViolation != null) {
      this.hideViolation();
    }
    let [buttonSprite, v, trace, traceLayout]: ViolationInfo = this.curViolations[idx];
    let style = { font: "15px Courier New, Courier, monospace", fill: "#000000", backgroundColor: "#ffffff" }
    let [dummy, startPoint, startText] = traceLayout[0]
    let err = this.game.add.group()
    let bug = this.getSprite("bug", 0, 0)
    let text = this.game.add.text(20, 0, "", style);
    err.add(bug);
    err.add(text);
    bug.exists = true;
    this.selectedViolation = [err, text, idx, 0];
    this.positionBug(0);
    this._controlsStopped();
  }

  private positionBug(step: number) {
    // Set the position and text of the bug to correspond with given step in the
    // trace If that step is traveling along edge paths, place it at start of
    // that path.
    let [err, text, idx, curStep] = this.selectedViolation;
    let [buttonSprite, v, trace, traceLayout]: ViolationInfo = this.curViolations[idx];

    let [dummy, pos, newText]: TraceLayoutStep = traceLayout[step];
    let finalPos: Point;
    if (pos instanceof Point) {
      finalPos = pos;
    } else {
      finalPos = pos[0];
    }
    let bug = err.children[0];
    err.x = finalPos.x - bug.width/2; err.y = finalPos.y - bug.width/2;
    text.text = newText;
    this.selectedViolation[3] = step;
  }

  private getBugTween(err: Phaser.Group,
                      traceLayout: TraceLayout, curStep: number, forward: boolean): Phaser.Tween {
    // Compute the animation to move the bug one step forward/backward from its current step.
    let inc: number = (forward ? 1 : -1);
    let t: Phaser.Tween = this.game.add.tween(err);
    let text = err.children[1];
    let icon = err.children[0];
    let nextStep = curStep + inc;

    let pickSide = (p: Path): Point => (forward? p[0] : p[p.length-1]);

    let [curTraceIdx, curPos, curText] = traceLayout[curStep];
    let [traceIdx, pos, newText] = traceLayout[nextStep];
    let path: Path;
    
    if (forward) {
      if (curPos instanceof Point) {
        // At the start of a statement step, going forward 1
        path = (pos instanceof Point ? [pos] : [pos[0]]);
      } else {
        // At the start of a edge animation, going forward
        path = curPos;
      }
    } else {
      if (pos instanceof Point) {
        // Going backwards, back edge is just 1 point
        path = [pos];
      } else {
        // Going backwards, previous is an animation.
        path = reversed(pos);
      }

    }

    for (let pt of path) {
      t.to({x:pt.x - icon.width/2, y:pt.y - icon.width/2}, 500, Phaser.Easing.Quadratic.Out)
    }
    t.onComplete.add(()=> {text.text = newText;this.selectedViolation[3] = nextStep;})
    return t;
  }

  playBug(): void {
    let [err, text, idx, curStep] = this.selectedViolation;
    let [buttonSprite, v, trace, traceLayout]: ViolationInfo = this.curViolations[idx];
    let bug = err.children[0];
    let oldT: Phaser.Tween = null;
    let first: Phaser.Tween = null;
    let t, last: Phaser.Tween;

    if (curStep == traceLayout.length-1) {
      this.positionBug(0);
      curStep = 0;
    }

    for (let i = curStep; i < traceLayout.length-1; i++) {
      t = this.getBugTween(err, traceLayout, i, true);

      t.onComplete.add((obj: any, tw: Phaser.Tween) => {
        if (this.animationStopRequested) {
          this.animationStopRequested = false;
          tw.chainedTween = null;
        }
      });

      if (oldT == null) {
        first = oldT = t;
      } else {
        oldT.chain(t);
        oldT = t;
      }
    }
    last = t;
    last.onComplete.add(()=>{this._controlsStopped()});
    first.start();
  }

  stepForward(): void {
    let [err, text, idx, curStep] = this.selectedViolation;
    let [buttonSprite, v, trace, traceLayout]: ViolationInfo = this.curViolations[idx];
    if (curStep >= traceLayout.length-1) {
      this.positionBug(0);
      curStep = 0;
    }
    let traceStep: number = traceLayout[curStep][0];
    this.getBugTween(err, traceLayout, curStep, true).start();
  }

  stepBackwards(): void {
    let [err, text, idx, curStep] = this.selectedViolation;
    let [buttonSprite, v, trace, traceLayout]: ViolationInfo = this.curViolations[idx];

    if (curStep <= 0)  {
      this.positionBug(traceLayout.length-1);
      curStep = traceLayout.length-1;
    }
    let traceStep: number = traceLayout[curStep][0];
    let nextTraceStep: number = traceLayout[curStep-1][0];
    this.getBugTween(err, traceLayout, curStep, false).start();
  }

  preload: any = () => {
    this.game.stage.backgroundColor = "#ffffff";
    this.game.load.image('bug', 'img/ladybug.png');
  }

  update: any = () => {
  }

  drawEdge(g: Phaser.Graphics, path: Path, fill?: number): void {
    if (fill === undefined) {
      fill = 0xffd900;
    }
    g.lineStyle(2, fill, 1);
    for (var i in path) {
      if (i == "0") {
        g.moveTo(path[i].x, path[i].y);
      } else {
        g.lineTo(path[i].x, path[i].y);
      }
    }
  }

  drawNode(nd: Node, pos: Point, size: number): Phaser.Sprite {
    let style = { font: size + "px Courier New, Courier, monospace", align: "center", fill: "#000000" }
    let text: string;
    if (nd instanceof AssignNode) {
      style.fill = "#000000";
      text = nd.stmts.join("\n");
    } else if (nd instanceof ExprNode) {
      text = nd.expr
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
      body.inputEnabled = true;
      body.events.onInputDown.add(() => { this.select(nd); }, this);
    }
    return body
  }

  getFaultyNode(t: Trace): UserNode {
    // Every counter-example trace either begins or ends (or both) at a UserNode
    let start: UserNode = (t[0][0] instanceof UserNode ? t[0][0] as UserNode: null);
    let end: UserNode = (t[t.length-1][0] instanceof UserNode ? t[t.length-1][0] as UserNode: null);
    assert (start !== null || end !== null);
    return (start !== null ? start : end);
  }

  getInvNetwork(): InvNetwork {
    // Extract the candidate invariant network from the game level
    let invNet: InvNetwork = {};
    for (let nd of this.userNodes) {
      assert(nd.successors.length == 1 &&
        nd.successors[0] instanceof IfNode);
      let bbLbl = nd.label;
      invNet[bbLbl] = [parse(nd.expr)];
    }
    return invNet;
  }

  rightOf(n: Node): Point {
    // Get the point left of n in the current layout
    let sp = this.nodeSprites[n.id];
    return Point.add(this.pos[n.id], new Point(sp.width, sp.height/2));
  }

  under(n: Node): Point {
    // Get the point under n in the current layout
    let sp = this.nodeSprites[n.id];
    return Point.add(this.pos[n.id], new Point(sp.width/2, sp.height));
  }

  above(n: Node): Point {
    // Get the point above n in the current layout
    let sp = this.nodeSprites[n.id];
    return Point.add(this.pos[n.id], new Point(sp.width/2, 0));
  }

  checkInvs: any = (invs: InvNetwork, onDone: ()=>void) => {
    rpc_checkSoundness("unsolved-new-benchmarks2", "i-sqrt", invs, (res) => {
      // TODO: Disable clicks
      let curLayout: Layout = [this.nodeSprites, this.pos, this.edges, this.edgeStates];
      let newStates: EdgeStates = mapMap2(this.edgeStates, (x: EdgeState):EdgeState=>"good");
      if (res.length == 0) {
        // Yay win!
        console.log("YAY");
      } else {
        console.log("Got", res.length, "violations:", res);
        if (this.selectedViolation != null) this.hideViolation();
        for (let v of this.curViolations) {
          this.putSprite(v[0])
        }
        this.curViolations = [];
        // For each consecutive trace elements, figure out what edges in the game
        // are affected.
        for (let v of res) {
          let trace = this.getTrace(v);
          for (let i = 0; i < trace.length-1; i++) {
            let [node, stmtIdx, vals]: TraceElement = trace[i];
            let [nextNode, nextStmtIdx, nextVals]: TraceElement = trace[i+1];

            if (node == nextNode) continue;
            let leg = path(node, nextNode);

            for (let j = 0; j < leg.length-1; j++) {
              let legN = leg[j], legN1 = leg[j+1];
              newStates[legN.id][legN1.id] = "fail"
            }
          }
          let blamed = this.getFaultyNode(trace);
          let bugPos = this.rightOf(blamed).add(10 + this.curViolations.length * 40, 0);
          let bug = this.getSprite("bug", bugPos.x, bugPos.y, true)
          let traceLayout = this.layoutTrace(trace);

          bug.inputEnabled = true;
          bug.events.onInputDown.removeAll();
          let idx = this.curViolations.length;
          let cbFactory = (idx: number) => (() => { this.showViolation(idx); });
          bug.events.onInputDown.add(cbFactory(idx), this);

          this.curViolations.push([bug, v, trace, traceLayout]);
        }
      }
      let newLayout: Layout = [this.nodeSprites, this.pos, this.edges, newStates];
      this.updateLayout(curLayout, newLayout, onDone);
    });
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
    this.checkInvs(invNet, ()=> {
      let curLayout: Layout = [this.nodeSprites, this.pos, this.edges, this.edgeStates];
      let newSprites: EdgeStates = copyMap(this.nodeSprites);
      newSprites[this.selected.id] = this.drawNode(this.selected, new Point(800, 600), 15)
      let newLayout: Layout = [newSprites, this.pos, this.edges, this.edgeStates];
      this.updateLayout(curLayout, newLayout, ()=>{});
    });
  }

  getTrace(v: Violation): Trace {
    // Extract a Trace from a violation
    let bbLabels: string[] = v[0];
    let values: any[] = v[1];
    let valArr: Trace = [];
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
    return valArr;
  }

  layoutTrace(t: Trace): TraceLayout {
    // Given a Trace, compute the locations where
    // bugs/text should appear for each step of the trace
    let traceLayout: TraceLayout = [];
    function envToText(v: any) {
      let res = ""
      for (let k in v) {
        res += "" + k + "=" + v[k] + " ";
      }
      return res;
    }

    let stmtCtr = 0;
    for (let i = 1; i < t.length; i++) {
      let [node, stmtIdx, vals] = t[i];
      let sprite = this.nodeSprites[node.id];
      let [prevNode, prevStmtIdx, prevVals] = t[i-1];
      if (node == prevNode ) {
        // Only step through assignments
        if (!(node instanceof AssignNode)) continue;
        let y_step = sprite.height / node.stmts.length;
        let x_pos = sprite.x + sprite.width + 10;
        let pt = new Point(x_pos, sprite.y + y_step * (stmtCtr));
        traceLayout.push([i, pt, envToText(vals)])
        stmtCtr ++;
      } else {
        stmtCtr = 0;
        let subPath: Path = [];
        let leg = path(prevNode, node);

        for (let j = 0; j < leg.length-1; j++) {
          let edgePath: Path = this.edges[leg[j].id][leg[j+1].id];
          subPath = subPath.concat(edgePath);
        }
        traceLayout.push([i-1, subPath, envToText(vals)]);
        traceLayout.push([i, subPath[subPath.length-1], envToText(vals)]);
      }
    }
    return traceLayout;
  }

  create: any = () => {
    let fontSize = 15;
    this.graphics = this.game.add.graphics(0, 0);

    // Build text off-screen
    bfs(this.entry, (p: Node, n: Node) => {
      this.textSprites[n.id] = this.drawNode(n, { x: this.width, y: this.height }, 15);
    }, null);
    // Compute layoutcreate
    let [pos, edges] = this.computeLayout(this.textSprites);
    let edgeStates: StrMap<StrMap<EdgeState>> = {};
    for (let id1 in edges) {
      edgeStates[id1] = {}
      for (let id2 in edges[id1]) {
        edgeStates[id1][id2] = "unknown";
      }
    }
    let newLayout: Layout = [this.textSprites, pos, edges, edgeStates];
    let oldLayout: Layout = [{}, {}, {}, {}];

    // Position sprites
    this.updateLayout(oldLayout, newLayout, ()=> {console.log("Yay I updated")});

    this.edges = edges;
    this.pos = pos;
    this.edgeStates = edgeStates;

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
    this.checkInvs(this.getInvNetwork(), ()=>{});
  }

  computeLayout(spriteMap: SpriteMap): [PointMap, StrMap<PathMap>] {
    let topo: StrMap<number> = topo_sort(this.entry);
    let exitNode: Node = exit(this.entry);
    let width: StrMap<number> = {};
    let ifEndPoints: StrMap<[Node, Node, Node]> = {};
    let h_spacing = 50;
    let backedge_space = 30;
    let relPos: StrMap<[Node, Point]>= {};
    let pos: PointMap = {};
    let edges: StrMap<PathMap> = {};

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
        let rhs_endpoint = single(intersection(new Set(next.predecessors), rhs.reachable()));
        ifEndPoints[next.id] = [exitNode, rhs_endpoint, null];
      } else if (union_nd == rhs) {
        let lhs_endpoint = single(intersection(new Set(next.predecessors), lhs.reachable()));
        ifEndPoints[next.id] = [lhs_endpoint, exitNode, null];
      } else {
        // If node with a union point
        let lhs_endpoint = single(intersection(new Set(union_nd.predecessors), lhs.reachable()));
        let rhs_endpoint = single(intersection(new Set(union_nd.predecessors), rhs.reachable()));
        ifEndPoints[next.id] = [lhs_endpoint, rhs_endpoint, union_nd];
        throw new Error("NYI");
      }
    }

    bfs(this.entry, if_endpoints, null);

    // Pass 2: Compute the widhts for each part of the graph

    function computeWidth(start: Node, end: Node): number {
      let sprite = spriteMap[start.id];
      let sz: Size = { w: sprite.width, h: sprite.height };
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

    // Pass 3: Compute relative positions:
    function compute_rel_pos(prev: Node, next: Node): void {
      let p: Point;
      let sp = spriteMap[next.id];
      let myWidth = width[next.id];

      if (prev == null) {
        p = { x: -sp.width/2, y: 0};
      } else {
        let prevSp = spriteMap[prev.id];
        let rel_y = prevSp.height + h_spacing;
        if (prev instanceof IfNode) {
          if (next == prev.successors[0]) {
            // Lhs
            p = { x: -width[next.id]/2-sp.width/2+prevSp.width/2, y: rel_y };
          } else {
            // Rhs
            p = { x: width[next.id]/2-sp.width/2+prevSp.width/2, y: rel_y };
          }
        } else {
          p = { x: prevSp.width/2-sp.width/2, y: rel_y }
        }
      }

      relPos[next.id] = [prev, p];
    }
    bfs(this.entry, compute_rel_pos, null);

    let final_size: StrMap<Size> = {}
    for(let id in spriteMap) {
      final_size[id] = { w: width[id], h: spriteMap[id].height };
    }

    // Gather user nodes
    bfs(this.entry, (p: Node, n: Node) => {
      if (n instanceof UserNode) {
        this.userNodes.push(n);
      }
    }, null)

    // Compute absolute positions
    bfs(this.entry, (prev: Node, next: Node): void => {
      let [dummy, relp] = relPos[next.id];
      assert(dummy == prev);
      let prevP;
      let p: Point;

      if (prev == null) {
        assert(next == this.entry);
        let w = final_size[next.id].w/2;
        p = new Point(300, 0);
      } else {
        prevP = pos[prev.id];
        p = Point.add(prevP, relp);
      }

      pos[next.id] = p;
    }, null);

    // Compute paths
    function computeForwardEdge(prev: Node, next: Node) {
      // Forward edges are always vertical
      if (prev == null) return;
      let prevSprite = spriteMap[prev.id];
      let nextSprite = spriteMap[next.id];

      let start: Point = Point.add(pos[prev.id], new Point(prevSprite.width/2, prevSprite.height + bugHeight/2));
      let end: Point = Point.add(pos[next.id], new Point(nextSprite.width/2, -bugHeight/2));

      if (!(prev.id in edges)) {
        edges[prev.id] = {};
      }
      edges[prev.id][next.id] = [start, end];
    }

    function computeBackedge(prev: Node, next: Node) {
      // Backwards edges always consist of 3 lines - left, up, right
      let path : Path;
      let fromP: Point = pos[prev.id];
      let toP: Point = pos[next.id];
      let fromSprite = spriteMap[prev.id];
      let toSprite = spriteMap[next.id];
      let fromS: Size = { w: fromSprite.width, h: fromSprite.height };
      let toS: Size = { w: toSprite.width, h: toSprite.height };

      let toBlockS: Size = final_size[next.successors[0].successors[0].id];
      let start = Point.add(fromP, new Point(-bugWidth/2, fromS.h/2));
      let j1: Point = {x: toP.x - toBlockS.w,  y: start.y};
      let j2: Point = {x: j1.x,  y: (toP.y + toS.h/2)};
      let end: Point = {x: toP.x - bugWidth/2,  y: (toP.y + toS.h/2)};
      if (!(prev.id in edges)) {
        edges[prev.id] = {};
      }
      edges[prev.id][next.id] = [start, j1, j2, end];
    }

    bfs(this.entry, computeForwardEdge, computeBackedge);

    return [pos, edges];
  }
}

$(document).ready(function() {

  rpc_loadLvlBasic("unsolved-new-benchmarks2", "i-sqrt", (lvl) => {
    let fun = Fun.from_json(lvl[1]);
    let [graph_entry, mapping] = buildGraph(fun);
    [graph_entry, mapping] = removeEmptyNodes(graph_entry, mapping);
    let game = new SimpleGame(graph_entry, mapping, fun);
  })
})