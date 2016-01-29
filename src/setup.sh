#! /usr/bin/env bash

if [[ $# -ne 1 ]] ; then
  echo "Usage $0 <target-directory>"
  exit -1
fi

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=$1

virtualenv $DIR

source $DIR/bin/activate

pip install flask
pip install flask-jsonrpc

#wget code.jquery.com/jquery-1.12.0.min.js
#wget code.jquery.com/jquery-migrate-1.2.1.min.js
#wget https://github.com/Textalk/jquery.jsonrpcclient.js/archive/master.zip static/jquery.jsonrpc.js

deactivate

pushd $MYDIR/harness/dilig
make
popd
pushd $MYDIR/../intro-benchmarks
make
popd

pushd $MYDIR/static

wget http://code.jquery.com/jquery-1.12.0.min.js
wget https://raw.githubusercontent.com/Textalk/jquery.jsonrpcclient.js/master/jquery.jsonrpcclient.js
wget https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css
wget https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css
wget https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js

echo "To begin developing run source $DIR/bin/activate"
