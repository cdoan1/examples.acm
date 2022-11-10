#!/bin/bash

# save off the subscriptions
oc -n redhat-open-cluster-management get sub.operator addon-advanced-cluster-management -o yaml > addon-advanced-cluster-management.sub.yaml
oc -n multicluster-engine get sub.operator multicluster-engine -o yaml > multicluster-engine.sub.yaml

# delete the CSV
oc -n redhat-open-cluster-management delete csv advanced-cluster-management.v2.7.0
oc -n multicluster-engine delete csv multicluster-engine.v2.2.0

# delete the subscriptions
oc -n redhat-open-cluster-management delete subscription.operator addon-advanced-cluster-management
oc -n multicluster-engine delete subscription.operator multicluster-engine

sleep 10

# recreate the subscriptions
oc apply -f addon-advanced-cluster-management.sub.yaml
oc apply -f multicluster-engine.sub.yaml
