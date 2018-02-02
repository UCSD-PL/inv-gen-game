#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export MYPYPATH=$DIR/src/stubs
FLAGS='--show-traceback --disallow-untyped-defs'

if [[ $# -eq 0 ]] ; then
  mypy $FLAGS $DIR/src/lib/boogie/*.py
else
  mypy $FLAGS $1
fi
