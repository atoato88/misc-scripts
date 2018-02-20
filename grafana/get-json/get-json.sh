#!/bin/bash

list=$(kubectl get configmap kube-prometheus-grafana -o json | jq -r ".data | keys | .[]")
for e in $list; do kubectl get configmap kube-prometheus-grafana -o json | jq -r .data.\"$e\" > ./$e ; done

