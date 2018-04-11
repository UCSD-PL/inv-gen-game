define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    class ScoreWindow {
        constructor(parent) {
            this.parent = parent;
            this.score = 0;
            $(this.parent).html("");
            $(this.parent).addClass("scoreWindow");
            $(this.parent).addClass("scoreText");
            this.clear();
        }
        add(num) {
            this.score += num;
            $(this.parent).html("<span>" + this.score + "</span>");
            let addSpan = $("<span class='scoreText scoreFloat'>+" + num + "</span>");
            $(this.parent).append(addSpan);
            addSpan.position({ "my": "left center", "at": "right+10 center", "of": this.parent });
            addSpan.hide({ effect: "puff", easing: "swing", duration: 2000, complete: function () {
                    $(addSpan).remove();
                }
            });
        }
        clear() {
            this.score = 0;
            $(this.parent).html("<span>0</span>");
        }
    }
    exports.ScoreWindow = ScoreWindow;
    class TwoPlayerScoreWindow extends ScoreWindow {
        constructor(playerNum, parent) {
            super(parent);
            this.playerNum = playerNum;
            this.parent = parent;
            this.player = 0;
            this.player = playerNum;
            $(this.parent).removeClass("scoreWindow");
            $(this.parent).removeClass("scoreText");
            if (this.player === 1) {
                $(this.parent).addClass("scoreWindow1");
                $(this.parent).addClass("scoreText1");
            }
            else if (this.player === 2) {
                $(this.parent).addClass("scoreWindow2");
                $(this.parent).addClass("scoreText2");
            }
        }
        add(num) {
            this.score += num;
            $(this.parent).html("<span>" + this.score + "</span>");
            let addSpan = null;
            if (this.player === 1) {
                addSpan = $("<span class='scoreText1 scoreFloat'>+" + num + "</span>");
            }
            else if (this.player === 2) {
                addSpan = $("<span class='scoreText2 scoreFloat'>+" + num + "</span>");
            }
            $(this.parent).append(addSpan);
            addSpan.hide({
                effect: "puff", easing: "swing", duration: 1000, complete: function () {
                    $(addSpan).remove();
                }
            });
        }
    }
    exports.TwoPlayerScoreWindow = TwoPlayerScoreWindow;
});
//# sourceMappingURL=scoreWindow.js.map