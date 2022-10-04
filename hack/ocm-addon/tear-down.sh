#!/bin/bash

echo "tear down ..."

NS=openshift-marketplace
NS2=open-cluster-management
NS3=multicluster-engine

set -x

#oc patch rolebinding open-cluster-management:managedcluster:local-cluster:work -n local-cluster --type json -p '[{ "op": "remove", "path": "/metadata/finalizers" }]'

oc delete managedcluster local-cluster
oc delete mce --all -n multicluster-engine
oc delete mch --all -n open-cluster-management

oc delete csv -l operators.coreos.com/advanced-cluster-management.open-cluster-management -n $NS2
oc get subscriptions.operators -n open-cluster-management
oc delete -k base-release-2.6

oc delete catalogsource acm-custom-registry-2-6-0 -n openshift-marketplace

oc delete ns open-cluster-management-agent-addon
oc delete ns open-cluster-management-agent

set +x

exit 0
