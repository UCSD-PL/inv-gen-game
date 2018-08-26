import * as Phaser from "phaser-ce";
import {assert, shallowCopy, structEq, max} from "../../ts/util"

export type LineOptions = {
    style: object,
    visible: boolean
};

export class TextIcon extends Phaser.Group {
    protected _icon: Phaser.Sprite;
    protected _pencil: Phaser.Sprite;
    protected _pencilBounce: Phaser.Tween;
    protected _border: Phaser.Sprite;
    protected _text: Phaser.Group;
    protected _lines: string[];
    protected _game: Phaser.Game;
    protected _defaultOpts: LineOptions;
    protected _lineOpts: LineOptions[];
    protected _hasBorder: boolean;

    constructor(game: Phaser.Game,
                icon: Phaser.Sprite,
                text: (string|string[]),
                name?: string,
                x?: number,
                y?:number,
                startShown?: boolean,
                border?: boolean,
                editable?: boolean) {
        super(game, undefined, name, undefined, undefined, undefined);
        if (x == undefined) x = 0;
        if (y == undefined) y = 0;
        if (startShown == undefined) startShown = true;
        if (border == undefined) border = false;

        this._game = game;
        this._icon = icon;
        this._icon.x = Math.round(-this._icon.width/2);
        this._icon.y =  Math.round(-this._icon.height/2);
        this.inputEnableChildren = true;
        this._defaultOpts = {
            style: { font: "15px Courier New, Courier, monospace", align: "center", fill: "#000000", },
            visible: startShown,
        }
        this._lineOpts = [];
        this.setText(((text instanceof Array) ? text : text.split("\n")), {})
        super.add(this._icon);
        super.add(this._text);
        super.x = x; super.y = y;
        this._hasBorder = border;
        if (editable) {
            let x = this._icon.x + this._icon.width - 16,
                y = this._icon.y + this._icon.height - 16;
            this._pencil = new Phaser.Sprite(game, x, y, "pencil");
            this.add(this._pencil)
            //this._pencilBounce = game.add.tween(this._pencil);
            //this._pencilBounce.to({y:y-5}, 300, Phaser.Easing.Linear.None, true, 0, -1, true)
        }
    }

    protected _render(): void {
        let lineGrp: Phaser.Group;

        function _height(arg: Phaser.Text|JQuery): number {
            if (arg instanceof $) {
                return (arg as JQuery).outerHeight();
            } else {
                return (arg as Phaser.Text).height;
            }
        }

        lineGrp = (this._text !== undefined ? this._text : this._game.add.group())
        lineGrp.removeAll(true);
        let idx = 0;
        let lineElts: (Phaser.Text |JQuery)[] = [];
        for (let ln of this._lines) {
            let opts = this._lineOpts[idx];
            let lineText: Phaser.Text | JQuery;
            lineText = this._game.add.text(0, 0, ln, opts.style, lineGrp);
            lineText.inputEnabled = true;
            lineText.events.onInputDown.add(((lineIdx: number) => ()=> {
                console.log("Line ", lineIdx, " text: ", this._lines[lineIdx], "clicked!");
            })(idx));
            lineElts.push(lineText);
            idx++;
        }
        // Pass 1: Compute relative positions of Phaser.Text entries
        let relY = 0;
        for (let i = 0; i < lineElts.length; i++) {
            let prevHeight: number;
            if (i == 0) {
                prevHeight = 0;
            } else {
                prevHeight = _height(lineElts[i-1]);
            }
            relY += prevHeight;
            let opts = this._lineOpts[i];
            if (lineElts[i] instanceof Phaser.Text) {
                let line : Phaser.Text = lineElts[i] as Phaser.Text;
                line.x = 0;
                line.y = relY;
                line.exists = opts.visible;
            }
        }
        if (lineElts.length > 0) {
            relY += _height(lineElts[lineElts.length-1]);
        }
        // Offset Phaser.Text entries vertically
        this._text = lineGrp;
        this._text.y = -relY/2;
        this._text.x = this._icon.width/2 + 5;

        // Pass 2: Compute absolute positions of textboxes
        relY = 0;
        for (let i = 0; i < lineElts.length; i++) {
            let prevHeight: number;
            if (i == 0) {
                prevHeight = 0;
            } else {
                prevHeight = _height(lineElts[i-1]);
            }
            relY += prevHeight;
            let opts = this._lineOpts[i];
            if (lineElts[i] instanceof $) {
                let line: JQuery = lineElts[i] as JQuery;
                // TODO: Very brittle hacky code - the 26 constant comes from the padding/margins of divs around
                // the canvas.
                line.css("left", this._icon.world.x - this._icon.x + this._text.x + 26)
                line.css("top", this._icon.world.y - this._icon.y + this._text.y + relY + 26)
            }
        }

        if (this._hasBorder) {
            let padding = 2;
            let width = this._icon.width + this._text.width + 2*padding;
            let height = max([this._icon.height, this._text.height]) + 2*padding;

            if (this._border != null) {
                if (this._border.width < width || this._border.height < height) {
                    this.remove(this._border, true, true);
                    this._border = null;
                }
            }

            if (this._border == null) {
                let g = this.game.add.graphics(0, 0);
                g.clear();
                g.lineStyle(2, 0x000000, 1);
                g.beginFill(0xbfbfbf);
                g.drawRoundedRect(0, 0, width, height, 4);
                g.endFill();
                let border = g.generateTexture();
                g.destroy();
                this._border = this.create(-20, -border.height/2, border, 0, true, 0);
            }
        }
    }

    public getText(): Phaser.Group {
        return this._text;
    }

    public getLine(i: number): Phaser.Text {
        return this._text.children[i] as Phaser.Text;
    }

    public rightOfLine(i: number): Phaser.Point {
        let t = this.getLine(i);
        return new Phaser.Point(t.x, t.y).add(t.width, t.height/2)
    }

    public icon(): Phaser.Sprite {
        return this._icon;
    }

    public setText(s: (string|string[]), newOpts?: {[id: number]: LineOptions}) {
        if (newOpts === undefined) {
            newOpts = {};
        }

        this._lines = (s instanceof Array ? s : s.split("\n"));
        this._lineOpts = [];
        for (let i = 0; i < this._lines.length; i++) {
            this._lineOpts.push(shallowCopy((i in newOpts ? newOpts[i] : this._defaultOpts)));
        }
        this._render();
    }

    public hideText(): void {
        this._lineOpts.forEach((opt)=> {opt.visible = false});
        this._render();
    }

    public showText(): void {
        this._lineOpts.forEach((opt)=> {opt.visible = true;});
        this._render();
    }

    public toggleText(): void {
        this._lineOpts.forEach((opt)=> {opt.visible = !opt.visible;});
        this._render();
    }

    public isLineShown(i: number):boolean {
        return this._lineOpts[i].visible;
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
