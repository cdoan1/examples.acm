#!/bin/bash

# oc delete -f gitops/openshift-pipelines/lab-mce/pipelinerun/pipelinerun_mce_hypershift.yaml
# oc apply -f gitops/openshift-pipelines/lab-mce/pipelinerun/pipelinerun_mce_hypershift.yaml

oc delete -f gitops/openshift-pipelines/lab-mce/pipelinerun/pipelinerun_mce_hypershift_26_27_e2e.yaml
oc apply -f gitops/openshift-pipelines/lab-mce/pipelinerun/pipelinerun_mce_hypershift_26_27_e2e.yaml