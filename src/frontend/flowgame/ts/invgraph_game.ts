import {Fun, BB} from "./boogie";
import {parse} from "esprima"
import {Node as ESNode} from "estree";
import * as Phaser from "phaser-ce"
import {Point} from "phaser-ce";
import {topo_sort, bfs, path} from "./graph";
import {Expr_T} from "./boogie";
import {StrMap, assert, max, intersection, single, diff, diff2,
        union2, copyMap2, copyMap, difference2, reversed, structEq,
        repeat, min_cmp} from "../../ts/util"
import {Node, AssignNode, IfNode, AssumeNode, UserNode,
        AssertNode, exit, NodeMap, PlaceholderNode} from "./game_graph"
import {LineOptions, TextIcon} from "./texticon"

export type InvNetwork = StrMap<ESNode[]>;
export type Violation = any[];
type SpriteMap = StrMap<TextIcon>;
type PointMap = StrMap<Point>;
type Path = Point[];
type PathMap = StrMap<Point[]>;
type EdgeMap = StrMap<StrMap<Path>>
type EdgeState = "unknown" | "good" | "fail"
type EdgeStates = StrMap<StrMap<EdgeState>>
type Layout = [SpriteMap, PointMap, EdgeMap, EdgeStates];
type Color = number;

export type TraceElement = [Node, number, any];
export type Trace = TraceElement[]
export type TraceLayoutStep =[number, (Point | Point[]), string]
export type TraceLayout = TraceLayoutStep[]

interface Size {
  w: number;
  h: number;
}

export class PlaceholderIcon extends TextIcon {
    constructor(game: InvGraphGame, nd: PlaceholderNode, x?: number, y?: number) {
      super(game.game, game.getSprite("placeholder", 0, 0, true), "", "plchldr_" + nd.id, x, y);
    }
    public entryPoint(): Phaser.Point {
        return new Phaser.Point(
            this._icon.x + this._icon.width/2,
            this._icon.y
        )
    }
    public exitPoint(): Phaser.Point {
        return new Phaser.Point(
            this._icon.x + this._icon.width/2,
            this._icon.y + this._icon.height
        )
    }

    // public setText(s: string) {
    //   assert(false, "Can't change text on placeholders")
    // }
}

export class SourceIcon extends TextIcon {
    constructor(game: InvGraphGame, nd: AssumeNode, x?: number, y?: number, startShown?: boolean) {
      super(game.game, game.getSprite("source", 0, 0, true), nd.exprs, "src_" + nd.id, x, y, startShown);
    }
    public exitPoint(): Phaser.Point {
        return new Phaser.Point(
            this._icon.x + this._icon.width/2,
            this._icon.y + this._icon.height
        )
    }
}

export class SinkIcon extends TextIcon {
    constructor(game: InvGraphGame, nd: AssertNode, x?: number, y?: number, editable = false, startShown?: boolean) {
      super(game.game, game.getSprite("sink", 0, 0, true), nd.exprs, "sink_" + nd.id, x, y, startShown);
    }
    public entryPoint(): Phaser.Point {
        return new Phaser.Point(
            this._icon.x + this._icon.width/2,
            this._icon.y
        )
    }
}

export class BranchIcon extends TextIcon {
    constructor(game: InvGraphGame, nd: AssertNode, x?: number, y?: number, startShown?: boolean) {
      super(game.game, game.getSprite("branch", 0, 0, true), nd.exprs, "br_" + nd.id, x, y, startShown);
    }
    public entryPoint(): Phaser.Point {
        return new Phaser.Point(
            this._icon.x + this._icon.width/2,
            this._icon.y
        )
    }
    public lhsExitPoint(): Phaser.Point {
        return new Phaser.Point(
            this._icon.x + this._icon.width/4,
            this._icon.y + this._icon.height
        )
    }

    public rhsExitPoint(): Phaser.Point {
        return new Phaser.Point(
            this._icon.x + 3*this._icon.width/4,
            this._icon.y + this._icon.height
        )
    }
}

export class InputOutputIcon extends TextIcon {
  protected unsound: Expr_T[];
  protected sound: Expr_T[];

