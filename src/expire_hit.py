#! /usr/bin/env python
from traceback import print_exc
from mturk_util import error, connect, mkParser


p = mkParser("Expire a HIT")
p.add_argument('HITId', type=str, help='ID Of the HIT To expire.')
args = p.parse_args()

try:
    mc = connect(args.credentials_file, args.sandbox)
    r = mc.expire_hit(args.HITId)
except Exception as e:
    print_exc()
    error("Failed...")
