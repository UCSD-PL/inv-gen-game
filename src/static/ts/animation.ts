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

  constructor(total: number) {
    super();
    this._current = -1;
    this._total = total;
    this._doneCb = [];
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
  protected resetCtr(): void { this._current = 0; };
  protected disableCtr(): void { this._current = -1; };
  protected total(): number { return this._total; }
  protected current(): number { return this._current; }
  public onDone(cb: ()=> any): void { this._doneCb.push(cb); }

  playing(): boolean {
    return this.current() >= 0 && this.current() < this.total();
  }

}

export class AnimationSequence extends FiniteAnimation {
  animations: FiniteAnimation[];

  constructor(anims: FiniteAnimation[]) {
    super(anims.length);
    assert(anims.length > 0);
    this.animations = anims;
  }

  tick() {
    assert(this.playing());
    let cur = this.current();
    if (this.animations[cur].playing()) {
      this.animations[cur].tick();
    } else {
      this.bumpCtr();
      if (cur < this.animations.length) {
        this.animations[cur].start();
      }
    }
  }

  start(): void {
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

  tick() {
    assert(this.playing());
    let cur = this.current(), total = this.total();
    this.thing.x = Phaser.Math.linearInterpolation(this.xPoints, (cur+1)/total);
    this.thing.y = Phaser.Math.linearInterpolation(this.yPoints, (cur+1)/total);
    this.bumpCtr();
  }

  start(): void {
    this.resetCtr();
    this.thing.x = this.xPoints[0];
    this.thing.y = this.yPoints[0];
  }
}

