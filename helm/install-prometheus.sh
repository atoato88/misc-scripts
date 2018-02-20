#!/bin/bash

set -x

NAME="prometheus"
kubectl create namespace ${NAME}
kubectl create clusterrolebinding prometheus --clusterrole=cluster-admin --serviceaccount=prometheus:default
helm install stable/prometheus --namespace ${NAME}

cat <<EOF > pv-prom01.yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-prom01
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 8Gi
  hostPath:
    path: /tmp/pv-prom01
  persistentVolumeReclaimPolicy: Recycle
EOF

cat <<EOF > pv-prom02.yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-prom02
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 8Gi
  hostPath:
    path: /tmp/pv-prom02
  persistentVolumeReclaimPolicy: Recycle
EOF

kubectl create -f pv-prom01.yaml
kubectl create -f pv-prom02.yaml

export POD_NAME=$(kubectl get pods --namespace ${NAME} -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace prometheus port-forward $POD_NAME 8090:9090

