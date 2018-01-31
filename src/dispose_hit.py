#! /usr/bin/env python
from traceback import print_exc
from mturk_util import error, connect, mkParser


p = mkParser("Dispose of a HIT")
p.add_argument('--hitids', nargs='+', type=str,
        help='IDs of the HITs to dispose.')
args = p.parse_args()

try:
    mc = connect(args.credentials_file, args.sandbox)
    for hitid in args.hitids:
        print("Disposing", hitid)
        r = mc.dispose_hit(hitid)
except Exception as e:
    print_exc()
    error("Failed...")
