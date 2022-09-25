# RHACM Upgrade Testing Setup

This folder contains the tekton pipeline manifests to setup an environment with upgraded RHACM.

1. given the connection credentials to an OCP (kubeconfig, or token + api endpoint)
2. install RHACM 2.4.0
3. Upgrade to RHACM 2.4.5
4. Upgrade to RHACM 2.5.0 (2.5.2 automatically)

## Namespace

Create a namespace for the project related to RHACM upgrade. For this example, we follow the existing pattern and create a namespace: `open-cluster-management-pipelines-upgrade`.

## Secrets

### Easy

1. Manually create a k8s secrets with the following commands:
2. Run a pipeline task to create the required secret.

### Advanced

1. external secrets / hashicorp vault backend
