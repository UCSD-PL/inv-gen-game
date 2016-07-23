var notDefRe = /(.*) is not defined/;

class InvException extends Error{
  constructor(public name: string, public message: string) { super(message); }
}

class ImmediateErrorException extends InvException {
  constructor(public name: string, public message: string) { super(name, message); }
}

function interpretError(err: Error): (string|Error) {
  if (err.name === "ReferenceError") {
    if (err.message.match(notDefRe))
      return err.message.match(notDefRe)[1] + " is not defined.";
    else
      return "Not a valid expression."
  } else if (err.name == 'SyntaxError') {
    return "Not a valid expression."
  } else if (err.name == 'NOT_BOOL') {
    return "Expression should evaluate to true or false, not " + err.message + " for example."
  } else if (err.name == "UnsupportedError") {
    return (<InvException>err).message;
  }

  return err;
}

function invToJS(inv: string): string {
  return inv.replace(/[^<>]=[^>]/g, function(v) { return v[0] + "==" + v[2]; });
}

function holds(inv:string, variables: string[], data: any[][]): boolean {
  let res = invEval(inv, variables, data);
  return evalResultBool(res) &&
         res.filter((x)=>!(x === true)).length == 0;
}

function invEval(inv:string, variables: string[], data: any[][]): any[] {
  // Sort variable names in order of decreasing length
  let vars: [string, number][] = variables.map(function(val, ind, _) { return <[string, number]>[val, ind]; });
  vars.sort(function(e1, e2) {
    let s1 = e1[0], s2 = e2[0];
    if (s1.length > s2.length) return -1;
    if (s1.length < s2.length) return 1;
    return 0;
  });

  let holds_arr = [];

  // Do substitutions and eval
  for (var row in data) {
    let s = inv
    for (var v in vars) {
      s = s.replace(new RegExp(vars[v][0], 'g'), '(' + data[row][vars[v][1]] + ')')
    }
    let res = eval(s);
    holds_arr.push(res);
  }
  return holds_arr;
}

function evalResultBool(evalResult: any[]): boolean {
  for (let i in evalResult) {
    if (evalResult[i] instanceof Array)
      return evalResultBool(evalResult[i]);
    if (typeof (evalResult[i]) !== "boolean")
      return false;
  }
  return true;
}

function estree_reduce<T>(t: ESTree.Node, cb: (n: ESTree.Node, args: T[]) => T): T {
  if (t.type === "Program") {
    let p = <ESTree.Program>t;
    let es = <ESTree.ExpressionStatement>p.body[0];
    return cb(t, [estree_reduce<T>(es.expression, cb)]);
  }

  if (t.type === "BinaryExpression") {
    let be = <ESTree.BinaryExpression>t;
    let lhs: T = estree_reduce(be.left, cb);
    let rhs: T = estree_reduce(be.right, cb);
    return cb(t, [lhs, rhs]);
  }

  if (t.type === "LogicalExpression") {
    let be = <ESTree.LogicalExpression>t;
    let lhs: T = estree_reduce(be.left, cb);
    let rhs: T = estree_reduce(be.right, cb);
    return cb(t, [lhs, rhs]);
  }

  if (t.type === "UnaryExpression") {
    let ue = <ESTree.UnaryExpression>t;
    let exp: T = estree_reduce(ue.argument, cb);
    return cb(t, [exp]);
  }

  if (t.type === "Literal") {
    return cb(t, []);
  }

  if (t.type === "Identifier") {
    return cb(t, []);
  }

  assert(false, "Shouldn't get here");
}

function identifiers(inv: (string|ESTree.Node)): strset {
  if (typeof (inv) === "string")
    return identifiers(esprima.parse(<string>inv));

  let t = <ESTree.Node> inv;

  return estree_reduce(t, (nd: ESTree.Node, args: strset[]) => {
    if (nd.type === "Program")
      return args[0];

    if (nd.type === "BinaryExpression" || nd.type === "LogicalExpression") {
      return union(args[0], args[1]);
    }

    if (nd.type === "UnaryExpression") {
      return args[0];
    }

    if (nd.type === "Identifier") {
      let r: strset = {};
      r[(<ESTree.Identifier>nd).name] = true;
      return r;
    }

    return {};
  });
}

function literals(inv: (string|ESTree.Node)): strset {
  if (typeof (inv) === "string")
    return literals(esprima.parse(<string>inv));

  return estree_reduce(<ESTree.Node>inv, (nd: ESTree.Node, args: strset[]) => {
    if (nd.type === "Program")
      return args[0];

    if (nd.type === "BinaryExpression" || nd.type === "LogicalExpression") {
      return union(args[0], args[1]);
    }

    if (nd.type === "UnaryExpression") {
      return args[0];
    }

    if (nd.type === "Literal") {
      let r: strset = {};
      r[(<string>(<ESTree.Literal>nd).value)] = true;
      return r;
    }

    return {};
  });
}

