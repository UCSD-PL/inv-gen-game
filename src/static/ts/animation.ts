import {assert} from "./util"
import * as Phaser from "phaser"

export abstract class Animation {
  abstract tick():  void;
  abstract playing(): boolean;
  abstract start(): void;
}

export abstract class FiniteAnimation extends Animation {
  private _current: number;
  private _total: number;
  private _doneCb: (()=>any)[];
  private _startCb: (()=>any)[];

  constructor(total: number) {
    super();
    this._current = -1;
    this._total = total;
    this._doneCb = [];
    this._startCb = [];
  }

  protected decCtr(): void {
    assert(this._current >= 0);
    this._current --;
  }

  protected bumpCtr(): void {
    this._current ++;
    if (this._current >= this._total) {
      this.disableCtr();
      for (let cb of this._doneCb) {
        cb();
      }
    }
  };

  protected jumpCtr(to: number): void {
    assert (to >= 0 && to < this.total());
    this._current = to;
  }

  public resetCtr(): void { this._current = 0; };
  protected disableCtr(): void { this._current = -1; };
  protected total(): number { return this._total; }
  public current(): number { return this._current; }
  public onStart(cb: ()=> any): void { this._startCb.push(cb); }
  public onDone(cb: ()=> any): void { this._doneCb.push(cb); }
  abstract back():  void;
  abstract jumpToEnd():  void;

  playing(): boolean {
    return this.current() >= 0 && this.current() < this.total();
  }

  start() {
    for(let cb of this._startCb) {
      cb();
    }
  }

}

export class AnimationSequence extends FiniteAnimation {
  animations: FiniteAnimation[];

  constructor(anims: FiniteAnimation[]) {
    super(anims.length);
    assert(anims.length > 0);
    this.animations = anims;
  }

  back() {
    let cur = this.current();
    assert(cur >= 0);
    if (this.animations[cur].current() > 0) {
      this.animations[cur].back();
    } else {
      this.decCtr();
      if (cur >= 0) {
        this.animations[cur].jumpToEnd();
      }
    }
  }

  tick() {
    let cur = this.current();
    assert(this.playing());
    if (this.animations[cur].playing()) {
      this.animations[cur].tick();
    } else {
      this.bumpCtr();
      if (this.playing()) {
        this.animations[this.current()].start();
      }
    }
  }

  jumpCtr(to: number) {
    this.jumpCtr(to);
    let curAnim: FiniteAnimation = this.animations[this.current()];
    curAnim.resetCtr();
  }

  jumpToEnd() {
    this.jumpCtr(this.animations.length-1);
    let curAnim: FiniteAnimation = this.animations[this.current()];
    curAnim.jumpToEnd();
  }

  start(): void {
    super.start();
    this.resetCtr();
    this.animations[this.current()].start();
  }
}

export class Move extends FiniteAnimation {
  thing: Phaser.Sprite;
  path: Phaser.Point[];
  xPoints: number[];
  yPoints: number[];
  steps: number;

  constructor(thing: Phaser.Sprite, path: Phaser.Point[], steps?: number) {
    if (steps === undefined) {
      steps = 10;
    }
    super(steps);
    this.thing = thing;
    this.path = path;
    this.xPoints = path.map((p)=>p.x);
    this.yPoints = path.map((p)=>p.y);
  }

  private position(): void {
    let cur = this.current(), total = this.total();
    this.thing.x = Phaser.Math.linearInterpolation(this.xPoints, (cur+1)/total);
    this.thing.y = Phaser.Math.linearInterpolation(this.yPoints, (cur+1)/total);
  }

  tick() {
    assert(this.playing());
    this.position();
    this.bumpCtr();
  }

  back() {
    this.decCtr();
    this.position();
  }

  jumpToEnd() {
    this.jumpCtr(this.total()-1);
    this.position();
  }

  start(): void {
    super.start();
    this.resetCtr();
    this.thing.x = this.xPoints[0];
    this.thing.y = this.yPoints[0];
  }
}

