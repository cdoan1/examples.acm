#!/bin/bash

NS=openshift-marketplace
NS2=open-cluster-management
NS3=multicluster-engine

oc apply -f catalog-source-managed-tenant-2-7-0.yaml -n openshift-marketplace
POD=$(oc get pods -l olm.catalogSource=acm-custom-registry-2-7-0 -n openshift-marketplace -o name)

oc wait --for=condition=Ready $POD -n $NS

oc apply -k base-release-2.7

oc get subscription.operators -n $NS2

oc get csv -l operators.coreos.com/advanced-cluster-management.open-cluster-management -n $NS2

oc wait --for=condition=InstallSucceeded csv advanced-cluster-management.v2.6.1 -n $NS2

oc apply -k addon-release-2.7-catalogsource
