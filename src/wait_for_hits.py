#! /usr/bin/env python
from mturk_util import connect, hit_status, mkParser, send_notification
from experiments import load_experiment_or_die
import time
import datetime

p = mkParser("Wait for HITs", True)
p.add_argument('--delay', type=int, default = 600, \
        help = "Number of seconds to wait between checks; " +\
               "if none provided, use 600 seconds")
p.add_argument('--email', type=str, required=True,
        help = "Email to notify")
args = p.parse_args()

e = load_experiment_or_die(args.ename)
mc = connect(args.credentials_file, args.sandbox)

notification_subj = "Inv-Game Experiment Notifaction"
previous_num_left = None
while 1:
    print("")
    num_left = hit_status(mc, e, args.sandbox)
    if num_left == 0:
        print("All HITs in this experiment are done")
        send_notification(args.email, notification_subj, \
                "All hits in experiment {0} are done.".format(args.ename))
        exit (0)
    else:
        if previous_num_left != None and previous_num_left != num_left:
            done_in_period = previous_num_left - num_left
            send_notification(args.email, notification_subj,
              "An additional {0} HIT(s) are done in experiment {1}." +\
              " {2} HIT(s) left.".format(done_in_period, args.ename, num_left))
        previous_num_left = num_left
        print("\nHITS left :", num_left)
        print("Time      :", str(datetime.datetime.now()))
        print("Sleeping  :", args.delay, "seconds")
        time.sleep(args.delay)
