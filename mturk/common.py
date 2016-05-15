from traceback import *
import sys
from boto.mturk.connection import *
from argparse import *

def mkParser(desc):
  p = ArgumentParser(description=desc)
  p.add_argument('--credentials_file', type=str,
                  default='credentials.csv',
                  help='path to a csv file containing the AWS credentials')
  p.add_argument('--sandbox', action='store_const', const=True,
                  default=False,
                  help='if specified execute on the sandbox servers')
  return p

def error(msg):
    sys.stderr.write(msg)
    sys.exit(-1)

def connect(credentials_file, sandbox, quiet = False):
    with open(credentials_file, 'r') as f:
        f.readline();
        user, a_key, s_key = f.read().split(',')

    HOST = None if (not sandbox) else "mechanicalturk.sandbox.amazonaws.com"

    if (not quiet):
        print "Connecting to", ("production" if HOST == None else "sandbox"),\
            " as ", user, " with access key ", a_key, "..."

    try:
        mc = MTurkConnection(a_key, s_key, host=HOST)
    except:
        error("Failed connecting")

    if (not quiet):
        print "Connected."
    return mc

