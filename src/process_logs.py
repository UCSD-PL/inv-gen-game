#! /usr/bin/env python
import json
from pprint import pprint
from js import esprimaToBoogie
from mturk_util import *
from experiments import *
import lib.boogie.ast
from lib.boogie.z3_embed import *
from z3 import *
import os
import time
from abc import ABCMeta, abstractmethod
from colors import color, bold

def equiv(boogie1, boogie2):
    [p1,p2] = [expr_to_z3(p, AllIntTypeEnv()) for p in [boogie1, boogie2]]
    s = Solver()
    s.add(Not(p1 == p2))
    r = s.check()
    return r == unsat

def bold_red(s):
    if args.nocolor:
        return s
    else:
        return bold(color(s,"red"))

def bold_green(s):
    if args.nocolor:
        return s
    else:
        return bold(color(s, "green"))

def log_evnt_get_ip(data):
    return data["ip"]

def log_evnt_get_time(data):
    return data["time"]

def log_evnt_get_time_str(data):
    return str(time.asctime(time.localtime(data["time"])))

def log_evnt_get_worker_id(data):
    res = data["args"][0]
    if res == "":
        return log_evnt_get_ip(data)
    else:
        return res

def log_evnt_get_name(data):
    return data["args"][1]

def log_evnt_get_params(data):
    return data["args"][2]

################################################################################
#
# Payment processing
#
###############################################################################

class Payment:
    __metaclass__ = ABCMeta
    @abstractmethod
    def make_payment(self):
        pass
    @abstractmethod
    def amount(self):
        pass

class HITPayment(Payment):
    def __init__(self, worker_id, hit_id, assn_id):
        self.worker_id = worker_id
        self.hit_id = hit_id
        self.assn_id = assn_id
    def make_payment(self):
        mc.approve_assignment(self.assn_id)
    def amount(self):
        return HIT_REWARD
    def __str__(self):
        return "${0} to {1} for completing assignment {2} in HIT {3}".format(HIT_REWARD, self.worker_id, self.assn_id, self.hit_id)

thank_you_msg = "Thank you for your work! We really appreciate it. " + \
                "Please come back and help science by playing new levels in our game. " + \
                "Search 'Sorin Lerner' in the HITs to find us!"

def level_str(n): 
    return str(n) + (" level" if n == 1 else " levels")

class LevelsPayment(Payment):
    def __init__(self, worker_id, assn_id, num_levels):
        self.worker_id = worker_id
        self.assn_id = assn_id
        self.num_levels = num_levels
        self.beyond = num_levels - REQUIRED_LEVELS_PER_HIT
        self.reward = self.beyond * BONUS_PER_LEVEL
    def make_payment(self):
        if self.reward > 0:
            msg = "You passed {0}. You get ${1} per level beyond {2}. "
            msg = msg.format(level_str(self.num_levels), BONUS_PER_LEVEL, REQUIRED_LEVELS_PER_HIT) + thank_you_msg
            mc.grant_bonus(self.worker_id, self.assn_id, mc.get_price_as_price(self.reward), msg)
    def amount(self):
        return self.reward
    def __str__(self):
        return "${0} to {1} for passing {2} beyond {3}".format(self.reward, self.worker_id, level_str(self.beyond), REQUIRED_LEVELS_PER_HIT)

class TutorialPayment(Payment):
    def __init__(self, worker_id, assn_id):
        self.worker_id = worker_id
        self.assn_id = assn_id
        self.reward = BONUS_FOR_TUTORIAL
    def make_payment(self):
        msg = "You completed the tutorial. " + thank_you_msg
        mc.grant_bonus(self.worker_id, self.assn_id, mc.get_price_as_price(self.reward), msg)
    def amount(self):
        return self.reward
    def __str__(self):
        return "${0} to {1} for finishing tutorial".format(self.reward, self.worker_id)

payments = []

