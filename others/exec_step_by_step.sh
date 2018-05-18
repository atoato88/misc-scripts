#!/bin/bash

trap 'read -p "$0($LINENO) $BASH_COMMAND"' DEBUG

ls
echo "hogehoge"

exit 0

