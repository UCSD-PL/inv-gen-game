function invPP(inv) {
  var eqFixed = inv.replace(/===/g, '=').replace(/==/g, '=').replace(/\s/g, '')
  var mulFixed = eqFixed.replace(/([0-9])([a-zA-Z])/g, (s,g1,g2) =>  g1 + '*' + g2)
  var mulFixed1 = mulFixed.replace(/([a-zA-Z])([0-9])/g, (s,g1,g2) =>  g1 + '*' + g2)
  var caseFixed = mulFixed1.toLowerCase()
  return caseFixed
}

function invToHTML(inv) {
  return inv
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/<=/g, "&lt=;")
    .replace(/>=/g, "&gt=;")
    .replace(/&&/g, "&amp;&amp;")
}
