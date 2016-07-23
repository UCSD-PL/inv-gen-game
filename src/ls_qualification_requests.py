#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
from boto.mturk.connection import *
from datetime import *
from mturk_util import error, connect, mkParser
from json import loads

p = mkParser("Publish a HIT for playing the game")
p.add_argument("--qualtype", type=str, help="Qualification Type Identifier");
p.add_argument("--logfile", type=str, help="Path to server log file where codes are emitted");
args = p.parse_args()

mc = connect(args.credentials_file, args.sandbox)

def getCodes(log_file):
    codes = set()
    for l in open(log_file):
        t = loads(l);
        if (t['method'] == 'getRandomCode'):
            codes.add(t['res'])

    return codes

codes = getCodes(args.logfile);

try:
    balance = mc.get_account_balance()
    print "Balance:", balance[0]
    r = mc.get_qualification_requests(args.qualtype)
    print "Id                             Submitted            Worker         Code  Correct?"
    for qt in r:
        answers = qt.answers
        code = answers[0][0].fields[0]
        print qt.QualificationRequestId, qt.SubmitTime, qt.SubjectId, code, code in codes
except Exception,e:
    print_exc()
    error("Failed...")
