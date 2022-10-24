#!/bin/bash
set -e

CLUSTER_NAME=${1:-acmsre-sno-cf7h6}
HUB_KUBECONFIG=${2:-/Users/cdoan/Downloads/playback-next-0-jsc47-admin-kubeconfig-acm.yaml}
SPOKE_KUBECONFIG=${3:-}

if [ -z $HUB_KUBECONFIG ]; then
  echo "HUB_KUBECONFIG ($HUB_KUBECONFIG) is not defined, exiting ..."
  exit 1
fi
if [ -z $SPOKE_KUBECONFIG ]; then
  echo "Checking if the kubeconfig exists in the managed cluster namespace ..."
  if oc get secret -n $CLUSTER_NAME -o name --kubeconfig=$HUB_KUBECONFIG | grep admin-kubeconfig; then
    ADMIN_KUBECONFIG=$(oc get secret -n $CLUSTER_NAME -o name --kubeconfig=$HUB_KUBECONFIG | grep admin-kubeconfig)
    oc extract $ADMIN_KUBECONFIG --kubeconfig=$HUB_KUBECONFIG -n $CLUSTER_NAME --confirm
    SPOKE_KUBECONFIG=$(PWD)/kubeconfig
    echo $SPOKE_KUBECONFIG
  else
    echo "SPOKE_KUBECONFIG ($SPOKE_KUBECONFIG) is not defined, exiting ..."
    exit 1
  fi
fi

echo "hub"
oc cluster-info --kubeconfig=$HUB_KUBECONFIG
oc get ns --sort-by=.metadata.creationTimestamp --no-headers --kubeconfig=$HUB_KUBECONFIG | tail -n 10
oc get secrets -n $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG

echo "managed cluster"
oc cluster-info --kubeconfig=$SPOKE_KUBECONFIG
if oc cluster-info --kubeconfig=$SPOKE_KUBECONFIG; then
  echo "managed clsuter accessible!"
else
  exit 1
fi

oc get ns --sort-by=.metadata.creationTimestamp --no-headers --kubeconfig=$SPOKE_KUBECONFIG | tail -n 10

oc get managedcluster -A --kubeconfig=$HUB_KUBECONFIG
oc get managedclusteraddons -A --kubeconfig=$HUB_KUBECONFIG

if oc get ns $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG; then
  echo "✅ managed cluster namespace exists ..."
  if oc get secrets -n $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG | grep import; then
    set -x
    echo "✅ secrets named 'import' exists ..."
    IMPORT=$(oc get secrets -n $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG -o name| grep import)
    oc extract $IMPORT -n $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG --confirm
    oc apply -f crds.yaml --kubeconfig=$SPOKE_KUBECONFIG
    oc apply -f import.yaml --kubeconfig=$SPOKE_KUBECONFIG
    echo "✅ applied import manifest on $SPOKE_KUBECONFIG"
    set +x
  fi
fi
