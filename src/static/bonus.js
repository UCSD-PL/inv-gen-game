function getAllPlayer1Inv() {
  var player1HTML = $("#good-invariants").children();
  var player1Invs = [];

  if(player1HTML.length > 0) {
    for(var i = 0; i < player1HTML.length; i++) {
      var html = player1HTML[i].innerText;
      var inv = htmlToInv(html);
      player1Invs.push(inv);
    }
  }

  return player1Invs;
}


function getLastPlayer1Inv() {
  var invHTML = $("#good-invariants").children().last().html();
  return htmlToInv(invHTML);
}


function getAllPlayer2Inv() {
  var player2HTML = $("#good-invariants2").children();
  var player2Invs = [];

  if(player2HTML.length > 0) {
    for(var i = 0; i < player2HTML.length; i++) {
      var html = player2HTML[i].innerText;
      var inv = htmlToInv(html);
      player2Invs.push(inv);
    }
  }

  return player2Invs;
}


function getLastPlayer2Inv() {
  var invHTML = $("#good-invariants2").children().last().html();
  return htmlToInv(invHTML);
}


function showImplication(src, dst) {
  var srcX = src.offset().left + 200;
  var srcY = src.offset().top + 10;

  var dstX = dst.offset().left + 200;
  var dstY = dst.offset().top + 10;

  var midX = (srcX + dstX)/2 + 200;
  var midY = (srcY + dstY)/2;

  $(function(){
    $(document.body).curvedArrow({
        p0x: srcX,
        p0y: srcY,
        p1x: midX,
        p1y: midY,
        p2x: dstX,
        p2y: dstY
    });
  });
}


function getBonus(player, fn) {
  var increment = 1;

  if (player == 1) {
    var newInv = getLastPlayer1Inv();
    var player2Invs = getAllPlayer2Inv();

    impliedPairs([newInv], player2Invs, function(x) {
      if(x != null) {
        for(var i = 0; i < x.length; i++) {
          if(x[i][0] == 0){
            console.log(newInv + " ==> " + player2Invs[x[i][1]]);

            // draw curved arrow from newInv to player2Invs[x[i][1]]
            var src = $("#good-invariants").children().last();
            var dst = $("#good-invariants2");
            showImplication(src,dst);

            // pause for 2 sec
            // fadeout the implied invariant from player 2's set of invariants
            // fadeout the curved arrow

            fn(increment);
          }
        }
      }
    });
  }

  else if (player == 2) {
    var newInv = getLastPlayer2Inv();
    var player1Invs = getAllPlayer1Inv();

    impliedPairs([newInv], player1Invs, function(x) {
      if(x != null) {
        for(var i = 0; i < x.length; i++) {
          if(x[i][0] == 0) {
            console.log(newInv + " ==> " + player1Invs[x[i][1]]);
            fn(increment);
            //remove the implied invariant from player 1's set of invariants
            //  move the invariant towards newInv
            //  fade the invariant

            //decrement player 1's points (by 1)
            //  show the decrement in red color
          }
        }
      }
    });
  }

}
