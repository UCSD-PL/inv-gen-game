#! /usr/bin/env bash

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

pushd $MYDIR/src/harness/dilig/
make
popd
pushd $MYDIR/intro-benchmarks
make
popd
pushd $MYDIR/intro-benchmarks-pruned
make
popd
pushd $MYDIR/test-benchmarks
make
popd
pushd $MYDIR/src/static
make
popd
