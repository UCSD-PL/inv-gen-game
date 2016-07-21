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
p.add_argument('--ename', type=str, default = "default", help='Name for experiment; if none provided, use "default"')

args = p.parse_args()

e = create_experiment_or_die(args.ename)
mc = connect(args.credentials_file, args.sandbox)

print "HIT ID                         Assignment ID                  Worker ID"

changed = False
workers = set()
for sr in e.server_runs:
    r = mc.get_assignments(sr.hit_id)
    assert(len(r) == 0 or len(r) == 1)
    if len(r) == 1:
        assn = r[0]
        print sr.hit_id, assn.AssignmentId, assn.WorkerId
        if assn.WorkerId in workers:
            print "WARNING, duplicate worker in experiment:", assn.WorkerId
        else:
            workers.add(assn.WorkerId)
        if (sr.pid != 0):
            try:
                os.kill(sr.pid, signal.SIGTERM)
            except:
                print "Could not kill process " + str(sr.pid) + ", probably already dead"
            sr.pid = 0
            changed = True
    else:
        print sr.hit_id, "not completed                  not completed"
if changed:
    e.store_server_runs()
