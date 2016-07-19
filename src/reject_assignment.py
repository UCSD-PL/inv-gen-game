#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
from boto.mturk.connection import *
from datetime import *
from mturk_util import error, connect, mkParser


p = mkParser("Reject an Assignment")
p.add_argument('AssignmentId', type=str, help='ID Of the Assignment to reject.')
p.add_argument('--feedback', type=str, help='Additional feedback', default=None)
args = p.parse_args()

try:
    mc = connect(args.credentials_file, args.sandbox)
    r = mc.reject_assignment(args.AssignmentId, args.feedback)
except Exception,e:
    print_exc()
    error("Failed...")