function operators(inv: (string|ESTree.Node)): strset {
  if (typeof (inv) === "string")
    return operators(esprima.parse(<string>inv));

  return estree_reduce(<ESTree.Node>inv, (nd: ESTree.Node, args: strset[]) => {
    if (nd.type === "Program")
      return args[0];

    if (nd.type === "BinaryExpression" || nd.type === "LogicalExpression") {
      let be = <ESTree.BinaryExpression>nd;
      let p: strset = {};
      p[be.operator] = true;
      return union(union(p, args[0]), args[1]);
    }

    if (nd.type === "UnaryExpression") {
      let ue = <ESTree.UnaryExpression>nd;
      let p: strset = {};
      p[ue.operator] = true;
      return union(p, args[0]);
    }

    return {};
  });
}

function replace(inv: (string|ESTree.Node), replF): ESTree.Node {
  if (typeof (inv) === "string")
    return replace(esprima.parse(<string>inv), replF);

  return estree_reduce(<ESTree.Node>inv, (nd: ESTree.Node, args: ESTree.Node[]): ESTree.Node => {
    if (nd.type === "Program") {
      let p = <ESTree.Program>nd;
      let es = <ESTree.ExpressionStatement>p.body[0];
      return <ESTree.Program>{
        "type": "Program",
        "body": [<ESTree.ExpressionStatement>{
          "type": "ExpressionStatement",
          "expression": replace(es.expression, replF)
        }],
        "sourceType": "dummy"
      };
    }

    if (nd.type === "BinaryExpression") {
      let be = <ESTree.BinaryExpression>nd;
      return replF(<ESTree.BinaryExpression>{ "type": "BinaryExpression",
                     "operator": be.operator,
                     "left": args[0],
                     "right": args[1],
                  })
    }

    if (nd.type === "LogicalExpression") {
      let le = <ESTree.LogicalExpression>nd;
      return replF(<ESTree.LogicalExpression>{
        "type": "LogicalExpression",
        "operator": le.operator,
        "left": args[0],
        "right": args[1],
      });
    }

    if (nd.type === "UnaryExpression") {
      let ue = <ESTree.UnaryExpression>nd;
      return replF(<ESTree.UnaryExpression>{
        "type": "UnaryExpression",
        "operator": ue.operator,
        "argument": args[0],
      });
    }

    if (nd.type === "Literal" || nd.type === "Identifier") {
      return replF(nd);
    }
  });
}

function generalizeConsts(inv:string|ESTree.Node): [ESTree.Node, string[], string[]] {
  let symConsts: string[] = [];
  let newInv: ESTree.Node = replace(inv, (node) => {
    if (node.type == "Literal") {
      var newId = "a" + symConsts.length
      symConsts.push(newId)
      return { "type": "Identifier", "name": newId }
    }
    return node
  })
  return [ newInv, symConsts, [] ]
}

function generalizeInv(inv:string|ESTree.Node): [ESTree.Node, string[], string[]] {
  let symConsts: string[] = [];
  let symVars: string[] = [];
  let newInv: ESTree.Node = replace(inv, (node) => {
    if (node.type == "Literal") {
      var newId = "a" + symConsts.length
      symConsts.push(newId)
      return { "type": "Identifier", "name": newId }
    }

    if (node.type == "Identifier") {
      var newId = "x" + symVars.length
      symVars.push(newId)
      return { "type": "Identifier", "name": newId }
    }

    return node
  })
  return [ newInv, symConsts, symVars ]
}

function esprimaToStr(nd: ESTree.Node): string {
  return estree_reduce<string>(nd,  (nd: ESTree.Node, args: string[]): string => {
    if (nd.type == "Program") {
      return args[0]
    }

    if (nd.type == "BinaryExpression") {
      let be = <ESTree.BinaryExpression>nd;
      return "(" + args[0] + be.operator + args[1] + ")"
    }

    if (nd.type == "LogicalExpression") {
      let le = <ESTree.LogicalExpression>nd;
      return "(" + args[0] + le.operator + args[1] + ")"
    }

    if (nd.type == "UnaryExpression") {
      let ue = <ESTree.UnaryExpression>nd;
      let s = args[0]
      if (ue.operator == '-' && s[0] == '-')
        s = '(' + s + ')'
      return "(" + ue.operator + s + ")"
    }

    if (nd.type == "Literal") {
      return "" + (<ESTree.Literal>nd).value
    }

    if (nd.type == "Identifier") {
      return (<ESTree.Identifier>nd).name
    }
  })
}