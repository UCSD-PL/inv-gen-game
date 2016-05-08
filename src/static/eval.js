var notDefRe = /(.*) is not defined/;

function InvException(name, msg) {
  this.name = name;
  this.message = msg;
}

function interpretError(err) {
  if (err.name == 'ReferenceError') {
    if (err.message.match(notDefRe))
      return err.message.match(notDefRe)[1] + " is not defined."
    else
      return "Not a valid expression."
  } else if (err.name == 'SyntaxError') {
    return "Not a valid expression."
  } else if (err.name == 'NOT_BOOL') {
    return "Expression should evaluate to true or false, not " + err.message + " for example."
  }

  return err
}

function invToJS(inv) {
  return inv.replace(/[^<>]=[^>]/g, function (v) { return v[0] + '==' + v[2]; })
}

function invEval(inv, variables, data) {
  // Sort variable names in order of decreasing length
  vars = variables.map(function(val, ind, _) { return [val, ind]; })
  vars.sort(function (e1,e2) {
    s1 = e1[0]; s2 = e2[0];
    if (s1.length > s2.length) return -1;
    if (s1.length < s2.length) return 1;
    return 0;
  })

  holds_arr = []

  // Do substitutions and eval
  for (var row in data) {
    s = inv
    for (var v in vars) {
      s = s.replace(new RegExp(vars[v][0], 'g'), data[row][vars[v][1]])
    }
    holds = eval(s)
    holds_arr.push(holds)
  }
  return holds_arr
}

function evalResultBool(evalResult) {
  for (var i in evalResult) {
    if (evalResult[i] instanceof Array)
      return evalResultBool(evalResult[i])
    if (typeof(evalResult[i]) != "boolean")
      return false;
  }
  return true;
}

function identifiers(inv) {
  if (typeof(inv) == "string")
    return identifiers(esprima.parse(inv))

  if (inv.type == "Program")
    return identifiers(inv.body[0].expression)

  if (inv.type == "BinaryExpression")
    return union(identifiers(inv.left), identifiers(inv.right))

  if (inv.type == "UnaryExpression")
    return identifiers(inv.argument)

  if (inv.type == "Identifier") {
    var r = {}
    r[inv.name] = true;
    return r
  }

  return {}
}

function literals(inv) {
  if (typeof(inv) == "string")
    return literals(esprima.parse(inv))

  if (inv.type == "Program")
    return literals(inv.body[0].expression)

  if (inv.type == "BinaryExpression")
    return union(literals(inv.left), literals(inv.right))

  if (inv.type == "UnaryExpression")
    return literals(inv.argument)

  if (inv.type == "Literal") {
    var r = {}
    r[inv.raw] = true;
    return r
  }

  return {}
}

function operators(inv) {
  if (typeof(inv) == "string")
    return operators(esprima.parse(inv))

  if (inv.type == "Program")
    return operators(inv.body[0].expression)

  if (inv.type == "BinaryExpression") {
    var p = {}
    p[inv.operator] = true;
    return union(union(p, operators(inv.left)),
                 operators(inv.right))
  }

  if (inv.type == "UnaryExpression") {
    var p = {}
    p[inv.operator] = true;
    return union(p, operators(inv.argument))
  }

  return {}
}

function replace(inv, replF) {
  if (typeof(inv) == "string")
    return replace(esprima.parse(inv), replF)

  if (inv.type == "Program")
    return { "type" : "Program",
             "body": [ { 
                "type": "ExpressionStatement",
                "expression": replace(inv.body[0].expression, replF)
              } ]
           }

  if (inv.type == "BinaryExpression") {
    var lhs = replace(inv.left, replF)
    var rhs = replace(inv.right, replF)
    return replF({ "type":"BinaryExpression",
                   "operator": inv.operator,
                   "left": lhs,
                   "right": rhs, })
  }

  if (inv.type == "UnaryExpression") {
    var exp = replace(inv.argument, replF)
    return replF({ "type": "UnaryExpression",
                   "operator": inv.operator,
                   "argument": exp,
           })
  }

  if (inv.type == "Literal") {
    return replF({ "type": "Literal", "raw": inv.raw })
  }

  if (inv.type == "Identifier") {
    return replF({ "type": "Identifier", "name": inv.name })
  }

  assert(false, "Shouldn't get here")
}

function abstractLiterals(inv) {
  var newVars= [];
  var newInv = replace(inv, (node) => {
    if (node.type == "Literal") {
      var newId = "a" + newVars.length
      newVars.push(newId)
      return { "type": "Identifier", "name": newId }
    }

    return node
  })
  return [ newInv, newVars ]
}
