#!/bin/bash

NS=open-cluster-management
NS2=multicluster-engine

# message: install strategy completed with no errors
# phase: Succeeded
# reason: InstallSucceeded

function check() {
    if [[ "$1" == "Available" ]] || [[ "$1" == "Succeeded" ]] || [[ "$1" == "Running" ]]; then
        icon="✅"
    else
        icon="❌ (Expected: Available | Succeeded | Running)"
    fi
    echo "$1 $icon"
}

rc=$(oc get mch multiclusterhub -n $NS -o yaml | yq '.status.phase')
echo "current mch operator phase                            : $(check $rc)"
echo "current acm subscription currentCSV version           : "$(oc get subscription.operator -n $NS -o yaml -l operators.coreos.com/advanced-cluster-management.open-cluster-management= | yq '.items[].status.currentCSV')

# echo "current acm sub conditions"
# oc get sub -n open-cluster-management acm-operator-subscription -ojsonpath="{.status.conditions}" | jq .

rc=$(oc get csv advanced-cluster-management.v2.7.0 -n $NS -o yaml | yq '.status.phase')
echo "current acm csv phase                                 : $(check $rc)"

# if [[ "$rc" == "Pending" ]]; then
#     oc get csv advanced-cluster-management.v2.7.0 -n $NS -o yaml | yq '.status'
# fi

rc=$(oc get mce multiclusterengine -n $NS -o yaml | yq '.status.phase')
echo "current mce operator phase                            : $(check $rc)"
echo "current mce subscription currentCSV version           : "$(oc get subscription.operator -n $NS2 -o yaml | yq '.items[].status.currentCSV')
rc=$(oc get csv multicluster-engine.v2.2.0 -n $NS2 -o yaml | yq '.status.phase')
echo "current mce csv phase                                 : $(check $rc)" 

echo "count current managed clusters                        : "$( oc get managedcluster -A | wc -l )
echo "count current manifestwork                            : "$( oc get manifestwork -A | wc -l )


echo "Current InstallPlan State"
oc get installplan -n $NS
oc get installplan -n $NS2

oc get dexclient -A
oc get dexserver -A
oc get idpconfig -A
oc get placement -A
