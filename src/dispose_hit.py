#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
from boto.mturk.connection import *
from datetime import *
from mturk_util import error, connect, mkParser


p = mkParser("Dispose of a HIT")
p.add_argument('--hitids', nargs='+', type=str, help='IDs of the HITs to dispose.')
args = p.parse_args()

try:
    mc = connect(args.credentials_file, args.sandbox)
    for hitid in args.hitids:
        print "Disposing", hitid
        r = mc.dispose_hit(hitid)
except Exception,e:
    print_exc()
    error("Failed...")
