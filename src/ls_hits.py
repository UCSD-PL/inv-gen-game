#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
from boto.mturk.connection import *
from datetime import *
from lib.invgame_server.mturk_util import error, connect, mkParser


p = mkParser("Publish a HIT for playing the game")
args = p.parse_args()

mc = connect(args.credentials_file, args.sandbox)

try:
    balance = mc.get_account_balance()
    print("Balance:", balance[0])
    r = mc.get_all_hits()
    print("Id                             Created              Expires              Review Stat. Status    #Av #C")
    for hit in r:
        print(hit.HITId, hit.CreationTime, hit.Expiration, hit.HITReviewStatus, \
            hit.HITStatus, hit.NumberOfAssignmentsAvailable, " ",\
            hit.NumberOfAssignmentsCompleted)#, hit.Description
except Exception as e:
    print_exc()
    error("Failed...")
