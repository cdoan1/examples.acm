## Directly import a cluster from behind vpn into an AWS hub.

`./direct-import.sh [managedcluster name] [path to hub kubeconfig] [path to spoke kubeconfig]`

Example:

```bash
./hack/lab-cluster-import/direct-import.sh dell-r730-069 /Users/cdoan/Downloads/randy /Users/cdoan/Downloads/dell-r730-069-kubeconfig.yaml
```
