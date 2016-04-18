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


function getBonus(player) {
  var bonus = 0;
  var increment = 1;

  if (player == 1) {
    var newInv = getLastPlayer1Inv();
    var player2Invs = getAllPlayer2Inv();

    impliedPairs([newInv], player2Invs, function(x) {
      if(x != null) {
        for(var i = 0; i < x.length; i++) {
          if(x[i][0] == 0){
            console.log(JSON.stringify(newInv) + " ==> " + player2Invs[x[i][1]] + " = True");
            bonus = bonus + increment;
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
            console.log(JSON.stringify(newInv) + " ==> " + player1Invs[x[i][1]] + " = True");
            bonus = bonus + increment;
          }
        }
      }
    });
  }

  return bonus;
}
