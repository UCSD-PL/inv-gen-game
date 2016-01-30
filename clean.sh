#! /usr/bin/env bash

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

pushd $MYDIR/intro-benchmarks
make clean
popd
pushd $MYDIR/src/harness/dilig/
make clean
popd
pushd $MYDIR/src/static
make clean
popd
