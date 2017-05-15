#! /usr/bin/env bash

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
ENAME="$1"
python $MYDIR/src/server.py --port 5000 --lvlset lvlsets/unsolved.lvlset --adminToken 1 --ename $ENAME --log logs/$ENAME/$ENAME.log --db logs/$ENAME/events.db
