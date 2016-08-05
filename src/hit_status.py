#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
from boto.mturk.qualification import *
from boto.mturk.connection import *
from datetime import *
from mturk_util import *
from experiments import *
import os
import signal

p = mkParser("Print HIT status", True)
args = parse_args(p)

e = load_experiment_or_die(args.ename)
mc = connect(args.credentials_file, args.sandbox)

hit_status(mc, e, args.sandbox)
