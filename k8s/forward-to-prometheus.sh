#!/bin/bash

TARGET_CONTEXT=${1:-"cluster"}

export POD_NAME=$(kubectl --context ${TARGET_CONTEXT} get pods -n prometheus | grep prometheus-server | cut -d ' ' -f 1)
echo ${POD_NAME}

while :
do 
  kubectl --context ${TARGET_CONTEXT} --namespace prometheus port-forward ${POD_NAME} 8090:9090
  date
  echo
done


