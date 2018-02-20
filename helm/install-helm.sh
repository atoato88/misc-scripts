#!/bin/bash

set -x

## install ##

#cd ${HOME}
curl -O https://storage.googleapis.com/kubernetes-helm/helm-v2.8.0-linux-amd64.tar.gz

tar -zxvf helm-v2.8.0-linux-amd64.tar.gz

mv -f linux-amd64/helm /usr/local/bin/helm

helm help


## init ##

kubectl create serviceaccount tiller --namespace kube-system
cat <<EOF > rbac-config.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOF

kubectl create -f rbac-config.yaml

helm init --service-account tiller

kubectl get pods -n kube-system

echo "run: helm repo update"


exit 0
