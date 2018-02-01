#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export MYPYPATH=$DIR/src/stubs

if [[ $# -eq 0 ]] ; then
  mypy $DIR/src/lib/boogie/*.py
else
  mypy $1
fi
