#!/bin/bash

FILE="alertmanager.yaml"

kubectl get secrets alertmanager-kube-prometheus -o yaml | yq -r .data.\"${FILE}\" | base64 -d > ${FILE}

echo extracted to ./${FILE}
