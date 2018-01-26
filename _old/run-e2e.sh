#!/bin/bash

export KUBECONFIG=~/.kube/config
export KUBERNETES_CONFORMANCE_TEST=true
export KUBERNETES_PROVIDER=skeleton

export E2E_REPORT_DIR=~/e2e-result-xml

if [ ! -d ${E2E_REPORT_DIR} ]
then
  echo Create directory : ${E2E_REPORT_DIR}
  mkdir -p ${E2E_REPORT_DIR}
fi

OLD_PWD=${PWD}
cd $GOPATH/src/k8s.io/kubernetes

echo ----- Start e2e test -----
START_TIME=$(date)
go run hack/e2e.go -- -v --test --test_args="--ginkgo.focus=\[Conformance\] --ginkgo.skip=\[Slow\]"
END_TIME=$(date)
echo ----- End e2e test -----
echo

cd ${OLD_PWD}

echo 'e2e start : ' ${START_TIME}
echo 'e2e end   : ' ${END_TIME}
echo Test result is placed below.
ls -la ${E2E_REPORT_DIR}

exit 0

