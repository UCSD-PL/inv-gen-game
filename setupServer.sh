#! /usr/bin/env bash

  PY="$(which python3)"

if [ ! -d "env" ] ; then
  echo "Directory env does not exist. Creating..."
  mkdir env
fi

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$( cd env && pwd )"

$PY -m venv $DIR

source $DIR/bin/activate

 PY="$(which python3)"

$PY -m pip install -r requirements.txt

if [ ! -d $DIR/third_party ] ; then
  mkdir $DIR/third_party
fi

if [ ! -e $DIR/bin/z3 ]; then
  pushd $DIR/third_party
  git clone https://github.com/Z3Prover/z3.git z3
  cd z3
  python scripts/mk_make.py --prefix=$DIR --python
  cd build
  make -j 8
  make install
  popd
fi

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
pushd $MYDIR/src/frontend
make
popd

deactivate

# which node;
# if [[ $? -ne 0 ]]; then
#   echo "node not found! Please make sure nodejs is installed"
#   exit -1
# fi

# npm install

echo "export JAVA_HOME=\${JAVA_HOME:-\$(dirname \$(dirname \$(dirname \$(readlink -f \$(/usr/bin/which java)))))}" >> $DIR/bin/activate
# echo "export PATH=\$PATH:$MYDIR/node_modules/.bin/" >> $DIR/bin/activate


# tar cvf server.tar env
# tar --exclude='src/static' rvf server.tar src
# tar rvf server.tar lvlsets
# tar rvf server.tar dilig-benchmarks
# tar rvf server.tar ice-benchmarks
# tar rvf server.tar max-benchmarks
# tar rvf server.tar node_modules
# tar rvf server.tar sv_auto_trans
# tar rvf server.tar sv_manual_trans
# tar rvf server.tar run.sh
# tar rvf server.tar requirements.txt

echo "Server image created in server.tar"
