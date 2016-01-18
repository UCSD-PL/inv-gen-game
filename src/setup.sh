#! /usr/bin/env bash

if [[ $# -ne 1 ]] ; then
  echo "Usage $0 <target-directory>"
fi

DIR=$1

virtualenv $DIR

source $DIR/bin/activate

pip install flask
pip install flask-jsonrpc

#wget code.jquery.com/jquery-1.12.0.min.js
#wget code.jquery.com/jquery-migrate-1.2.1.min.js
#wget https://github.com/Textalk/jquery.jsonrpcclient.js/archive/master.zip static/jquery.jsonrpc.js

deactivate

echo "To begin developing run source $DIR/bin/activate"
