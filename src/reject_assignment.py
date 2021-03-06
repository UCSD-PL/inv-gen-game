#! /usr/bin/env python
from traceback import print_exc
from lib.invgame_server.mturk_util import error, connect, mkParser

p = mkParser("Reject an Assignment")
p.add_argument('AssignmentId', type=str, help='ID Of the Assignment to reject.')
p.add_argument('--feedback', type=str, help='Additional feedback', default=None)
args = p.parse_args()

try:
    mc = connect(args.credentials_file, args.sandbox)
    r = mc.reject_assignment(args.AssignmentId, args.feedback)
except Exception as e:
    print_exc()
    error("Failed...")
