#!/bin/bash

export POD_NAME=$(kubectl get pods -n prometheus | grep prometheus-server | cut -d ' ' -f 1)
echo ${POD_NAME}
kubectl --namespace prometheus port-forward ${POD_NAME} 8090:9090


