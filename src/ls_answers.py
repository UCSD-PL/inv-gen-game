#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
from boto.mturk.connection import *
from datetime import *
from mturk_util import error, connect, mkParser

p = mkParser("List assignments for a hit")
p.add_argument('AssignmentId', type=str,
                help='Assignment Id')
args = p.parse_args()
mc = connect(args.credentials_file, args.sandbox)

try:
    assgn, hit = mc.get_assignment(args.AssignmentId)
    print "qid         Fields"
    for ans in assgn.answers[0]:
        print ans.qid, ans.fields
except Exception,e:
    print_exc()
    error("Failed...")
