# Setup Dedicated Vault Cluster




## Swimlanes


```
title: Use cert-manager to manage cluster certificates


OCM -> OLM: patch operator

OCM -> OLM: community cert-manager

OCM --> SA: patch-operator::mutatingwebhook-patcher

OCM --> SA: cert-manager::cert-manager

OCM -> CONFIG: patch-operator config

CONFIG -> MutatingWebhookConfiguration: create
CONFIG -> MutatingWebhookConfiguration: inject cert

OCM -> CONFIG: cert-manager config

CONFIG -> ClusterIssuer: public-issuer

CONFIG -> Certificate: create letsencrypt-tls-cert
Certificate --> Secret: lets-encrypt-certs-tls

CONFIG -> Certificate: create letsencrypt-api-tls-cert
Certificate --> Secret: lets-encrypt-api-certs-tls

CONFIG -> IngressController: patch set defaultCertificate to secret

IngressController -> OCM: Users login to tls enabled console
```

