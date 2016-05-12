type dataT = [ [[number]], [[number]], [[number]] ]
class Level {
  constructor(public id: string,
    public variables: string[],
    public data:  dataT,
    public goal:  string,
    public hint:  string) {
  }
}
/*
function Level(id, 
               variables,
               initial_data,
               exploration_state,
               goal,
               hint,
               support_pos_ex,
               supports_neg_ex,
               support_ind_ex,
               multiround,
               startingInvs) {
  var lvl = this;
  this.id = id;
  this.positive_data, this.negative_data, this.inductive_data = initial_data;
  this.data = initial_data
  this.exploration_state = exploration_state
  this.variables = variables
  this.goal = goal;
  this.hint = hint;
  this.support_pos_ex = support_pos_ex;
  this.supports_neg_ex = supports_neg_ex;
  this.support_ind_ex = support_ind_ex;
  this.multiround = multiround;
  this.startingInvs = startingInvs;

  this.invSound = function(inv, soundInvs, cb) {
    if (lvl.support_pos_ex) {
      pre_vc_ctrex(curLvlSet, lvl.id, soundInvs.concat([inv]), function(pos_res) {
        if (pos_res.length != 0) {
          cb({ sound: false, ctrex: [pos_res, [], []] })
        } else if (lvl.support_ind_ex) {
          ind_vc_ctrex(curLvlSet, lvl.id, soundInvs.concat([inv]), function(ind_res) {
            cb({ sound: ind_res.length == 0, ctrex: [ [], [], ind_res ] })
          })
        } else {
          cb({ sound: true, ctrex: [ [], [], [] ] })
        }
      })
    } else if (lvl.support_ind_ex) {
      ind_vc_ctrex(curLvlSet, this.id, soundInvs.concat([inv]), function(res) {
        cb({ sound: res.length == 0, counterexample: [ [], [], res ] })
      })
    } else {
      cb({ sound: true, ctrex: [ [], [], [] ] });
    }
  }

  this.goalSatisfied = function(all_invs, overfitted, nonind, sound, cb) {
    var goal = lvl.goal;
    if (goal == null) {
      cb({ "satisfied" : true })
    } else if (goal.manual) {
      cb({ "satisfied" : false })
    } else  if (goal.find) {
      var numFound = 0;
      for (var i=0; i < goal.find.length; i++) {
        var found = false;
        for (var j=0; j < goal.find[i].length; j++) {
          if ($.inArray(goal.find[i][j], all_invs) != -1) {
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
      equivalentPairs(goal.equivalent, all_invs, function(pairs) {
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
      cb({ "satisfied" : true, "max_score" : { "found" : all_invs.length } })
    } else if (goal.verify) {
      if (sound.length > 0) {
        counterexamples(curLvlSet, lvl.id, sound, function(res) {
          var pos=res[0],neg=res[1],ind = res[2]
          cb({ "satisfied": pos.length == 0 && neg.length == 0 && ind.length == 0,
               "counterexamples": res
          })
        })
      } else {
        cb({ "satisfied": false, "counterexamples": [ [], [], [] ]})
      }
    } else if (goal.none) {
      cb({ "satisfied" : false })
    } else if (goal.hasOwnProperty('atleast')) {
      cb({ "satisfied" : all_invs.length >= goal.atleast })
    } else {
      error("Unknown goal " + JSON.stringify(goal));
    }
  }
}

Level.load = function(lvlSet, id, cb) {
  rpc.call('App.loadLvl', [ lvlSet, id], function(data) {
    cb(new Level(id, data.variables, data.data, data.exploration_state,
      data.goal, data.hint, data.support_pos_ex, data.support_neg_ex, data.support_ind_ex,
      data.multiround, []))
  }, log)
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
*/