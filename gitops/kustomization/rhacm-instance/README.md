# deploy the RHACM kustomization operand instance

* The default operand base is High availibity
* The basic overlay is for single node deployments

# Standard Deployment

* 3 master nodes
* High availability
* GA release of RHACM
* everything is OCP clusters, no *KS clusters expected, so we don't need to define a reference to the pull secret

```bash
oc apply -k ./gitops/kustomization/rhacm-operator/base-release-2.4
oc apply -k ./gitops/kustomization/rhacm-instance/base
```

# ACM OCM Addon Testing

On a new OCP cluster, we should be able to deploy the operator and operand and expect to see 2.6.2 installed.

```bash
oc apply -k gitops/kustomization/rhacm-operator/base-downstream-release-2.6.2-acm-ocm-addon-2.7.1
oc apply -k gitops/kustomization/rhacm-instance/overlays/addon-release-2.6.2-acm-ocm-addon-2.7.1
```

On an existing cluster with OCP and ACM 2.6.1 installed, we expect to see ACM upgraded to 2.6.2.

```bash
oc apply -k gitops/kustomization/rhacm-operator/base-downstream-release-2.6-acm-d-catalogsource
oc apply -k gitops/kustomization/rhacm-operator/base-downstream-release-2.6.2-acm-ocm-addon-2.7.1
oc apply -k gitops/kustomization/rhacm-instance/overlays/addon-release-2.6.2-acm-ocm-addon-2.7.1
```
