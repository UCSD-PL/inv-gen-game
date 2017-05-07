#! /usr/bin/env python
from traceback import print_exc
from mturk_util import error, connect, mkParser


p = mkParser("Approve an Assignment")
p.add_argument('AssignmentId', type=str,
        help='ID Of the Assignment to approve.')
p.add_argument('--feedback', type=str,
        help='Additional feedback', default=None)
args = p.parse_args()

try:
    mc = connect(args.credentials_file, args.sandbox)
    r = mc.approve_assignment(args.AssignmentId, args.feedback)
except Exception,e:
    print_exc()
    error("Failed...")
