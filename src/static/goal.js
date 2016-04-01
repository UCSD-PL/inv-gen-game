function goalSatisfied(goal, invs, cb) {
  if (goal == null) {
    cb({ "satisfied" : true })
  } else if (goal.manual) {
    cb({ "satisfied" : false })
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

function showNext(goal) {
  if (goal == null) {
    return true;
  }
  else if (goal.manual) {
    return true;
  }
  else {
    return false;
  }
}

function progressEq(p1,p2) {
  return JSON.stringify(p1) === JSON.stringify(p2)
}
