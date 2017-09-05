#!/bin/bash

kubectl-check() {
  echo -----
  kubectl get nodes
  if [[ $? == 0 ]]
  then
    echo $(date): OK
  else
    echo $(date): NG
  fi
  echo -----
}

while true
do
  kubectl-check
  sleep 1
done

exit 0
