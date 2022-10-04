#!/bin/bash


NS=openshift-marketplace
NS2=open-cluster-management
NS3=multicluster-engine
NS4=open-cluster-management-agent-addon

oc get managedclusters -A
oc get managedclusteraddons -A

oc get subscription.operators -n $NS2
oc get subscription.operators -n $NS3

oc get csv -n $NS2
oc get csv -n $NS3

echo $NS2
oc get pods -n $NS2 -o yaml | grep "image:" | sort -u | grep -v f:image | sed s'#    -#     #' | sort -u
echo $NS3
oc get pods -n $NS3 -o yaml |  grep "image:" | sort -u | grep -v f:image | sed s'#    -#     #' | sort -u
echo $NS4
oc get pods -n $NS4 -o yaml |  grep "image:" | sort -u | grep -v f:image | sed s'#    -#     #' | sort -u
