# pipeline for acm and hypershift

The pipeline supports the following workflow:

1. install downstream ACM and creates a hostedcluster on AWS.
2. install downstream ACM and creates a hostedcluster with external-dns on AWS.
3. install downstream ACM 2.6.2 and upgrades to ACM 2.7.0.

## List of Pipelines

| name | description |
|------|-------------|
| mce-rolling-update | given a snapshot version, trigger a rolling update of ACM/MCE downstream deployment |
