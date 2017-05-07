#! /usr/bin/env python
from traceback import print_exc
from mturk_util import error, connect, mkParser


p = mkParser("Disable HIT")
p.add_argument('--hitids', nargs='+', type=str,
               help='IDs of the HITs to disable.')
args = p.parse_args()

try:
    mc = connect(args.credentials_file, args.sandbox)
    for hitid in args.hitids:
        print "Disabling", hitid
        r = mc.disable_hit(hitid)
except Exception,e:
    print_exc()
    error("Failed...")
