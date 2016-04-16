function addBonus(player) {
  var bonus = 0;

  console.log("\n\nPlayer: " + JSON.stringify(player));

  if (player == 1) {
    var invHTML = $("#good-invariants").children().last().html();
    var newInv = htmlToInv(invHTML);
    console.log("newInv: " + JSON.stringify(newInv));

    var player2HTML = $("#good-invariants2").children();
    console.log(player2HTML);

    var player2Invs = [];

    if(player2HTML.length > 0) {
      for(var i = 0; i < player2HTML.length; i++) {
      //jQuery.each(player2HTML, function(h) {
        var h = player2HTML[i].innerText;
        console.log("h : " + JSON.stringify(h));
        var i = htmlToInv(h);
        console.log("i : " + JSON.stringify(i));
        player2Invs.push(i);
      //});
      }

      //var player2Invs = player2HTML.map(htmlToInv); //this doesnt work!

      console.log(player2Invs);

      impliedBy(player2Invs, newInv, function(x) {
        console.log(JSON.stringify(newInv) + " ==> " + JSON.stringify(player2Invs));
      });
      /*
      player2Invs.each(function() {
        var inv = htmlToInv($(this).html());
        console.log(JSON.stringify(newInv) + "==>" + JSON.stringify(inv) + "?");
        //if newInv ==> inv:  bonus += 10;
      })
      */
    }
  }

    else if (player == 2) {
      var invHTML = $("#good-invariants2").children().last().html();
      var newInv = htmlToInv(invHTML);
      console.log("newInv: " + JSON.stringify(newInv));

      var player1HTML = $("#good-invariants").children();
      console.log(player1HTML);

      var player1Invs = [];

      if(player1HTML.length > 0) {
        for(var i = 0; i < player1HTML.length; i++) {
        //jQuery.each(player1HTML, function(h) {
          var h = player1HTML[i].innerText;
          console.log("h : " + JSON.stringify(h));
          var j = htmlToInv(h);
          console.log("j : " + JSON.stringify(j));
          player1Invs.push(j);
        //});
          }

        console.log(player1Invs);

        impliedBy(player1Invs, newInv, function(x) {
          console.log(JSON.stringify(newInv) + " ==> " + JSON.stringify(player1Invs));
        });

        /*
        player1Invs.each(function() {
          var inv = htmlToInv($(this).html());
          console.log(JSON.stringify(newInv) + "==>" + JSON.stringify(inv) + "?");
          //if newInv ==> inv:  bonus += 10;
        })
        */
      }
    }

}
