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