def process_payments():
    print bold_green("\n** Payments")
    total = 0
    for p in payments:
        if p.amount() > 0:
            print "-- " + bold_red("NEED TO PAY") + "  : " + str(p)
            total = total + p.amount()
    print "-- TOTAL TO PAY : $" + str(total)
    balance = mc.get_account_balance()
    print "-- BALANCE      : " + str(balance[0])
    if args.pay:
        if total > balance[0].amount:
            print "-- INSUFFICIANT FUNDS to pay"
        else:
            r = raw_input("-- Proceed with all the above payments? [yes to continue] ")
            if r == "yes":
                for p in payments:
                    if p.amount() > 0:
                        p.make_payment()
                        print "-- " + bold_green("PAYED") + "        : " + str(p)
 

def add_payment(p):
    if p.amount > 0:
        payments.append(p)        

################################################################################
#
# Timing information
#
###############################################################################

class TimeEntry:
    def __init__(self, time, event_name, event_params):
        self.time = time
        self.event_name = event_name
        self.event_params = event_params

def seconds_to_str(seconds):
    m, s = divmod(round(seconds), 60)
    h, m = divmod(m, 60)
    if (h > 0):
        return "%d:%02d:%02d" % (h, m, s)
    else:
        return "%02d:%02d" % (m, s)

time_info = {}
workers = [] # keep track of workers in list to display workers in order

def add_time_info(worker_id, time, event_name, even_params):
    if worker_id in time_info:
        l = time_info[worker_id]
    else:
        l = []
        time_info[worker_id] = l
        workers.append(worker_id)
    l.append(TimeEntry(time, event_name, event_params))
             

def process_time_info():
    for worker_id in workers:
        print bold_green("\n** Timing for worker " + worker_id)
        l = time_info[worker_id]
        print "-- Total time : " + seconds_to_str(l[-1].time - l[0].time)
        curr_lvl = ""
        curr_start = 0
        for te in l:

            if te.event_name == "TutorialStart":
                curr_start = te.time
                curr_lvl = "Tutorial"

            if te.event_name == "TutorialDone":
                if curr_lvl == "Tutorial":
                    curr_lvl = ""
                    delta = te.time - curr_start
                    print "-- Tutorial : " + seconds_to_str(delta)
                else:
                    print "-- Tutorial : TutorialDone without TutorialStart" 

            if te.event_name == "StartLevel":
                lvl_set = te.event_params[0]
                lvl_id = te.event_params[1]
                curr_start = te.time
                curr_lvl = lvl_set + "." + lvl_id

            if te.event_name == "FinishLevel":
                lvl_set = te.event_params[0]
                lvl_id = te.event_params[1]
                n = lvl_set + "." + lvl_id
                if curr_lvl == n:
                    curr_lvl = ""
                    delta = te.time - curr_start
                    print "-- " + n + " : " + seconds_to_str(delta)
                else:
                    print "-- " + n + " : FinishLevel without StartLevel" 

            if te.event_name == "GameDone":
                if curr_lvl != "":
                    delta = te.time - curr_start
                    print "-- " + curr_lvl + " (interrupted by GameDone): " + seconds_to_str(delta)
                    

################################################################################
#
# Main processing
#
###############################################################################

p = mkParser("Process logs for experiment", True)
p.add_argument('--pay', action='store_const', const=True, default=False, help='if specified pay workers that need to be payed')
p.add_argument('--nocolor', action='store_const', const=True, default=False, help='if specified do not use colors')

args = parse_args(p)

e = load_experiment_or_die(args.ename)

mc = connect(args.credentials_file, args.sandbox)

