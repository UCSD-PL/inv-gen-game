/* Requires Epsrima.js */

function invToEsp(inv) {
  return esprima.parse(inv)
}

function equivalentPairs(invL1, invL2, cb) {
  return rpc.call("App.equivalentPairs",
    [ $.map(invL1, invToEsp), $.map(invL2, invToEsp) ], cb, log)
}

function equivalent(inv1, inv2, cb) {
  return equivalent([inv1], [inv2], function (res) { cb(res.length > 0) });
}

/* invL1 is the list of found invariants
 * invL2 is the invariant entered (as a list)
 * Check if invL2 ==> any inv in invL1
 */
function impliedPairs(invL1, invL2, cb) {
  console.log("impliedPairs");
  console.log(invL1);
  console.log(invL2);
  console.log(cb);
  return rpc.call("App.impliedPairs",
    [ $.map(invL1, esprima.parse), $.map(invL2, esprima.parse) ], cb, log)
}

function implied(invL1, inv, cb) {
  return impliedPairs(invL1, [inv], function (res) { cb(res.length > 0) });
}

/* inv is implied by an invariant already in invL1 */
function impliedBy(invL1, inv, cb) {
  return impliedPairs(invL1, [inv], function (res) {
    if (res.length > 0)
      cb(res[0][0]);
    else
      cb(null);
  });
}

function isTautology(inv, cb) {
  return rpc.call("App.isTautology", [ esprima.parse(inv) ], cb, log)
}