    // Code duplication with OutputIcon - don't want to implement mixins just
    // for this one case
    constructor(game: InvGraphGame, nd: UserNode, x?: number, y?: number, startShown?: boolean) {
      super(game.game, game.getSprite("funnel", 0, 0, true), [], "un_" + nd.id, x, y, startShown);
      this.setInvariants(nd.sound, nd.unsound);
    }
    public entryPoint(): Phaser.Point {
        return new Phaser.Point(
            this._icon.x + 19,
            this._icon.y
        )
    }

    public exitPoint(): Phaser.Point {
        return new Phaser.Point(
            this._icon.x + 54,
            this._icon.y + this._icon.height
        )
    }

    setInvariants(sound: Expr_T[], unsound: Expr_T[]): void {
      this.sound = sound;
      this.unsound = unsound;

      let allInvs: Expr_T[] = unsound.concat(sound);
      let good: LineOptions = {
              style: { font: "15px Courier New, Courier, monospace", align: "center", fill: "#00ff00", backgroundColor: "#ffffff" },
              visible: true,
      }
      let bad: LineOptions = {
              style: { font: "15px Courier New, Courier, monospace", align: "center", fill: "#ff0000", backgroundColor: "#ffffff" },
              visible: true,
      }
      let allOpts: LineOptions[] = repeat(bad, unsound.length).concat(repeat(good, sound.length))
      this.setText(allInvs, allOpts)
    }
}

export class TransformerIcon extends TextIcon {
    // Code duplication with OutputIcon - don't want to implement mixins just
    // for this one case
    constructor(game: InvGraphGame, nd: AssignNode, x?: number, y?: number, startShown?: boolean) {
      let text = nd.stmts.join("\n");
      super(game.game, game.getSprite("gearbox", 0, 0, true), text, "tr_" + nd.id, x, y, startShown);
      this.icon().inputEnabled = true;
      this.icon().events.onInputDown.add(() => {
        game.transformLayout(() => this.toggleText());
      }, this);
      this.icon().input.useHandCursor = true;
    }
    public entryPoint(): Phaser.Point {
        return new Phaser.Point(
            this._icon.x + this._icon.width/2,
            this._icon.y
        )
    }
    public exitPoint(): Phaser.Point {
        return new Phaser.Point(
            this._icon.x + this._icon.width/2,
            this._icon.y + this._icon.height
        )
    }
}

function getEntry(ti: TextIcon): Phaser.Point {
  if (ti instanceof SinkIcon ||
      ti instanceof BranchIcon ||
      ti instanceof TransformerIcon ||
      ti instanceof PlaceholderIcon ||
      ti instanceof InputOutputIcon) {
    return ti.entryPoint();
  }
  assert(false, "Node [" + ti.getText() + "] doesn't have an entry point.")
}

function getExit(ti: TextIcon): Phaser.Point {
  if (ti instanceof SourceIcon ||
      ti instanceof TransformerIcon ||
      ti instanceof PlaceholderIcon ||
      ti instanceof InputOutputIcon) {
    return ti.exitPoint();
  }
  assert(false, "Node [" + ti.getText() + "] doesn't have an exit point.")
}

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

type SpritePool = StrMap<Set<Phaser.Sprite>>;
type ViolationInfo = [Violation, Trace][];

export class InvGraphGame {
  protected entry: Node;
  protected userNodes: UserNode[];
  protected bbToNode: NodeMap;
  protected f: Fun;
  protected width: number;
  protected height: number;
  protected textSprites: SpriteMap;
  protected nodeSprites: SpriteMap;
  protected edges: StrMap<StrMap<Path>>;
  protected edgeStates: EdgeStates;
  protected pos: PointMap;
  protected graphics: Phaser.Graphics;
  protected curViolations: ViolationInfo;
  protected spritePool: SpritePool;
  protected selectedViolation: [TextIcon, number, Trace, TraceLayout];
  protected animationStopRequested: boolean;
  protected lvlId: string;
  protected stepPlaying: boolean;
  game: Phaser.Game;

  constructor(container: string, width: number, height: number, graph: Node, n: NodeMap, lvlId: string) {
    this.width = width;
    this.height = height;
    this.game = new Phaser.Game(this.width, this.height, Phaser.AUTO, container,
      { preload: ()=>{this.preload()},
        create: ()=>{this.create()},
        update: ()=>{this.update()}
      });
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
    this.selectedViolation = null;
    this.stepPlaying = false;
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
      // Ask Dimo about this: seems to me like the following line 
      // should not be there
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
    this.spritePool[key as string].add(s);
  }

