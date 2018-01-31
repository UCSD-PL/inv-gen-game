#! /usr/bin/env python
from traceback import print_exc
from mturk_util import error, connect, mkParser
from json import loads
from experiments import Experiment, get_event_log_fname

p = mkParser("Process qualification requests")
p.add_argument("qualtype", type=str, help="Qualification Type Identifier");
p.add_argument("--ename", type=str, default='tutorial', \
        help="Experiment name under which the tutorial qualification is " +\
             "running");
args = p.parse_args()

mc = connect(args.credentials_file, args.sandbox)

def getCodes(log_file):
    codes = set()
    for l in open(log_file):
        t = loads(l);
        if (t['method'] == 'getRandomCode'):
            codes.add(t['res'])

    return codes

exp = Experiment(args.ename, True);
codesS = set()

for server_run in exp.server_runs:
    codesS = codesS.union(getCodes(get_event_log_fname(args.ename, \
                                                       server_run.srid)))

try:
    balance = mc.get_account_balance()
    print("Balance:", balance[0])
    r = mc.get_qualification_requests(args.qualtype)
    print("Id                             Submitted            " +\
          "Worker         Code  Action")
    for qt in r:
        answers = qt.answers
        code = answers[0][0].fields[0]
        correct = code in codesS

        if (correct):
            mc.grant_qualification(qt.QualificationRequestId);
            action = "approved"
        else:
            action = "nothing - you must reject manually"

        print(qt.QualificationRequestId, qt.SubmitTime, qt.SubjectId, \
              code, action)
except Exception:
    print_exc()
    error("Failed...")
