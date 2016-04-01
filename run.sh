#! /usr/bin/env bash

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

if [[ $# -eq 1 ]] ; then
  python $MYDIR/src/server.py --log $1
else
  python $MYDIR/src/server.py
fi

