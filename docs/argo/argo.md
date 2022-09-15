# Argo Examples

* Argocd is a push model
* The argocd server requires access to the git repo, and pushes the manifests to the remote cluster under management.
* If the argocd server is located on a central hub, only it needs access to the git repo, and the targets do not.
* if the argcod server is deployed to each cluster it manages, then each cluster will need access to the git repo the cluster needs.
* Some customers have private clsuter deployments, where the respective git repo is not directly accessible.
* ACM application component is a subscription pull model, but the channel selectors for git requires that the managed cluster will need access to the git repo as well.

## Application

Simple argo Applications can not be used with ACM Application placement.

## ApplicationSet

### External Secret Operator

1. Apply the argo application for External Secrets Operator.
2. ESO will be deployed to the local-cluster / in-cluster argo.
3. Find the ESO application in the ACM application view. The `type` will be `discovered`.
4. Argo applications cannot be placed.

```bash
oc apply -f ./docs/argo/applicationset/eso/eso.yaml
```

### MCE

[TODO: Policy Example]()

A good example argocd application is an application to deploy MCE. In ACM 2.6.0, MCE can be deployed to an attached managed cluster.

The github repo will define the kustomization for the MCE application. We'll use External Secrets Operator (ESO) to manage the secrets, with a hashicorp Vault backend as our example. ESO supports any number of secret management platforms.
