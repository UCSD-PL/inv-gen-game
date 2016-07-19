#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
from boto.mturk.qualification import *
from boto.mturk.connection import *
from datetime import *
from mturk_util import error, mkParser, connect
from experiments import *
import os
import signal

p = mkParser("Wait for HITs to finish")
p.add_argument('experiment_id', type=int, help='ID of experiment to wait for')

args = p.parse_args()
e = Experiment(args.experiment_id)
mc = connect(args.credentials_file, args.sandbox)

print "HIT ID                         Assignment ID                  Worker ID"

changed = False
workers = set()
for s in e.sessions:
    r = mc.get_assignments(s.hit_id)
    assert(len(r) == 0 or len(r) == 1)
    if len(r) == 1:
        assn = r[0]
        print s.hit_id, assn.AssignmentId, assn.WorkerId
        if assn.WorkerId in workers:
            print "WARNING, duplicate worker in experiment:", assn.WorkerId
        else:
            workers.add(assn.WorkerId)
        if (s.server_pid != 0):
            try:
                os.kill(s.server_pid, signal.SIGTERM)
            except:
                print "Could not kill process " + str(s.server_pid) + ", probably already dead"
            s.server_pid = 0
            changed = True
    else:
        print s.hit_id, "not completed                  not completed"
if changed:
    e.store_sessions()
