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

function invEval(inv, data) {
  // Sort variable names in order of decreasing length
  vars = data.variables.map(function(val, ind, _) { return [val, ind]; })
  vars.sort(function (e1,e2) {
    s1 = e1[0]; s2 = e2[0];
    if (s1.length > s2.length) return -1;
    if (s1.length < s2.length) return 1;
    return 0;
  })

  holds_arr = []

  // Do substitutions and eval
  for (var row in data.data) {
    s = inv
    for (var v in vars) {
      s = s.replace(new RegExp(vars[v][0], 'g'), data.data[row][vars[v][1]])
    }
    holds = eval(s)
    /*
    if (typeof(holds) != 'boolean') {
      throw new InvException("NOT_BOOL", holds)
    }
    */
    holds_arr.push(holds)
  }
  return holds_arr
}

function evalResultBool(evalResult) {
  for (var i in res) {
    if (typeof(res[i]) != "boolean")
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
