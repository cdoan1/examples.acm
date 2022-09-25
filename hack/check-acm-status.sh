#!/bin/bash

NS=open-cluster-management
NS2=multicluster-engine

# message: install strategy completed with no errors
# phase: Succeeded
# reason: InstallSucceeded

function check() {
    if [[ "$1" == "Available" ]] || [[ "$1" == "Succeeded" ]]; then
        icon="✅"
    else
        icon="❌"
    fi
    echo " $1 $icon"
}

rc=$(oc get mch multiclusterhub -n $NS -o yaml | yq '.status.phase')
echo "current acm operator phase                   : $(check $rc)"
echo "current acm subscription currentCSV version  : " $(oc get subscription.operator -n $NS -o yaml | yq '.items[].status.currentCSV')

rc=$(oc get csv advanced-cluster-management.v2.5.2 -n $NS -o yaml | yq '.status.phase')
echo "current acm csv phase                        : $(check $rc)"

rc=$(oc get mce multiclusterengine -n $NS -o yaml | yq '.status.phase')
echo "current mce operator phase                   : $(check $rc)"
echo "current mce subscription currentCSV version  : " $(oc get subscription.operator -n $NS2 -o yaml | yq '.items[].status.currentCSV')
rc=$(oc get csv multicluster-engine.v2.0.2 -n $NS2 -o yaml | yq '.status.phase')
echo "current mce csv phase                        : $(check $rc)" 

echo "count current managed clusters               : " $( oc get managedcluster -A | wc -l )
echo "count current manifestwork                   : " $( oc get manifestwork -A | wc -l )


echo "Current InstallPlan State"
oc get installplan -n $NS
oc get installplan -n $NS2