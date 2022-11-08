#!/bin/bash
#
# Usage: ./trigger.sh [SNAPSHOT]
#
# Example: ./hack/trigger-pipeline-rolling-upgrade.sh 2.7.0-DOWNSTREAM-2022-11-07-02-13-57
#

oc delete pipelinerun mce-rolling-update -n open-cluster-management-pipelines-mce

oc apply -f - <<EOF
apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  name: mce-rolling-update
  namespace: open-cluster-management-pipelines-mce
  labels:
    app.kubernetes.io/instance: sre-pipelines
    tekton.dev/pipeline: mce-rolling-update
spec:
  params:
    - name: kubeconfig
      value: ''
    - name: start-snapshot
      value: ''
    - name: upgrade-snapshot
      value: $1
  pipelineRef:
    name: mce-rolling-update
  serviceAccountName: pipeline
  timeout: 1h0m0s
  workspaces:
    - name: shared-workspace
      persistentVolumeClaim:
        claimName: shared-storage-pvc
EOF