  transformLayout(modifier: ()=>any, onDone?: ()=>any): void {
    // Apply modifier to change the visual layout (not adding/removing sprites),
    // compute the new layout, and run the animations to transition
    let oldLayout: Layout = [copyMap(this.nodeSprites), copyMap(this.pos), copyMap2(this.edges), copyMap2(this.edgeStates)];
    modifier();
    let [newPos, newEdges] = this.computeLayout(this.nodeSprites);
    let newLayout: Layout = [this.nodeSprites, newPos, newEdges, this.edgeStates];
    this.updateLayout(oldLayout, newLayout, onDone);
  }

  private updateLayout(oldL: Layout, newL: Layout, onUpdate?: ()=>any): void {
    let shouldShowViolation: boolean = false;
    if (this.selectedViolation != null) {
      this.hideViolation(); // TODO: Show violation afterwards
      shouldShowViolation = true;
    }
    let [oldSpr, oldPos, oldEdges, oldEdgeState] = oldL;
    let [newSpr, newPos, newEdges, newEdgeState] = newL;
    let eraseEdges: Set<[string, string]>;
    let repaintEdges: Set<[string, string]>;
    // Todo: Better to render paths to textures and show them like that?

    // Compute sprites to disappear and edges that need removal/repaint
    let [removedSprites, changedSprites, addedSprites] = diff(oldSpr, newSpr);
    let [dummy3, movedSprites, dummy4] = diff(oldPos, newPos);
    let [removedEdges, changedEdges, addedEdges] = diff2(oldEdges, newEdges, structEq);
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
      s.setPos(newPos[id]);
      hello.add(s);
    }

