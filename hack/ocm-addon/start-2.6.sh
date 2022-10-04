#!/bin/bash

NS=openshift-marketplace
NS2=open-cluster-management
NS3=multicluster-engine
NS4=open-cluster-management-agent-addon
NS5=open-cluster-management-agent

oc apply -f catalog-source-managed-tenant-2-6-0.yaml -n openshift-marketplace
sleep 2

POD=$(oc get pods -l olm.catalogSource=acm-custom-registry-2-6-0 -n openshift-marketplace -o name)
oc wait --for=condition=Ready $POD -n $NS

oc apply -k base-release-2.6
sleep 2

oc get subscription.operators -n $NS2
oc get csv -l operators.coreos.com/advanced-cluster-management.open-cluster-management -n $NS2
oc wait --for=condition=InstallSucceeded csv advanced-cluster-management.v2.6.0 -n $NS2

oc apply -k addon-release-2.6-catalogsource
oc wait --for="condition=ManagedClusterConditionAvailable" managedcluster local-cluster --timeout=300s
