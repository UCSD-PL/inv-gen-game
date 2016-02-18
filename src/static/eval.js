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
