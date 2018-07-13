#!/bin/bash

set -e


echo "Starting SSH ..."
service ssh start


cd /app/src
source ../env/bin/activate
Z3_LIBRARY_PATH=/app/env/lib/libz3.so
python3 server.py --log useractions.log --lvlset $LEVEL_SET --db mysql+pymysql://$SQL_CONNECTION --adminToken $ADMIN_TOKEN --timeout 60