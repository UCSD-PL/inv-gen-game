function invPP(inv) {
  return inv.replace(/===/g, '=').replace(/==/g, '=').replace(/\s/g, '')
}

function invToHTML(inv) {
  return inv
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/<=/g, "&lt=;")
    .replace(/>=/g, "&gt=;")
    .replace(/&&/g, "&amp;&amp;")
}

function htmlToInv(html) {
  console.log("html:" + JSON.stringify(html));
  return html
    .replace("&lt;", "<")
    .replace("&gt;", ">")
    .replace("&lt=;", "<=")
    .replace("&gt=;", ">=")
    .replace("&amp;&amp;", "&&")
    //.replace("=", "==")
    /*
    .replace(/=/g, "==")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&lt=;/g, "<=")
    .replace(/&gt=;/g, ">=")
    .replace(/&amp;&amp;/g, "&&")
    */
}
