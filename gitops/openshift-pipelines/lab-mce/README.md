# pipeline for acm and hypershift

The pipeline supports the following workflow:

1. install downstream ACM and creates a hostedcluster on AWS.
2. install downstream ACM and creates a hostedcluster with external-dns on AWS.
3. install downstream ACM 2.6.2 and upgrades to ACM 2.7.0.

## List of Pipelines

| name | description |
|------|-------------|
| mce-rolling-update | given a snapshot version, trigger a rolling update of ACM/MCE downstream deployment |
| mce_hypershift_26_27_e2e.yaml ||
| mce_hypershift_managedtenantbundle_e2e.yaml | checkout a cluster, deploy the generated mgt index image |

## Prerequisites

### ClusterPools

Ensure that all artifacts have the `playback-next` label to designate reference the origin.
Secrets will use external secrets to a vault.

| name | ns | description |
|------|----|-------------|
| mce-pool-basic | open-cluster-management-pipelines-mce | |
| mce-pool-service-cluster | open-cluster-management-pipelines-mce | 8x32 worker nodes to handle hypershift hosted clusters |


## Pipeline - policy push remote secret

1. Checkout a Cluster 1
2. Deploy ACM on Cluster 1
3. Deploy Cert-Manager on Cluster 1

4. Checkout a Cluster 2
5. Import Cluster 2 to Cluster 1

6. Create a certificate on Cluster 1
7. Use policy to move the secret to a configmap on Cluster 2
