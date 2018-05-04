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
    public onChanged: Phaser.Signal;

    constructor(game: Phaser.Game, icon: Phaser.Sprite, text: (string|string[]), name?: string, x?: number, y?:number, startShown?: boolean) {
        super(game, undefined, name, undefined, undefined, undefined);
        if (x == undefined) x = 0;
        if (y == undefined) y = 0;
        if (startShown == undefined) startShown = true;

        this.onChanged = new Phaser.Signal();
        this._game = game;
        this._icon = icon;
        this._icon.x = Math.round(-this._icon.width/2);
        this._icon.y =  Math.round(-this._icon.height/2);
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


        if (!this._textMatch()) {
            lineGrp = (this._text !== undefined ? this._text : this._game.add.group())
            lineGrp.removeAll(true);
            let idx = 0;
            for (let ln of this._lines) {
                let opts = this._lineOpts[idx];
                let line = this._game.add.group(lineGrp);
                let lineText: Phaser.Text | PhaserInput.InputField;
                if (opts.editingNow) {
                    let input = (this._game.add as any).inputField(0, 0, this._defaultOpts.style);
                    input.setText(ln);
                    input.focusOutOnEnter = true;
                    line.add(input);
                    input.focusOut.add(((lineIdx: number) => ()=> {
                        this._lines[lineIdx] = input.value;
                        this._lineOpts[lineIdx].editingNow = false;
                        this._render();
                        this.onChanged.dispatch(this, this._lines);
                    })(idx))
                    lineText = input;
                    input.startFocus();
                } else {
                    lineText = this._game.add.text(0, 0, ln, opts.style, line);
                }

                if (opts.removable) {
                    let remIcon = this._game.add.text(lineText.width, 0, " -", rmIconStyle, line);
                    remIcon.inputEnabled = true;
                    remIcon.events.onInputDown.add(((lineIdx: number) => ()=> {
                        this._lines.splice(lineIdx, 1);
                        this._lineOpts.splice(lineIdx, 1)
                        this._render();
                        this.onChanged.dispatch(this, this._lines)
                    })(idx));
                }
                if (opts.editable && !opts.editingNow) {
                    lineText.inputEnabled = true;
                    lineText.events.onInputDown.add(((lineIdx: number) => ()=> {
                        this.edit(lineIdx);
                    })(idx));
                }
                idx++;
            }
        } else {
            lineGrp = this._text;
        }

        for (let i = 0; i < this._lines.length; i++) {
            let yOff = (i == 0 ? 0 : lineGrp.children[i-1].y + (lineGrp.children[i-1] as Phaser.Text).height);
            let opts = this._lineOpts[i];
            let line : Phaser.Group = lineGrp.children[i] as Phaser.Group;
            line.x = 0;
            line.y = yOff;
            line.children.forEach((child: any) => {child.exists = opts.visible;})
        }
        this._text = lineGrp;
        this._text.y = Math.round(-this._text.height/2);
        this._text.x = Math.round(this._icon.width/2 + 5);
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
