/* Requires curvedarrow.ts */

function getAllPlayer1Inv() {
  let player1HTML = $("#good-invariants").children();
  let player1Invs: string[] = [];

  if (player1HTML.length > 0) {
    for (let i: number = 0; i < player1HTML.length; i++) {
      let html: string = player1HTML[i].innerText;
      let inv: string = htmlToInv(html);
      player1Invs.push(inv);
    }
  }

  return player1Invs;
}


function getLastPlayer1Inv(): string {
  let invHTML: string = $("#good-invariants").children().last().html();
  return htmlToInv(invHTML);
}


function getAllPlayer2Inv() {
  let player2HTML = $("#good-invariants2").children();
  let player2Invs: string[] = [];

  if (player2HTML.length > 0) {
    for (let i: number = 0; i < player2HTML.length; i++) {
      let html: string = player2HTML[i].innerText;
      let inv: string = htmlToInv(html);
      player2Invs.push(inv);
    }
  }

  return player2Invs;
}


function getLastPlayer2Inv(): string {
  let invHTML: string = $("#good-invariants2").children().last().html();
  return htmlToInv(invHTML);
}


function showImplication(player, src, dst) {
  let srcX: number = src.offset().left + 200;
  let srcY: number = src.offset().top + 15;

  let dstX: number = dst.offset().left + 200;
  let dstY: number = dst.offset().top + 15;

  let midX: number = (srcX + dstX) / 2 + 200;
  let midY: number = (srcY + dstY) / 2;

  $(function() {
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

  let bonus: number = 5;

  if (player === 1) {
    let newInv: string = getLastPlayer1Inv();
    let player2Invs = getAllPlayer2Inv();

    // allowSwitch = true;
    impliedPairs([newInv], player2Invs, function(x) {
      let increment: number = 0;
      if (x != null) {
        for (let i: number = 0; i < x.length; i++) {
          if (x[i][0] === 0) {
            increment += bonus;
          }
        }
        for (let i: number = 0; i < x.length; i++) {
          if (x[i][0] === 0) {
            // console.log(newInv + " ==> " + player2Invs[x[i][1]]);
            let src = $("#good-invariants").children().last();
            let dst = $("#good-invariants2").children().eq(x[i][1]);
            showImplication(player, src, dst);

            $("#good-invariants2").children().eq(x[i][1]).addClass("implied");
          }
        }
        if (increment !== 0) {
          setTimeout(function() { fn(increment); $(".curved_arrow").delay(1000).fadeOut(1000); }, 1000);
        }
      }
    });
  }

  else if (player === 2) {
    let newInv: string = getLastPlayer2Inv();
    let player1Invs = getAllPlayer1Inv();

    // allowSwitch = true;
    impliedPairs([newInv], player1Invs, function(x) {
      let increment: number = 0;
      if (x != null) {
        for (let i: number = 0; i < x.length; i++) {
          if (x[i][0] === 0) {
            increment += bonus;
          }
        }
        for (let i: number = 0; i < x.length; i++) {
          if (x[i][0] === 0) {
            // console.log(newInv + " ==> " + player1Invs[x[i][1]]);
            let src = $("#good-invariants2").children().last();
            let dst = $("#good-invariants").children().eq(x[i][1]);
            showImplication(player, src, dst);

            $("#good-invariants").children().eq(x[i][1]).addClass("implied");
          }
        }
        if (increment !== 0) {
          setTimeout(function() { fn(increment); $(".curved_arrow").delay(1000).fadeOut(1000); }, 1000);
        }
      }
    });
  }
}
