#!/bin/bash
set -e
echo "Starting sanity check"

echo "Current kube context"
oc cluster-info

if [[ "$(params.kubeconfig)" != "" ]]; then
    echo "Switching kubeconfig context"
    echo $(params.kubeconfig) | base64 --decode > remote.kubeconfig
    export KUBECONFIG=$TOP/remote.kubeconfig
    oc cluster-info
fi

echo "Done sanity check"
set +e