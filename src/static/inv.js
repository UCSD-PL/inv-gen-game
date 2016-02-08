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

function invPP(inv) {
  return inv.replace(/===/g, '=').replace(/==/g, '=').replace(/\s/g, '')
}

function invToJS(inv) {
  return inv.replace(/[^<>]=[^>]/g, function (v) { return v[0] + '==' + v[2]; })
}

function invToHTML(inv) {
  return inv
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/<=/g, "&lt=;")
    .replace(/>=/g, "&gt=;")
    .replace(/&&/g, "&amp;&amp;")
}

function equivalentPairs(invL1, invL2, cb) {
  return rpc.call("App.equivalentPairs", [ $.map(invL1, esprima.parse), $.map(invL2, esprima.parse) ], cb, log)
}

function impliedPairs(invL1, invL2, cb) {
  return rpc.call("App.impliedPairs", [ $.map(invL1, esprima.parse), $.map(invL2, esprima.parse) ], cb, log)
}

function implied(invL1, inv, cb) {
  return impliedPairs(invL1, [inv], function (res) { cb(res.length > 0) });
}

function isTautology(inv, cb) {
  return rpc.call("App.isTautology", [ esprima.parse(inv) ], cb, log)
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

function goalSatisfied(goal, invs, cb) {
  if (goal == null) {
    cb({ "satisfied" : true })
  } else  if (goal.find) {
    var numFound = 0;
    for (var i=0; i < goal.find.length; i++) {
      var found = false;
      for (var j=0; j < goal.find[i].length; j++) {
        if ($.inArray(goal.find[i][j], invs) != -1) {
          found = true;
          break;
        }
      }

      if (found)
        numFound ++;

    }

    cb({ "satisfied": numFound == goal.find.length,
             "find": { "found": numFound, "total": goal.find.length } })
  } else  if (goal.equivalent) {
    equivalentPairs(goal.equivalent, invs, function(pairs) {
      var numFound = 0;
      var equiv = []
      for (var i=0; i < pairs.length; i++) {
        if (-1 == $.inArray(pairs[i][0], equiv))
          equiv.push(pairs[i][0])
      }

      cb({ "satisfied": equiv.length == goal.equivalent.length,
               "equivalent": { "found": equiv.length , "total": goal.equivalent.length } })
    })
  } else if (goal.max_score) {
    return { "satisfied" : true, "max_score" : { "found" : invs.length } }
  } else {
    error("Unknown goal " + goal.toSource());
  }
}

function progressEq(p1,p2) {
  return JSON.stringify(p1) === JSON.stringify(p2)
}
