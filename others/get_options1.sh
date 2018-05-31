#!/bin/bash
# ref: https://shellscript.sunone.me/parameter.html


MDNAME=`basename $0`
if [ $# -ne 2 ]; then
  echo "Usage: $CMDNAME file1 file2" 1>&2
  exit 1
fi

exit 0