    // Compute animations for sprites that need to move
    // TODO: fix this code when sprites change shape
    let moveTweens: Phaser.Tween[] = [];
    for (let id1 of movedSprites) {
      let moveTw = this.game.add.tween(oldSpr[id1]);
      moveTw.to({ x: newPos[id1].x, y: newPos[id1].y }, 250, Phaser.Easing.Quadratic.Out);
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
        byeAnim.to({alpha: 0}, 250, Phaser.Easing.Quadratic.Out);
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
        helloAnim.to({alpha: 1}, 250, Phaser.Easing.Quadratic.Out);
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
      if (shouldShowViolation) {
        let trace: Trace = this.curViolations[0][1];
        let traceLayout = this.layoutTrace(trace);
        this.showViolation(traceLayout, trace)
      }
      if (onUpdate !== undefined) {
        onUpdate();
      }
    }) }); });
  }

  hideViolation(): void {
    assert (this.selectedViolation != null)
    let [err, step, trace, traceLayout] = this.selectedViolation;
    let icon = err.icon();
    (err as Phaser.Group).remove(icon);
    this.game.add.existing(icon);
    this.putSprite(icon);
    (err as Phaser.Group).destroy(true);
    this.selectedViolation = null;
  }

  showViolation(traceLayout: TraceLayout, trace: Trace): void {
    if (this.selectedViolation != null) {
      this.hideViolation();
    }
    let [dummy, startPoint, startText] = traceLayout[0];
    let orb = this.getSprite("orb", 0, 0);
    orb.scale.setTo(0.3);
    let err = new TextIcon(this.game, orb, "", "cur_trace_bug", 0, 0, true, true);
    this.selectedViolation = [err, 0, trace, traceLayout];
    this.positionBug(0);
    let icon = err.icon();
    icon.inputEnabled = true;
    icon.exists = true;
  }

  private positionBug(step: number) {
    // Set the position and text of the bug to correspond with given step in the
    // trace If that step is traveling along edge paths, place it at start of
    // that path.
    let [err, curStep, trace, traceLayout] = this.selectedViolation;

    let [dummy, pos, newText]: TraceLayoutStep = traceLayout[step];
    let finalPos: Point;
    if (pos instanceof Point) {
      finalPos = pos;
    } else {
      finalPos = pos[0];
    }
    err.setPos(finalPos.x, finalPos.y)
    err.setText(newText)
    this.selectedViolation[1] = step;
  }

  private getBugTween(err: TextIcon,
                      traceLayout: TraceLayout, curStep: number, forward: boolean): Phaser.Tween {
    // Compute the animation to move the bug one step forward/backward from its current step.
    let inc: number = (forward ? 1 : -1);
    let t: Phaser.Tween = this.game.add.tween(err);
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
      t.to({x:pt.x, y:pt.y}, 500, Phaser.Easing.Quadratic.Out)
    }
    t.onStart.add(() => {this.stepPlaying = true;})
    t.onComplete.add(()=> {err.setText(newText);this.selectedViolation[1] = nextStep; this.stepPlaying = false; })
    return t;
  }

  playBug(onComplete?: ()=>any): void {
    let [err, curStep, trace, traceLayout] = this.selectedViolation;
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
          let rest = tw.chainedTween;
          tw.chainedTween = null;
          // Cleanup remaining tweens
          while (rest != null) {
            rest.manager.remove(rest);
            rest = rest.chainedTween;
          }
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
    if (onComplete != undefined) {
      last.onComplete.add(onComplete);
    }
    first.start();
  }

  stepForward(): void {
    let [err, curStep, trace, traceLayout] = this.selectedViolation;
    if (curStep >= traceLayout.length-1) {
      this.positionBug(0);
      curStep = 0;
    }
    let traceStep: number = traceLayout[curStep][0];
    this.getBugTween(err, traceLayout, curStep, true).start();
  }

  stepBackwards(): void {
    let [err, curStep, trace, traceLayout] = this.selectedViolation;

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
    this.game.load.image('bug', '/game/flowgame/img/ladybug.png');
    this.game.load.image('source', '/game/flowgame/img/source_small.png');
    this.game.load.image('sink', '/game/flowgame/img/sink_small.png');
    this.game.load.image('gearbox', '/game/flowgame/img/gearbox_small.png');
    this.game.load.image('funnel', '/game/flowgame/img/funnel_small.png');
    this.game.load.image('funnel_selected', '/game/flowgame/img/funnel_small_selected.png');
    this.game.load.image('branch', '/game/flowgame/img/branch_small.png');
    this.game.load.image('placeholder', '/game/flowgame/img/placeholder_small.png');
    this.game.load.image('orb', '/game/flowgame/img/orb.png');
    this.game.load.image('whitespace', '/game/flowgame/img/white_space.png');
  //  this.game.load.spritesheet('explosion', '/game/flowgame/img/explosion160x120.png', 160, 120, 90);
    this.game.load.spritesheet('arrow_right', '/game/flowgame/img/arrow_right_sheet.png', 28, 21, 20);
    this.game.load.spritesheet('arrow_left', '/game/flowgame/img/arrow_left_sheet.png', 28, 21, 20);

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

  drawNode(nd: Node, pos: Point): TextIcon {
    if (nd instanceof AssumeNode) {
      return new SourceIcon(this, nd, pos.x, pos.y, true);
    } else if (nd instanceof AssertNode) {
      return new SinkIcon(this, nd, pos.x, pos.y, true, true);
    } else if (nd instanceof AssignNode) {
      return new TransformerIcon(this, nd, pos.x, pos.y, false);
    } else if (nd instanceof IfNode) {
      return new BranchIcon(this, nd, pos.x, pos.y, true);
    } else if (nd instanceof UserNode) {
      return new InputOutputIcon(this, nd, pos.x, pos.y, true);
    } else if (nd instanceof PlaceholderNode) {
      return new PlaceholderIcon(this, nd, pos.x, pos.y);
    } else {
      throw new Error("NYI" + nd);
    }
  }

  getFaultyNode(t: Trace): Node {
    let start = t[0][0];
    let end = t[t.length-1][0];
    return (end instanceof UserNode ? end : start);
  }

  getInvNetwork(): InvNetwork {
    // Extract the candidate invariant network from the game level
    let invNet: InvNetwork = {};
    for (let nd of this.userNodes) {
      assert(nd.successors.length == 1 &&
        nd.successors[0] instanceof IfNode);
      let bbLbl = nd.label;
      let invs = nd.sound.concat(nd.unsound)
      invNet[bbLbl] = invs.length == 0 ? [parse("false")] : invs.map((expr) => parse(expr));
    }
    return invNet;
  }

  rightOf(n: Node): Point {
    // Get the point left of n in the current layout
    let sp = this.nodeSprites[n.id];
    return Point.add(this.pos[n.id], new Point(sp.getWidth(), 0));
  }

  under(n: Node): Point {
    // Get the point under n in the current layout
    let sp = this.nodeSprites[n.id];
    return Point.add(this.pos[n.id], new Point(0, sp.getHeight()/2));
  }

  above(n: Node): Point {
    // Get the point above n in the current layout
    let sp = this.nodeSprites[n.id];
    return Point.add(this.pos[n.id], new Point(0, -sp.getHeight()/2));
  }

  earilestViolation(vs: Violation[]): Violation {
    // Find the violation v out of vs, that is closest to the start of the
    // function. We do this by sorting all violations lexicographically based on the
    // bfs traversal order of their start and end nodes.
    let nodeIdx: StrMap<number> = {};
    let nodes: Node[] = [];
    bfs(this.entry, (prev: Node, cur: Node) => {
      if (prev == null) {
        nodeIdx[cur.id] = 0;
      } else {
        nodeIdx[cur.id] = nodeIdx[prev.id] + 1;
      }
      nodes.push(cur);
    })
    let violationKey = (v: Violation): [number, number] => {
      let t = this.getTrace(v);
      let endpoints: [Node, Node] = [t[0][0], t[t.length-1][0]];
      return [nodeIdx[endpoints[0].id], nodeIdx[endpoints[1].id]];
    }
    return min_cmp(vs, (a: Violation, b: Violation) => violationKey(a) < violationKey(b));
  }

  setViolations(vs: Violation[], onDone: ()=>any): void {
    if (this.selectedViolation != null) this.hideViolation();
    this.curViolations = [];
    if (vs.length > 0) {
      vs = [this.earilestViolation(vs)];
      console.log("Out of ", vs.length, " violations(", vs, "picking earilest violation: ", this.earilestViolation(vs));
    }
    this.transformLayout(() => {
      for (let e1 in this.edgeStates) {
        for (let e2 in this.edgeStates[e1]) {
          this.edgeStates[e1][e2] = "good";
        }
      }

      for (let v of vs) {
        let trace = this.getTrace(v);
        for (let i = 0; i < trace.length-1; i++) {
          let [node, stmtIdx, vals]: TraceElement = trace[i];
          let [nextNode, nextStmtIdx, nextVals]: TraceElement = trace[i+1];

          if (node == nextNode) continue;
          let leg = path(node, nextNode);

          for (let j = 0; j < leg.length-1; j++) {
            let legN = leg[j], legN1 = leg[j+1];
            this.edgeStates[legN.id][legN1.id] = "fail"
          }
        }
        this.curViolations.push([v, trace]);
      }
    }, ()=> {
      if (vs.length > 0) {
        assert(vs.length == 1);
        let trace = this.getTrace(vs[0]);
        let traceLayout = this.layoutTrace(trace);
        this.showViolation(traceLayout, trace);
      }
      onDone();
    });
  }

  getTrace(v: Violation): Trace {
    // Extract a Trace from a violation
    let bbLabels: string[] = v[0];
    let values: any[] = v[1];
    let valArr: Trace = [];
    let prevNode: Node;
    let prevVal: any;
    for (let i = 0; i < values.length; i++) {
      let lbl = bbLabels[i];

      if (values[i].length == 0) {
        valArr.push([this.bbToNode[lbl][0], 0, valArr[valArr.length-1][2]]);
      }

      for (let j = 0; j < values[i].length; j++) {
        let node: Node = (j > 0 ? this.bbToNode[lbl][j-1] : this.bbToNode[lbl][0]);
        assert(lbl in this.bbToNode, "Label " + lbl + " missing.");
        assert(j <= this.bbToNode[lbl].length, "Too many values: " + j + " for " + lbl);

        if (prevNode !== undefined && prevNode != node && j != 0) {
          // Block split due to assume
          valArr.push([node, j-1, prevVal]);
        }

        if (node instanceof AssignNode) {
          valArr.push([node, j-1, values[i][j]]);
        } else {
          if (j == 0) {
            valArr.push([node, j-1, values[i][j]]);
          } else {
            let [n1, d, v] = valArr[valArr.length-1];
            assert(n1 === node);
            //TODO: This is broken. Fix and uncomment
            //assert(structEq(v, values[i][j]));
          }
        }
        prevNode = node;
        prevVal = values[i][j];
      }
    }
    return valArr;
  }

  layoutTrace(t: Trace): TraceLayout {
    // Given a Trace, compute the locations where
    // bugs/text should appear for each step of the trace
    let traceLayout: TraceLayout = [];
    let var_names = [];
    for (let i = 1; i < t.length; i++) {
      let [node, stmtIdx, vals] = t[i];
      for (let k in vals) {
        if (var_names.indexOf(k) == -1) {
          var_names.push(k);
        }
      }
    }
    function envToText(v: any) {
      let res = "";
      for (let i = 0; i < var_names.length; i++) {
        let k = var_names[i];
        if (k in v) {
          res += "" + k + ":" + v[k] + " ";
        }
      }
      return res;
    }
    
    let stmtCtr = 0;
    for (let i = 1; i < t.length; i++) {
      let [node, stmtIdx, vals] = t[i];
      let sprite: TextIcon = this.nodeSprites[node.id];
      let [prevNode, prevStmtIdx, prevVals] = t[i-1];
      if (node == prevNode) {
        // Only step through assignments
        if (!(node instanceof AssignNode) || !sprite.isLineShown(0)) continue;
        let textNode: Phaser.Group = sprite.getText();
        let textPos: Phaser.Point = new Point(sprite.getX() + textNode.x, sprite.getY() + textNode.y)
        let pt = sprite.rightOfLine(stmtCtr).add(textPos.x + 10, textPos.y)
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

        subPath[0].add(0, 10);
        subPath[subPath.length-1].add(0, -10);

        traceLayout.push([i-1, subPath, envToText(vals)]);
        traceLayout.push([i, subPath[subPath.length-1], envToText(vals)]);
      }
    }
    return traceLayout;
  }

  create_core(): void {
    // Build text off-screen
    bfs(this.entry, (p: Node, n: Node) => {
      this.textSprites[n.id] = this.drawNode(n, new Point(this.width, this.height));
    }, null);
    // Compute layout
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
    this.updateLayout(oldLayout, newLayout, ()=> this.onFirstUpdate());
  }

  create(): void {
    this.graphics = this.game.add.graphics(0, 0);
    this.create_core();
    let up: Phaser.Key = this.game.input.keyboard.addKey(38);
    let down: Phaser.Key = this.game.input.keyboard.addKey(40);
    up.onDown.add(() => {
      if (this.selectedViolation != null) {
        this.stepBackwards();
      }
    })
    down.onDown.add(() => {
      if (this.selectedViolation != null) {
        this.stepForward();
      }
    })
  }

  onFirstUpdate(): void {
    console.log("Yay my first update!")
  }

  computeLayout(spriteMap: SpriteMap): [PointMap, StrMap<PathMap>] {
    let topo: StrMap<number> = topo_sort(this.entry);
    let exitNode: Node = exit(this.entry);
    let width: StrMap<number> = {};
    let bboxPos: StrMap<Point> = {};
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
      let loop_endpoint = (if_node: Node, child: Node): Node => {
        let pred = single(intersection(new Set(if_node.predecessors), child.reachable()));
        return single(intersection(new Set(pred.predecessors), child.reachable()));
      }

      if (union_nd == lhs) {
        let rhs_endpoint = loop_endpoint(next, rhs);
        ifEndPoints[next.id] = [exitNode, rhs_endpoint, null];
      } else if (union_nd == rhs) {
        let lhs_endpoint = loop_endpoint(next, lhs);
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

    // Pass 2: Compute the widths for each part of the graph
    function computeWidth(start: Node, end: Node): number {
      let sprite = spriteMap[start.id];
      assert(sprite != null && sprite instanceof TextIcon);
      let sz: Size = { w: sprite.getWidth(), h: sprite.getHeight() };
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
            console.log(start.id, sz.w, lhs_width, rhs_width, lhs_width+rhs_width, bboxPos[start.id]);
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
    console.log("Widths: ", width);

    // Pass 3: Compute relative positions:
    function compute_rel_pos(prev: Node, next: Node): void {
      let p: Point;
      let sp = spriteMap[next.id];
      let myWidth = width[next.id];

      if (prev == null) {
        p = new Point(-sp.getWidth()/2, 0);
      } else {
        let prevSp: TextIcon = spriteMap[prev.id];
        let rel_y = prevSp.getHeight() + h_spacing;
        let prevExit: Point;
        let myEntry: Point = getEntry(sp);

        if (prev instanceof IfNode) {
          if (next == prev.successors[0]) {
            // Lhs
            prevExit = (prevSp as BranchIcon).lhsExitPoint()
            prevExit.subtract(width[next.id]/2, 0)
          } else {
            // Rhs
            prevExit = (prevSp as BranchIcon).rhsExitPoint()
            prevExit.add(width[next.id]/2, 0)
          }
        } else {
          prevExit = getExit(prevSp);
        }
        p = Point.subtract(prevExit, myEntry).add(0, h_spacing);
      }

      relPos[next.id] = [prev, p];
    }
    bfs(this.entry, compute_rel_pos, null);
    console.log("Relative positions: ", relPos);

    let final_size: StrMap<Size> = {}
    for(let id in spriteMap) {
      final_size[id] = { w: width[id], h: spriteMap[id].getHeight() };
    }

    console.log("Final sizes: ", final_size);
    // Gather user nodes
    this.userNodes = [];
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
        //let w = final_size[next.id].w/2;
        let w = 120;
        p = new Point(w+10, 40);
        bboxPos[next.id] = new Point(w, 0);
      } else {
        prevP = pos[prev.id];
        p = Point.add(prevP, relp);
      }

      pos[next.id] = p;
    }, null);
    console.log("BBox Pos: ", bboxPos);

    console.log("Absolute positions: ", pos);
    function _getPathStart(from: Node, to: Node): Point {
      let fromSprite: TextIcon = spriteMap[from.id];
      let toSprite = spriteMap[to.id];
      let pathStart: Point;

      if (fromSprite instanceof BranchIcon) {
        if (to == from.successors[0]) {
          pathStart = fromSprite.lhsExitPoint();
        } else {
          pathStart = fromSprite.rhsExitPoint();
        }
      } else {
        pathStart = getExit(fromSprite);
      }
      return Point.add(pathStart, pos[from.id], pathStart);
    }

    function _getPathEnd(from: Node, to: Node): Point {
      let fromSprite: TextIcon = spriteMap[from.id];
      let toSprite = spriteMap[to.id];
      let pathEnd: Point = getEntry(toSprite);
      pathEnd = Point.add(pathEnd, pos[to.id], pathEnd);
      if (to instanceof UserNode && (to as Node).reachable().has(from)) {
        // This is a backedge
        return Point.add(pathEnd, new Point(-5, 0), pathEnd);
      } else {
        return pathEnd;
      }
    }
    // Compute paths
    function computeForwardEdge(prev: Node, next: Node) {
      // Forward edges are always vertical
      if (prev == null) return;
      let prevSprite: TextIcon = spriteMap[prev.id];
      let nextSprite = spriteMap[next.id];
      let start: Point = _getPathStart(prev, next);
      let end: Point = _getPathEnd(prev, next);

      if (!(prev.id in edges)) {
        edges[prev.id] = {};
      }
      edges[prev.id][next.id] = [start, end];
    }

    function computeBackedge(prev: Node, next: Node) {
      // Backwards edges always consist of 5 lines - down, left, up, right, down
      let path : Path;
      let prevSprite: TextIcon = spriteMap[prev.id];
      let nextSprite = spriteMap[next.id];
      let toBlockS: Size = final_size[next.successors[0].successors[0].id];
      let start: Point = _getPathStart(prev, next);
      let end: Point = _getPathEnd(prev, next);
      let j1: Point = Point.add(start, new Point(0, 20));
      let j2: Point = Point.add(j1, new Point(-(prevSprite.icon().width/2+20), 0))
      let j3: Point = new Point(j2.x, end.y-20);
      let j4: Point = new Point(end.x, j3.y);
      if (!(prev.id in edges)) {
        edges[prev.id] = {};
      }
      edges[prev.id][next.id] = [start, j1, j2, j3, j4, end];
    }

    bfs(this.entry, computeForwardEdge, computeBackedge);

    return [pos, edges];
  }
}
