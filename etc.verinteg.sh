#!/bin/sh
#
# Verify the integrety of my ~/etc files ;-)
#

oldwd=`pwd`
cd $HOME/etc

function x_fileandread ()
{
  if [ ! -e $1 ]; then
    echo $0: $1 doesn\'t exist!
    exit 1
  fi
  if [ ! -f $1 ]; then
    echo $0: $1 isn\'t a normal file!
    exit 1
  fi
  if [ ! -r $1 ]; then
    echo $0: $1 isn\'t readable!
    exit 1
  fi
}

function x_dirandread ()
{
  if [ ! -e $1 ]; then
    echo $0: $1 doesn\'t exist!
    exit 1
  fi
  if [ ! -d $1 ]; then
    echo $0: $1 isn\'t a directory!
    exit 1
  fi
  if [ ! -r $1 ]; then
    echo $0: $1 isn\'t readable!
    exit 1
  fi
}

function x_dirandwrite ()
{
  if [ ! -e $1 ]; then
    echo $0: $1 doesn\'t exist!
    exit 1
  fi
  if [ ! -d $1 ]; then
    echo $0: $1 isn\'t a directory!
    exit 1
  fi
  if [ ! -w $1 ]; then
    echo $0: $1 isn\'t writable!
    exit 1
  fi
}

function x_cmpsum ()
{
  x_fileandread $1
  x_fileandread md5/etc.md5.$1

  md5sum $1 | cmp - md5/etc.md5.$1
  if [ $? -ne 0 ]; then
    echo $0: $1: corruption detected!
    exit 1
  fi
}




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
