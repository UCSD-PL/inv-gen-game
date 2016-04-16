function getAllPlayer1Inv() {
  var player1HTML = $("#good-invariants").children();
  var player1Invs = [];

  if(player1HTML.length > 0) {
    for(var i = 0; i < player1HTML.length; i++) {
      var h = player1HTML[i].innerText;
      var i = htmlToInv(h);
      player1Invs.push(i);
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
      var h = player2HTML[i].innerText;
      var i = htmlToInv(h);
      player2Invs.push(i);
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

  if (player == 1) {
    var newInv = getLastPlayer1Inv();
    var player2Invs = getAllPlayer2Inv();

    impliedBy(player2Invs, newInv, function(x) {
      console.log(JSON.stringify(newInv) + " ==> " + JSON.stringify(player2Invs) + " ?");
    });
  }

  else if (player == 2) {
    var newInv = getLastPlayer2Inv();
    var player1Invs = getAllPlayer1Inv();

    impliedBy(player1Invs, newInv, function(x) {
      console.log(JSON.stringify(newInv) + " ==> " + JSON.stringify(player1Invs) + " ?");
    });
  }

  return bonus;
}
