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
oc get ns --sort-by=.metadata.creationTimestamp --no-headers --kubeconfig=$SPOKE_KUBECONFIG | tail -n 10

oc get managedcluster -A --kubeconfig=$HUB_KUBECONFIG
oc get managedclusteraddons -A --kubeconfig=$HUB_KUBECONFIG

if oc get ns $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG; then
  echo "✅ managed cluster namespace exists ..."
  if oc get secrets -n $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG | grep import; then
    echo "✅ secrets named 'import' exists ..."
  fi
fi

oc create secret generic auto-import-secret \
  -n $CLUSTER_NAME \
  --from-file=kubeconfig=$SPOKE_KUBECONFIG \
  --from-literal=autoImportRetry=5 \
  --kubeconfig=$HUB_KUBECONFIG \
  --dry-run -o yaml > auto-import-secret-$CLUSTER_NAME.yaml

oc apply -f auto-import-secret-$CLUSTER_NAME.yaml --kubeconfig=$HUB_KUBECONFIG
echo "✅ Create the auto import secret ..."

cat > managed-cluster-$CLUSTER_NAME.yaml <<EOF
apiVersion: cluster.open-cluster-management.io/v1
kind: ManagedCluster
metadata:
  name: ${CLUSTER_NAME}
  labels:
    cloud: auto-detect
    vendor: auto-detect
spec:
  hubAcceptsClient: true
EOF

oc apply -f managed-cluster-$CLUSTER_NAME.yaml --kubeconfig=$HUB_KUBECONFIG
echo "✅ Create the managed cluster CR ..."

echo "Waiting 5m for import to complete ..."
oc wait --for="condition=ManagedClusterConditionAvailable" managedcluster $CLUSTER_NAME --timeout=300s --kubeconfig=$HUB_KUBECONFIG
set +e

oc get manifestwork -n $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG

echo "😵‍💫 😵‍💫 Chaos - deleting the kluster manifestwork ..."
list=$(oc get manifestwork -n $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG -o name | grep klusterlet)
for i in $list
do
  oc delete $i -n $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG
done

echo "Deleting the manifestwork will remove the kluster from the spoke ..."
sleep 30
oc get ns --sort-by=.metadata.creationTimestamp --no-headers --kubeconfig=$SPOKE_KUBECONFIG | tail -n 10
oc get manifestwork -n $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG -o name

# echo "😵‍💫 😵‍💫 Chaos - deleting the kluster manifestwork ..."
# oc get manifestwork -n $CLUSTER_NAME --kubeconfig=$HUB_KUBECONFIG -o name
