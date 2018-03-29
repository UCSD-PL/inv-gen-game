import * as Phaser from "phaser"
import {Point} from "phaser";
import {assert} from "./util"

export class TextIcon extends Phaser.Group {
    protected _icon: Phaser.Sprite;
    protected _text: Phaser.Group;
    protected _lines: string[];
    protected _game: Phaser.Game;
    protected _defaultStyle: object;

    constructor(game: Phaser.Game, icon: Phaser.Sprite, text: (string|string[]), name?: string, x?: number, y?:number, startShown?: boolean) {
        super(game, undefined, name, undefined, undefined, undefined);
        if (x == undefined) x = 0;
        if (y == undefined) y = 0;
        if (startShown == undefined) startShown = true;

        this._game = game;
        this._icon = icon;
        this._icon.x = -this._icon.width/2;
        this._icon.y =  -this._icon.height/2;
        let fontSize = 15;
        this._defaultStyle = { font: fontSize + "px Courier New, Courier, monospace", align: "center", fill: "#000000", backgroundColor: "#ffffff" }
        let lines: string[] = ((text instanceof Array) ? text : text.split("\n"));
        this._updateText(lines, startShown)
        super.add(this._icon);
        super.add(this._text);
        super.x = x; super.y = y;
    }

    private _updateText(newLines: string[], show: boolean) {
        let idx = 0;
        if (this._text !== undefined) {
            super.remove(this._text);
        }
        let lineGrp = this._game.add.group();
        lineGrp.exists = false;
        for (let ln of newLines) {
            this._game.add.text(0, lineGrp.height, ln, this._defaultStyle, lineGrp);
            idx++;
        }
        this._text = lineGrp;
        super.add(this._text);
        this._text.y = -this._text.height/2;
        this._text.x = this._icon.width/2 + 5;
        this._text.exists = show;
        this._lines = newLines;
    }

    public getText(): Phaser.Group {
        return this._text;
    }

    public getLine(i: number): Phaser.Text {
        return this._text.children[i];
    }

    public rightOfLine(i: number): Phaser.Point {
        let t = this.getLine(i);
        return new Phaser.Point(t.x, t.y).add(t.width, t.height/2)
    }

    public icon(): Phaser.Sprite {
        return this._icon;
    }

    public setText(s: (string|string[])) {
        let t: string[] = (s instanceof Array ? s : s.split("\n"));
        this._updateText(t, this._text.exists)
    }

    public hideText(): void {
        for (let ln of this._text.children) {
            ln.exists = false;
        }
    }

    public showText(): void {
        for (let ln of this._text.children) {
            ln.exists = false;
        }
    }

    public toggleText(): void {
        for (let ln of this._text.children) {
            ln.exists = !ln.exists;
        }
    }

    public isTextShown():boolean {
        return this._text.children[0].exists;
    }

    public getX(): number { return (this as Phaser.Group).x; }
    public getY(): number { return (this as Phaser.Group).y; }
    public getWidth(): number { return (this as Phaser.Group).width; }
    public getHeight(): number { return (this as Phaser.Group).height; }
    public setPos(x: (number|Phaser.Point), y?: number): void {
        if (x instanceof Phaser.Point) {
            super.x = x.x;
            super.y = x.y;
        } else {
            assert(y !== undefined);
            super.x = x;
            super.y = y;
        }
    }

    protected body(): Phaser.Group {
        return this as Phaser.Group;
    }
}