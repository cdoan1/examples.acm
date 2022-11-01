#!/bin/bash
#
# iterate the list of CRD from ACM/MCE and list of any resources in the current namespace
# or you can pass additional arguments like ./$1.sh -n local-cluster
#
for i in `oc get crd -A | grep open-cluster | awk '{print $1}'`
do
  echo "----------------------------------"
  echo $i
  oc get $i "$@"
done
