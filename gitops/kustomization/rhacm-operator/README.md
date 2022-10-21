# deploy the RHACM kustomization

```bash
oc apply -k ./gitops/kustomization/rhacm-operator/base-release-2.4
```

## Infra Nodes

RHACM supports deploy all its components on dedicated `infra` nodes. On the hub cluster, both the hub and local-cluster components will be running on the `infra` nodes.

```bash
oc apply -k ./gitops/kustomization/rhacm-operator/base-release-2.4-infra
```