for s in e.server_runs:
    print "\n** Server run " + str(s.srid)

    print bold_green("++ HIT Status")

    assn_worker_id = None
    assn_id = None
    need_to_pay = False
    found_game_done = False
    hit_completed = False

    try:
        r = mc.get_assignments(s.hit_id)
    except:
        print "-- " + s.hit_id + " cannot get HIT; it was probably in " + ("production" if sandbox else "sandbox")
        continue
    
    assert(len(r) == 0 or len(r) == 1)
    if len(r) == 0:
        print "-- HIT: " + s.hit_id + " not completed"
    else:
        print "-- HIT: " + s.hit_id + " completed"
        assn = r[0]
        assn_worker_id = assn.WorkerId
        assn_id = assn.AssignmentId
        print "-- Assignment ID: " + assn_id
        print "-- Worker ID: " + assn_worker_id
        print "-- Assignment Status: " + assn.AssignmentStatus 
        need_to_pay = assn.AssignmentStatus == "Submitted" # vs "Approved"
        if need_to_pay:
            add_payment(HITPayment(assn_worker_id, s.hit_id, assn_id))
        answers = {}
        for ans in assn.answers[0]:
            if (len(ans.fields) > 0):
                answers[ans.qid] = ans.fields[0]
        q = ["fun", "challenging", "likes", "dislikes", "suggestions", "experience"]
        print "\n".join(["-- " + n + ": " + str(answers[n]) for n in q if n in answers])

    # process logs
    fname = get_event_log_fname(args.ename, s.srid)
    with open(fname) as f:
        for line in f:
            data = json.loads(line)
            if data["method"] == "logEvent":
                ip = log_evnt_get_ip(data)
                time_str = log_evnt_get_time_str(data)
                time_float = log_evnt_get_time(data)
                worker_id = log_evnt_get_worker_id(data)
                event_name = log_evnt_get_name(data)
                event_params = log_evnt_get_params(data)

                add_time_info(worker_id, time_float, event_name, event_params)

                if event_name == "FoundInvariant":
                    [lvl_set, lvl_id, js_inv, canon_inv] = event_params

                    print bold_green("++ FoundInv: " + lvl_set + "." + lvl_id)
                    print "-- Worker ID: " + worker_id + ( "" if worker_id == assn_worker_id else " (NOTE: different from worker ID in assignment)")
                    print "-- IP: " + ip
                    print "-- Time: " + time_str
                    print "-- User inv: " + js_inv
                    

                if event_name == "StartLevel":
                    [lvl_set, lvl_id] = event_params
                    print bold_green("++ Started: " + lvl_set + "." + lvl_id)
                    print "-- Time: " + time_str
                

                if event_name == "FinishLevel":
                    [lvl_set, lvl_id, proved_the_level, js_invs, canon_invs] = event_params

                    print bold_green("++ Finished: " + lvl_set + "." + lvl_id)
                    print "-- " + ("Proved" if proved_the_level else "Not Proved")
                    print "-- Worker ID: " + worker_id + ( "" if worker_id == assn_worker_id else " (NOTE: different from worker ID in assignment)")
                    print "-- IP: " + ip
                    print "-- Time when finished: " + time_str
                    print "-- User invs: " + ", ".join(js_invs)

                    boogie_user_invs = [ esprimaToBoogie(x, {}) for x in canon_invs ]
                    try:
                        with open(os.path.join(get_lvlset_dir(lvl_set), lvl_id + ".soln")) as f:
                            for l in f:
                                boogie_soln_inv = ast.parseExprAst(l)
                                header = "-- Soln " + str(boogie_soln_inv) + ": "
                                found = False
                                for boogie_user_inv in boogie_user_invs:
                                    if equiv(boogie_soln_inv, boogie_user_inv):
                                        print header + "Found as user predicate (canon version): " + str(boogie_user_inv)
                                        found = True
                                if not found:
                                    print header + "No equiv found"
                    except IOError:
                        print "-- No .soln file"

                if event_name == "GameDone":
                    [num_levels] = event_params
                    print bold_green("++ GameDone: " + worker_id + " finished " + str(num_levels) + " levels")
                    print "-- Time: " + time_str
                    if need_to_pay and worker_id == assn_worker_id:
                        found_game_done = True
                        add_payment(LevelsPayment(worker_id, assn_id, num_levels))

                if event_name == "TutorialStart":
                    print bold_green("++ " + worker_id + " started tutorial")
                    print "-- Time: " + time_str

                if event_name == "TutorialDone":
                    print bold_green("++ " + worker_id + " finished tutorial")
                    print "-- Time: " + time_str
                    if need_to_pay and worker_id == assn_worker_id:
                        add_payment(TutorialPayment(worker_id, assn_id))


    if need_to_pay and not found_game_done:
        print "!! ERROR: Need to pay {0} but could not find GameDone event to pay bonus".format(assn_worker_id)

process_time_info()

process_payments()
