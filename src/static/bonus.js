function addBonus(foundJSInv, foundJSInv2, tracesW, tracesW2, scoreW, scoreW2, player) {

  var bonus = 0;

  if(player == 1) {
    jsInv = invPP(tracesW.curExp().trim());
    impliedBy(foundJSInv2, jsInv, function (x) {
      if (x !== null) {
        //progressW.markInvariant(foundJSInv2[x], "implies");
        // foundInv[x] ==> JSinv
        //tracesW.immediateError("Implied by existing invariant!")

        console.log("\nPlayer 1's:");
        console.log(JSON.stringify(jsInv));
        console.log("is implied by Player 2's existing invariant:");
        console.log(JSON.stringify(foundJSInv2[x]));

        bonus += 10;
        scoreW.add(bonus);
      }
    })
  }


  else if(player == 2) {
    jsInv2 = invPP(tracesW2.curExp().trim());
    impliedBy(foundJSInv, jsInv2, function(x) {
      if (x !== null) {
        //progressW.markInvariant(foundJSInv[x], "implies");
        // foundInv[x] ==> JSinv
        //tracesW.immediateError("Implied by existing invariant!")

        console.log("\nPlayer 2's:")
        console.log(JSON.stringify(jsInv2));
        console.log("is implied by Player 1's existing invariant:");
        console.log(JSON.stringify(foundJSInv[x]));

        bonus += 10;
        scoreW2.add(bonus);
      }
    })
  }
}
