#! /usr/bin/env python
import json
from pprint import pprint
from js import esprimaToBoogie
from mturk_util import error, connect, mkParser
from experiments import *
import boogie_ast
from boogie_z3 import *
from z3 import *
import os
import time

def equiv(boogie1, boogie2):
    [p1,p2] = [expr_to_z3(p, AllIntTypeEnv()) for p in [boogie1, boogie2]]
    s = Solver()
    s.add(Not(p1 == p2))
    r = s.check()
    return r == unsat

p = mkParser("Process logs for experiment")
p.add_argument('experiment_id', type=int, help='ID of experiment to process logs for')

args = p.parse_args()

e = Experiment(args.experiment_id)
mc = connect(args.credentials_file, args.sandbox)

for s in e.sessions:
    print "\n** Session " + str(s.sess_id)

    print "++ Survey"

    r = mc.get_assignments(s.hit_id)
    assert(len(r) == 0 or len(r) == 1)
    if len(r) == 1:
        assn = r[0]
        answers = {}
        for ans in assn.answers[0]:
            if (len(ans.fields) > 0):
                answers[ans.qid] = ans.fields[0]
        q = ["fun", "challenging", "likes", "dislikes", "suggestions", "experience"]
        print "\n".join(["-- " + n + ": " + str(answers[n]) for n in q if n in answers])
    else:
        print "HIT not completed"

    # process logs
    fname = get_event_log_fname(args.experiment_id, s.sess_id)
    with open(fname) as f:
        for line in f:
            data = json.loads(line)
            if data["method"] == "logEvent":
                method_args = data["args"]
                event_name = method_args[0]
                if event_name == "FinishLevel":
                    event_args = method_args[1]
                    lvl_set = event_args[0]
                    lvl_id = event_args[1]
                    proved_the_level = event_args[2]
                    js_invs = event_args[3]
                    canon_invs = event_args[4]

                    print "++ " + lvl_set + "." + lvl_id
                    print "-- " + ("Finished and Proved" if proved_the_level else "Finished and Not Proved")
                    print "-- IP: " + data["ip"]
                    print "-- Time: " + str(time.asctime(time.localtime(data["time"])))
                    print "-- User invs: " + ", ".join(js_invs)

                    boogie_user_invs = [ esprimaToBoogie(x, {}) for x in canon_invs ]
                    try:
                        with open(os.path.join(get_lvlset_dir(lvl_set), lvl_id + ".soln")) as f:
                            for l in f:
                                boogie_soln_inv = boogie_ast.parseExprAst(l)[0]
                                header = "-- Soln " + str(boogie_soln_inv) + ": "
                                found = False
                                for boogie_user_inv in boogie_user_invs:
                                    if equiv(boogie_soln_inv, boogie_user_inv):
                                        print header + "Found equiv in user canon pred: " + str(boogie_user_inv) + "]"
                                        found = True
                                if not found:
                                    print header + "No equiv found"
                    except IOError:
                        print "-- No .soln file"