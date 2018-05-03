#!/bin/bash

set -e



echo "Starting SSH ..."

service ssh start



source ../env/bin/activate
python3 server.py --local --log useractions.log --lvlset ../lvlsets/unsolved-leftover-split.lvlset --db mysql+pymysql://gamification:m58xXuH5VBuWXtaW@gamificationfacebook.cpepc4fuqyhq.us-west-2.rds.amazonaws.com/game --adminToken fuzzy --timeout 60