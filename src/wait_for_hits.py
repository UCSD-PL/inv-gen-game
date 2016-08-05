#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
from boto.mturk.qualification import *
from boto.mturk.connection import *
from datetime import *
from mturk_util import *
from experiments import *
import os
import signal
import time
import datetime

p = mkParser("Wait for HITs", True)
p.add_argument('--delay', type=int, default = 600, help = "Number of seconds to wait between checks; if none provided, use 600 seconds")
args = parse_args(p)

e = load_experiment_or_die(args.ename)
mc = connect(args.credentials_file, args.sandbox)

notification_subj = "Inv-Game Experiment Notifaction"
previous_num_left = None
while 1:
    print ""
    num_left = hit_status(mc, e, args.sandbox)
    if num_left == 0:
        print "All HITs in this experiment are done"
        send_notification("lerner@eng.ucsd.edu", notification_subj, "All hits in experiment {0} are done.".format(args.ename))
        exit (0)
    else:
        if previous_num_left != None and previous_num_left != num_left:
            done_in_period = previous_num_left - num_left
            send_notification("lerner@eng.ucsd.edu", notification_subj,
                              "An additional {0} HIT(s) are done in experiment {1}. {2} HIT(s) left.".format(done_in_period, args.ename, num_left))
        previous_num_left = num_left
        print "\nHITS left :", num_left
        print   "Time      :", str(datetime.datetime.now())
        print   "Sleeping  :", args.delay, "seconds"
        time.sleep(args.delay)
