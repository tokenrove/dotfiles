#!/bin/sh
#
# Update old dotfile style fu to new ~/etc fu
#
# $Id$
#

if [ $# -ne 1 ]; then
  echo $0: bad arguments
  exit 1
fi

if [ ! -d etc -o ! -d etc/md5 ]; then
  echo $0: "can't" find directories
  exit 1
fi

if [ ! -f $1 -o ! -r $1 ]; then
  echo $0: $1: not a file or not readable
  exit 1
fi

foo=`echo $1 | sed -e s/^[.]//`
mv $1 etc/$foo
ln -sf etc/$foo $1
md5sum etc/$foo > etc/md5/etc.md5.$foo
echo $foo >> etc/etc.index

exit 0

# EOF etc.updatedotfile.sh
