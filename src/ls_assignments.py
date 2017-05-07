#! /usr/bin/env python
from traceback import print_exc
from mturk_util import error, connect, mkParser


p = mkParser("List assignments for a hit")
p.add_argument('HITId', type=str, help='HIT Id')
args = p.parse_args()

mc = connect(args.credentials_file, args.sandbox)
try:
    r = mc.get_assignments(args.HITId)
    print "Id                             Accepted             " +\
          "Status               Submited       WorkerId"
    for assn in r:
        print assn.AssignmentId, assn.AcceptTime, \
              assn.AssignmentStatus, assn.SubmitTime, \
              assn.WorkerId
except Exception,e:
    print_exc()
    error("Failed...")
