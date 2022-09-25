#!/bin/bash

NS=open-cluster-management
NS2=multicluster-engine

function check() {
    if [[ "$1" == "Available" ]] || [[ "$1" == "Succeeded" ]]; then
        icon="✅"
    else
        icon="❌"
    fi
    echo " $1 $icon"
}

echo "count current managed clusters                  : " $( oc get managedcluster -A | wc -l )
echo "count current managed clusters in Unknown state : " $( oc get managedcluster -A | grep Unknown | wc -l )
echo "count current manifestwork                      : " $( oc get manifestwork -A | wc -l )

if [ ! -f manifestwork.list.txt ]; then
    echo "recording the current manifestwork records on the hub cluster ..."
    oc get manifestwork -A --no-headers | awk '{print $1 "," $2}' > manifestwork.list.txt
fi

COUNTER=1
MAX=1

for i in `cat manifestwork.list.txt`
do
    A=$(echo $i | cut -d',' -f1)
    B=$(echo $i | cut -d',' -f2)

    # bypass any `klusterlet` or `klusterlet-crds` manifestwork
    # addon manifestwork can be still deleted
    if echo $B | grep klusterlet; then
        continue
    fi

    oc delete manifestwork $B -n $A --now=true --wait=false

    # COUNTER=$(( $COUNTER + 1 ))
    # if [ $COUNTER -gt $MAX ]; then
    #     echo "COUNTER=$COUNTER"
    #     break
    # fi
done
