function invPP(inv: string): string {
  let eqFixed: string = inv.replace(/===/g, "=").replace(/==/g, "=").replace(/\s/g, "");
  // let mulFixed: string = eqFixed.replace(/([0-9])([a-zA-Z])/g, (s, g1, g2) => g1 + "*" + g2);
  // let mulFixed1: string = mulFixed.replace(/([a-zA-Z])([0-9])/g, (s, g1, g2) => g1 + "*" + g2);
  // let caseFixed: string = mulFixed1.toLowerCase();
  let caseFixed: string = eqFixed.toLowerCase();
  return caseFixed;
}

function ppToInv(pp: string): string {
  return pp.replace(/=/g, "==").replace(/\s/g, "");
}

function invToHTML(inv: string): string {
  return inv
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/<=/g, "&lt;=")
    .replace(/>=/g, "&gt;=")
    .replace(/&&/g, "&amp;&amp;");
}

function htmlToInv(html: string): string {
  let h1: string = html.replace("=", "==");
  return h1
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/<==/g, "<=")
    .replace(/>==/g, ">=")
    .replace(/&amp;&amp;/g, "&&");
}
