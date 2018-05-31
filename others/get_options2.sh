#!/bin/bash
# ref: https://shellscript.sunone.me/parameter.html

CMDNAME=`basename $0`

while getopts ab:c: OPT
do
  case $OPT in
    "a" ) FLG_A="TRUE" ;;
    "b" ) FLG_B="TRUE" ; VALUE_B="$OPTARG" ;;
    "c" ) FLG_C="TRUE" ; VALUE_C="$OPTARG" ;;
    * ) echo "Usage: $CMDNAME [-a] [-b VALUE] [-c VALUE]" 1>&2
      exit 1 ;;
  esac
done

if [ "$FLG_A" = "TRUE" ]; then
  echo 'pass a flag'
fi

if [ "$FLG_B" = "TRUE" ]; then
  echo 'pass b flag'
  echo "with value: $VALUE_B"
fi

if [ "$FLG_C" = "TRUE" ]; then
  echo 'pass c flag'
  echo "with value: $VALUE_C"
fi

exit 0
