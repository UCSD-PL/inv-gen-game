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

if [ ! -e $DIR/third_party/boogie ]; then
  pushd $DIR/third_party
  git clone https://github.com/boogie-org/boogie.git
  cd boogie
  wget -4 https://nuget.org/nuget.exe
  mono ./nuget.exe restore Source/Boogie.sln
  mozroots --import --sync
  xbuild Source/Boogie.sln
  ln -s $DIR/third_party/z3/build/z3 Binaries/z3.exe
  popd
fi

deactivate

# which node;
# if [[ $? -ne 0 ]]; then
#   echo "node not found! Please make sure nodejs is installed"
#   exit -1
# fi

# npm install

echo "export JAVA_HOME=\${JAVA_HOME:-\$(dirname \$(dirname \$(dirname \$(readlink -f \$(/usr/bin/which java)))))}" >> $DIR/bin/activate
# echo "export PATH=\$PATH:$MYDIR/node_modules/.bin/" >> $DIR/bin/activate

echo "To begin developing run source $DIR/bin/activate and then make"
