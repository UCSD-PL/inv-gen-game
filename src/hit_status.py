#! /usr/bin/env python
from lib.invgame_server.mturk_util import mkParser, connect, hit_status
from lib.invgame_server.experiments import load_experiment_or_die
import os
import signal

p = mkParser("Print HIT status", True)
args = p.parse_args()

e = load_experiment_or_die(args.ename)
mc = connect(args.credentials_file, args.sandbox)

hit_status(mc, e, args.sandbox)
