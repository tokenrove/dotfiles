#!/bin/sh
#
# Verify the integrety of my ~/etc files ;-)
#

oldwd=`pwd`
cd $HOME/etc

. ./etc.funcs.sh || exit 1

x_fileandread etc.index
x_dirandread md5
x_cmpsum etc.index

for i in `cat etc.index`; do
  if [ ! -h ../.$i ]; then
    echo $0: $i: symlink doesn\'t exist!
    exit 1
  fi

  x_cmpsum $i
done

cd $oldwd

exit 0

# EOF etc.verinteg.sh
