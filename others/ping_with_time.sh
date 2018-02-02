#!/bin/bash

HOST=${1:-"8.8.8.8"}

while :
do
  echo $(LANG=EN date; ping -c 1 -w 1 ${HOST})
  sleep 1
done

