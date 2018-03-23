import * as Phaser from "phaser"
import {Point} from "phaser";
import {assert} from "./util"

export class TextIcon extends Phaser.Group {
    protected _icon: Phaser.Sprite;
    protected _text: Phaser.Text;

    constructor(game: Phaser.Game, icon: Phaser.Sprite, text: (Phaser.Text|string), name?: string, x?: number, y?:number, startShown?: boolean) {
        super(game, undefined, name, undefined, undefined, undefined);
        if (x == undefined) x = 0;
        if (y == undefined) y = 0;
        if (startShown == undefined) startShown = true;
        this._icon = icon;
        this._icon.x = -this._icon.width/2;
        this._icon.y =  -this._icon.height/2;
        let fontSize = 15;

        if ((text instanceof Phaser.Text)) {
            this._text = text;
            text.x = icon.width + 5;
        } else {
            let style = { font: fontSize + "px Courier New, Courier, monospace", align: "center", fill: "#000000", backgroundColor: "#ffffff" }
            this._text = game.add.text(icon.width/2+5, 0, text, style);
        }
        this._text.y = -this._text.height/2
        this._text.exists = startShown;
        super.add(this._icon);
        super.add(this._text);
        super.x = x; super.y = y;
    }

    public getText(): Phaser.Text {
        return this._text;
    }

    public icon(): Phaser.Sprite {
        return this._icon;
    }

    public setText(s: string) {
        this._text.text = s;
        this._text.y = -this._text.height/2
    }

    public hideText(): void {
        this._text.exists = false;
    }

    public showText(): void {
        this._text.exists = false;
    }

    public toggleText(): void {
        this._text.exists = !this._text.exists;
    }

    public isTextShown():boolean {
        return this._text.exists;
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