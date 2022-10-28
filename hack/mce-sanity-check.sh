#!/bin/bash

set -e
echo "Starting sanity check"

TOP=$(pwd)

echo "Current kube context"
oc cluster-info

if [[ "$K" != "" ]]; then
    echo "Switching remote kubeconfig context"
    echo "$K" | base64 --decode > $TOP/remote.kubeconfig
    export KUBECONFIG=$TOP/remote.kubeconfig
    oc cluster-info
fi

echo "Done sanity check"
set +e
