# Assisted Service SNO Simple Sample Manifests

In the `dell-r730-069` folder, we have the example manifests needed to provision a SNO OCP cluster on a single baremetal node.

To customize it for your own environment, you should just need to pattern match and replace `dell-r730-069` in all the manifest files with your own cluster name.

Since this example does not define any baremetal host manifests, we won't automate discrovery iso load, and that step will be left as a manual task. However, once the discover iso is booted, the node will "phone home" to the ACM hub, and automatically begin the cluster install step. This is done because the agentclusterinstall specifies only 1 control plane node required for the cluster.

## Usage

1. Define the `.env.secret` file with the pull secret in the dell-r730-069 folder. We'll use kustomize to generate the secret. Alternatively, you can store the pull secret in `Vault` and leverage external secrets.

```bash
cat > .env.test.secret <<EOF
.dockerconfigjson=$(oc get secret pull-secret -n openshift-config -ojsonpath='{.data.\.dockerconfigjson}' | base64 --decode | jq -c .)
EOF
```

2. Review the manifests any changes specific to your environment.
3. Create the resources

```bash
git clone git@github.com:cdoan1/examples.acm.git
cd ./example.acm/gitops/assisted-installer/dell-r730-069
oc apply -k .
```

4. Manually download and boot the discrovery .ISO file.
5. Accept the host, and the OCP provision will start.

## Deploy an baremetal OCP cluster behind a VPN

It is possible to use ACM/MCE on AWS and provision a baremtal cluster on prem behind your corporate vpn using the procedure described above.
After the cluster is provisioned, we will need perform a direct import of the new baremtal cluster becasue the vpn blocks the default autoimport step after cluster provisioning.

For small number of clusters, we can use the script here: `./hack/lab-cluster-import/direct-import.sh`

`./direct-import.sh [managedcluster name] [path to hub kubeconfig] [path to spoke kubeconfig]`

Example:

```bash
./hack/lab-cluster-import/direct-import.sh dell-r730-069 /Users/cdoan/Downloads/randy /Users/cdoan/Downloads/dell-r730-069-kubeconfig.yaml
```
