#!/bin/bash

#ref: https://kubernetes.io/ja/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux

VERSION=${1:-v1.18.0}
# you can select any of amd64, arm64, arm.
ARCH=${2:-amd64}

curl -LO https://storage.googleapis.com/kubernetes-release/release/${VERSION}/bin/linux/${ARCH}/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version
