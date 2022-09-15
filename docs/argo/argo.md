# Argo Examples

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
