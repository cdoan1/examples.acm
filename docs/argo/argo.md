# Argo Examples

## Application

### MCE

A good example argocd application is an application to deploy MCE. In ACM 2.6.0, MCE can be deployed to an attached managed cluster.

The github repo will define the kustomization for the MCE application. We'll use External Secrets Operator (ESO) to manage the secrets, with a hashicorp Vault backend as our example. ESO supports any number of secret management platforms.

