#! /usr/bin/env python
from traceback import print_exc
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
