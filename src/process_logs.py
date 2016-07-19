#! /usr/bin/env python
import json
from pprint import pprint
from js import esprimaToBoogie
from mturk_util import error, connect, mkParser
from experiments import *

p = mkParser("Process logs for experiment")
p.add_argument('experiment_id', type=int, help='ID of experiment to process logs for')

args = p.parse_args()

e = Experiment(args.experiment_id)
mc = connect(args.credentials_file, args.sandbox)

for s in e.sessions:
    print("Session " + str(s.sess_id))

    r = mc.get_assignments(s.hit_id)
    assert(len(r) == 0 or len(r) == 1)
    if len(r) == 1:
        assn = r[0]
        answers = {}
        for ans in assn.answers[0]:
            if (len(ans.fields) > 0):
                answers[ans.qid] = ans.fields[0]
        print answers

    # process logs
    fname = get_event_log_fname(args.experiment_id, s.sess_id)
    with open(fname) as f:
        for line in f:
            data = json.loads(line)
            if data["method"] == "logEvent":
                args = data["args"]
                event_name = args[0]
                if event_name == "FinishLevel":
                    event_args = args[1]
                    lvl_set = event_args[0]
                    lvl_id = event_args[1]
                    proved_the_level = event_args[2]
                    js_invs = event_args[3]
                    print(lvl_set + "." + lvl_id +
                          (" (Proved): " if proved_the_level else " : ") +
                          ", ".join(js_invs))
                    #invs = event_args[4]
                    #boogieInvs = [ esprimaToBoogie(x, {}) for x in invs ]
                    #print(boogieInvs)