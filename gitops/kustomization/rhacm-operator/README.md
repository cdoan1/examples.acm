# deploy the RHACM kustomization

```bash
oc apply -k ./gitops/kustomization/rhacm-operator/base-release-2.4
oc apply -k ./gitops/kustomization/rhacm-instance/overlays/release-2.4
```

## Infra Nodes

RHACM supports deploy all its components on dedicated `infra` nodes. On the hub cluster, both the hub and local-cluster components will be running on the `infra` nodes.

```bash
oc apply -k ./gitops/kustomization/rhacm-operator/base-release-2.4-infra
```
### Verify Infra Configuration

https://docs.openshift.com/container-platform/4.9/machine_management/creating-infrastructure-machinesets.html

https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.5/html/install/installing#infra-olm-sub-add-config

Verify the nodes have the infra label

```bash
oc get machinesets -n openshift-machine-api
oc get nodes --show-labels | grep infra
```

Check if there a default cluster-wide node selector?

```bash
oc get scheduler cluster -o yaml
```
