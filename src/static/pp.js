function invPP(inv) {
  return inv.replace(/===/g, '=').replace(/==/g, '=').replace(/\s/g, '')
}

function ppToInv(pp) {
  return pp.replace(/=/g, '==').replace(/\s/g, '')
}

function invToHTML(inv) {
  return inv
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/<=/g, "&lt;=")
    .replace(/>=/g, "&gt;=")
    .replace(/&&/g, "&amp;&amp;")
}

function htmlToInv(html) {
  h1 = html.replace("=", "==")
  return h1
    .replace("&lt;", "<")
    .replace("&gt;", ">")
    .replace("<==", "<=")
    .replace(">==", ">=")
    .replace("&amp;&amp;", "&&")
}
