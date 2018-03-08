#!/bin/bash
# forward to pod on k8s

TARGET_CONTEXT=${1:-"cluster"}
NAMESPACE=${2:-"prometheus"}
LOCAL_PORT=${4:-8090}
REMOTE_PORT=${5:-9090}

if [[ -z ${3} ]]
then
  export POD_NAME=$(kubectl --context ${TARGET_CONTEXT} get pods -n ${NAMESPACE} | grep prometheus-server | cut -d ' ' -f 1)
else
  export POD_NAME=${3}
fi

echo ${POD_NAME}

while :
do 
  kubectl --context ${TARGET_CONTEXT} --namespace ${NAMESPACE} port-forward ${POD_NAME} ${LOCAL_PORT}:${REMOTE_PORT}
  date
  echo
done


