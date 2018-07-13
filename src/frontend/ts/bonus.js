define(["require", "exports", "./logic", "./pp", "./eval", "esprima"], function (require, exports, logic_1, pp_1, eval_1, esprima_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    function getAllPlayer1Inv() {
        let player1HTML = $("#good-invariants").children();
        let player1Invs = [];
        if (player1HTML.length > 0) {
            for (let i = 0; i < player1HTML.length; i++) {
                let html = player1HTML[i].innerText;
                let inv = pp_1.htmlToInv(html);
                player1Invs.push(inv);
            }
        }
        return player1Invs;
    }
    exports.getAllPlayer1Inv = getAllPlayer1Inv;
    function getLastPlayer1Inv() {
        let invHTML = $("#good-invariants").children().last().html();
        return pp_1.htmlToInv(invHTML);
    }
    function getAllPlayer2Inv() {
        let player2HTML = $("#good-invariants2").children();
        let player2Invs = [];
        if (player2HTML.length > 0) {
            for (let i = 0; i < player2HTML.length; i++) {
                let html = player2HTML[i].innerText;
                let inv = pp_1.htmlToInv(html);
                player2Invs.push(inv);
            }
        }
        return player2Invs;
    }
    exports.getAllPlayer2Inv = getAllPlayer2Inv;
    function getLastPlayer2Inv() {
        let invHTML = $("#good-invariants2").children().last().html();
        return pp_1.htmlToInv(invHTML);
    }
    function showImplication(player, src, dst) {
        let srcX = src.offset().left + 200;
        let srcY = src.offset().top + 15;
        let dstX = dst.offset().left + 200;
        let dstY = dst.offset().top + 15;
        let midX = (srcX + dstX) / 2 + 200;
        let midY = (srcY + dstY) / 2;
        $(function () {
            if (player === 1) {
                $(document.body).curvedArrow({
                    p0x: srcX,
                    p0y: srcY,
                    p1x: midX,
                    p1y: midY,
                    p2x: dstX,
                    p2y: dstY,
                    strokeStyle: "rgba(255,128,128,0.5)"
                });
            }
            else {
                $(document.body).curvedArrow({
                    p0x: srcX,
                    p0y: srcY,
                    p1x: midX,
                    p1y: midY,
                    p2x: dstX,
                    p2y: dstY,
                    strokeStyle: "rgba(128,128,255,0.5)"
                });
            }
        });
    }
    function getBonus(player, fn) {
        let bonus = 5;
        if (player === 1) {
            let newInv = getLastPlayer1Inv();
            let player2Invs = getAllPlayer2Inv();
            let newInvEs = esprima_1.parse(newInv);
            let player2InvsEs = player2Invs.map((s) => esprima_1.parse(s));
            // allowSwitch = true;
            logic_1.impliedPairs([newInvEs], player2InvsEs, function (x) {
                let increment = 0;
                if (x != null) {
                    for (let i = 0; i < x.length; i++) {
                        increment += bonus;
                    }
                    for (let i = 0; i < x.length; i++) {
                        // console.log(newInv + " ==> " + player2Invs[x[i][1]]);
                        let implInvInd = player2Invs.indexOf(eval_1.esprimaToStr(x[i][2]));
                        let src = $("#good-invariants").children().last();
                        let dst = $("#good-invariants2").children().eq(implInvInd);
                        showImplication(player, src, dst);
                        $("#good-invariants2").children().eq(implInvInd).addClass("implied");
                    }
                    if (increment !== 0) {
                        setTimeout(function () { fn(increment); $(".curved_arrow").delay(1000).fadeOut(1000); }, 1000);
                    }
                }
            });
        }
        else if (player === 2) {
            let newInv = getLastPlayer2Inv();
            let player1Invs = getAllPlayer1Inv();
            let newInvEs = esprima_1.parse(newInv);
            let player1InvsEs = player1Invs.map((s) => esprima_1.parse(s));
            // allowSwitch = true;
            logic_1.impliedPairs([newInvEs], player1InvsEs, function (x) {
                let increment = 0;
                if (x != null) {
                    for (let i = 0; i < x.length; i++) {
                        increment += bonus;
                    }
                    for (let i = 0; i < x.length; i++) {
                        let implInvInd = player1Invs.indexOf(eval_1.esprimaToStr(x[i][2]));
                        // console.log(newInv + " ==> " + player1Invs[x[i][1]]);
                        let src = $("#good-invariants2").children().last();
                        let dst = $("#good-invariants").children().eq(implInvInd);
                        showImplication(player, src, dst);
                        $("#good-invariants").children().eq(implInvInd).addClass("implied");
                    }
                    if (increment !== 0) {
                        setTimeout(function () { fn(increment); $(".curved_arrow").delay(1000).fadeOut(1000); }, 1000);
                    }
                }
            });
        }
    }
    exports.getBonus = getBonus;
});
//# sourceMappingURL=bonus.js.map