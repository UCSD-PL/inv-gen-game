import * as Phaser from "phaser-ce";
import * as PhaserInput from "phaser-input";
import {Point} from "phaser-ce";
import {assert, shallowCopy, structEq} from "./util"

export type LineOptions = {
    style: object,
    removable: boolean,
    editable: boolean,
    editingNow: boolean,
    visible: boolean
};

export class TextIcon extends Phaser.Group {
    protected _icon: Phaser.Sprite;
    protected _text: Phaser.Group;
    protected _lines: string[];
    protected _game: Phaser.Game;
    protected _defaultOpts: LineOptions;
    protected _lineOpts: LineOptions[];
    protected _focused: number;
    protected _inputBox: JQuery;

    public onChanged: Phaser.Signal;
    public onTyped: Phaser.Signal;

    constructor(game: Phaser.Game, icon: Phaser.Sprite, text: (string|string[]), name?: string, x?: number, y?:number, startShown?: boolean) {
        super(game, undefined, name, undefined, undefined, undefined);
        if (x == undefined) x = 0;
        if (y == undefined) y = 0;
        if (startShown == undefined) startShown = true;

        this.onChanged = new Phaser.Signal();
        this.onTyped = new Phaser.Signal();
        this._game = game;
        this._icon = icon;
        this._icon.x = -this._icon.width/2;
        this._icon.y =  -this._icon.height/2;
        this._defaultOpts = {
            style: { font: "15px Courier New, Courier, monospace", align: "center", fill: "#000000", backgroundColor: "#ffffff" },
            removable: false,
            editable: false,
            editingNow: false,
            visible: startShown,
        }
        this._lineOpts = [];
        this.setText(((text instanceof Array) ? text : text.split("\n")), {})
        this._focused = undefined;
        super.add(this._icon);
        super.add(this._text);
        super.x = x; super.y = y;
    }

    private _textMatch(): boolean {
        // Return True iff the text in the current Phaser.Text objects matches the text
        // in this._lines
        if (this._text == undefined) return false;
        if (this._lines.length != this._text.children.length) return false;

        for (let i = 0; i < this._lines.length; i++) {
            if (this._lines[i] != this.getLine(i).text) {
                return false;
            }
        }

        return true;
    }

    public edit(lineIdx: number): void {
        let opts = this._lineOpts[lineIdx];
        assert(opts.editable);
        opts.editingNow = true;
        this._render();
    }

    protected _render(): void {
        let lineGrp: Phaser.Group;
        let rmIconStyle = { font: "15px Courier New, Courier, monospace", align: "center", fill: "#ff0000", backgroundColor: "#ffffff" };

        function _height(arg: Phaser.Text|JQuery): number {
            if (arg instanceof $) {
                return (arg as JQuery).outerHeight();
            } else {
                return (arg as Phaser.Text).height;
            }
        }

        lineGrp = (this._text !== undefined ? this._text : this._game.add.group())
        lineGrp.removeAll(true);
        if (this._inputBox != null) {
            this._inputBox.remove();
        }
        let idx = 0;
        let lineElts: (Phaser.Text |JQuery)[] = [];
        for (let ln of this._lines) {
            let opts = this._lineOpts[idx];
            let lineText: Phaser.Text | JQuery;
            if (opts.editingNow) {
                let container: JQuery = $("#" + this.game.parent);
                let input: JQuery = $("<input class='absPos' type='text'></input>");
                input.val(ln);
                input.change(((lineIdx: number) => ()=> {
                    this._lines[lineIdx] = input.val();
                    this._lineOpts[lineIdx].editingNow = false;
                    this._render();
                    this.onChanged.dispatch(this, this._lines);
                })(idx))
                this._inputBox = input;
                container.append(this._inputBox)
                this._inputBox.focus();
                lineText = input;
            } else {
                lineText = this._game.add.text(0, 0, ln, opts.style, lineGrp);
                if (opts.editable) {
                    lineText.inputEnabled = true;
                    lineText.events.onInputDown.add(((lineIdx: number) => ()=> {
                        this.edit(lineIdx);
                    })(idx));
                }
            }
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
                line.children.forEach((child: any) => {child.exists = opts.visible;})
            }
        }
        if (lineElts.length > 0) {
            relY += _height(lineElts[lineElts.length-1]);
        }
        // Offset Phaser.Text entries vertically
        this._text = lineGrp;
        this._text.y = -relY/2;
        console.log("Height: ", relY)
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
                console.log("icon world y", this._icon.world.y, "icon y", this._icon.y, "text y", this._text.y, "rely", relY);
                line.css("left", this._icon.world.x - this._icon.x + this._text.x + 26)
                line.css("top", this._icon.world.y - this._icon.y + this._text.y + relY + 26)
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
