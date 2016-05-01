#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
from boto.mturk.connection import *
from datetime import *
from common import error, connect, mkParser


p = mkParser("Dispose of a HIT")
p.add_argument('HITId', type=str, help='ID Of the HIT To expire.')
args = p.parse_args()

try:
    mc = connect(args.credentials_file, args.sandbox)
    r = mc.dispose_hit(args.HITId)
except Exception,e:
    print_exc()
    error("Failed...")
