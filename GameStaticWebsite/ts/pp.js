function invPP(inv) {
    let eqFixed = inv.replace(/===/g, "=").replace(/==/g, "=");
    //let eqFixed: string = inv.replace(/===/g, "=").replace(/==/g, "=").replace(/\s/g, "");
    // let mulFixed: string = eqFixed.replace(/([0-9])([a-zA-Z])/g, (s, g1, g2) => g1 + "*" + g2);
    // let mulFixed1: string = mulFixed.replace(/([a-zA-Z])([0-9])/g, (s, g1, g2) => g1 + "*" + g2);
    // let caseFixed: string = mulFixed1.toLowerCase();
    let caseFixed = eqFixed.toLowerCase();
    return caseFixed;
}
function invToHTML(inv) {
    return esprimaToStr(inv)
        .replace(/^\(/g, "") // remove starting parenthesis (there is always one)
        .replace(/\)$/g, "") // remove trailing parenthesis (there is always one)
        .replace(/(.*)->(.*)/g, "$2 if $1")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/<=/g, "&lt;=")
        .replace(/>=/g, "&gt;=")
        .replace(/&&/g, "&amp;&amp;");
}
function htmlToInv(html) {
    let h1 = html.replace("=", "==");
    return h1
        .replace(/&lt;/g, "<")
        .replace(/&gt;/g, ">")
        .replace(/<==/g, "<=")
        .replace(/>==/g, ">=")
        .replace(/==>/g, "->")
        .replace(/&amp;&amp;/g, "&&");
}
//# sourceMappingURL=pp.js.map