#!/bin/bash

oc delete -f gitops/openshift-pipelines/lab-mce/pipelinerun/pipelinerun_mce_hypershift.yaml
oc apply -f gitops/openshift-pipelines/lab-mce/pipelinerun/pipelinerun_mce_hypershift.yaml