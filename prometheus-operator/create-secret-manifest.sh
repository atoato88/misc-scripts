#!/bin/bash

if [[ -z ${1}  ]]
then
  echo please specify filepath at first parameter.
  exit 1
fi

FILE=${1}

CONTENTS=$(cat ${FILE} | base64 -w 0)

kubectl get secrets alertmanager-kube-prometheus -o json | jq ".data.\"$(basename ${FILE})\" |= \"${CONTENTS}\" "

