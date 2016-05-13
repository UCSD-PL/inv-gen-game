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


function showImplication(player, src, dst) {
  var srcX = src.offset().left + 200;
  var srcY = src.offset().top + 15;

  var dstX = dst.offset().left + 200;
  var dstY = dst.offset().top + 15;

  var midX = (srcX + dstX)/2 + 200;
  var midY = (srcY + dstY)/2;

  $(function(){
    if(player == 1) {
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

  if (player == 1) {
    var newInv = getLastPlayer1Inv();
    var player2Invs = getAllPlayer2Inv();

    equivalentPairs([newInv], player2Invs, function(x) {
      if(x != null) {
        for(var i = 0; i < x.length; i++) {
          console.log(newInv + " <=> " + player2Invs[x[i][1]]);
        }
      }
    });

    impliedPairs(player2Invs, [newInv], function(x) {
      if(x != null) {
        for(var i = 0; i < x.length; i++) {
          console.log(player2Invs[x[i][1]] + " ==> " + newInv);
        }
      }
    });

    impliedPairs([newInv], player2Invs, function(x) {
      var increment = 0;
      if(x != null) {
        for(var i = 0; i < x.length; i++) {
          if(x[i][0] == 0){
            increment += 1
          }
        }
        for(var i = 0; i < x.length; i++) {
          if(x[i][0] == 0){
            console.log(newInv + " ==> " + player2Invs[x[i][1]]);

            // draw curved arrow from newInv to player2Invs[x[i][1]]
            var src = $("#good-invariants").children().last();
            var dst = $("#good-invariants2").children().eq(x[i][1]);
            showImplication(player, src,dst);

            $("#good-invariants2").children().eq(x[i][1]).addClass("implied");
          }
        }
        if(increment !=0) {
          setTimeout(function(){fn(increment); $('.curved_arrow').delay(1000).fadeOut(1000);}, 1000);
        }
      }
    });
  }

  else if (player == 2) {
    var newInv = getLastPlayer2Inv();
    var player1Invs = getAllPlayer1Inv();

    equivalentPairs([newInv], player1Invs, function(x) {
      if(x != null) {
        for(var i = 0; i < x.length; i++) {
          console.log(newInv + "<=>" + player1Invs[x[i][1]]);
        }
      }
    });

    impliedPairs(player2Invs, [newInv], function(x) {
      if(x != null) {
        for(var i = 0; i < x.length; i++) {
          console.log(player2Invs[x[i][1]] + " ==> " + newInv);
        }
      }
    });

    impliedPairs([newInv], player1Invs, function(x) {
      var increment = 0;
      if(x != null) {
        for(var i = 0; i < x.length; i++) {
          if(x[i][0] == 0) {
            increment += 1
          }
        }
        for(var i = 0; i < x.length; i++) {
          if(x[i][0] == 0){
            console.log(newInv + " ==> " + player1Invs[x[i][1]]);

            var src = $("#good-invariants2").children().last();
            var dst = $("#good-invariants").children().eq(x[i][1]);
            showImplication(player, src,dst);

            $("#good-invariants").children().eq(x[i][1]).addClass("implied");
          }
        }
        if(increment !=0) {
          setTimeout(function(){fn(increment); $('.curved_arrow').delay(1000).fadeOut(1000);}, 1000);
        }
      }
    });
  }

}
