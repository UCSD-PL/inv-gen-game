#! /usr/bin/env bash

if [[ $# -ne 1 ]] ; then
  echo "Usage $0 <target-directory>"
  exit -1
fi

if [ ! -d "$1" ] ; then
  echo "Directory $1 does not exist. Creating..."
  mkdir $1
fi

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$( cd $1 && pwd )"


virtualenv $DIR

source $DIR/bin/activate

pip install flask
pip install flask-jsonrpc

#mkdir $DIR/third_party
#pushd $DIR/third_party
#git clone https://github.com/Z3Prover/z3.git z3
#cd z3
#python scripts/mk_make.py --prefix=$DIR --python
#cd build
#make -j 8
#make install
#popd

deactivate

echo "To begin developing run source $DIR/bin/activate and then make"
