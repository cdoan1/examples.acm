# Upgrade Testing

Setup a set of clusters to test upgrade of ACM 2.4 to ACM 2.5 from the perspective of ACM SRE. We did perform the upgrade in AOC. The number of clusters we had was < 5 managed clusters. We had applications managed by argocd as well as a handful of policies. Observability was enabled.

We did have to disable backup operator.
There was another issue we had, it was documented in our word document. todo(cdoan): #link

> NOTE: Starting with release ACM 2.5, we split the original ACM into **TWO** products, and this means two separate `subscription.operators`. Even through you can trigger the deployment of ACM 2.5 with one `subscription`, internally, we define and apply a second `subscription` for the MCE product. MCE can be installed standalone, or it can be installed when ACM is freshly installed, or upgraded from ACM 2.4. This is seamless and somewhat transparent in a connected deployment where everything exists in the public registry.redhat.io container registry. When you are upgrading where the images are served from a private registry, the multiclusterhub operand needs to be aware of where the MCE catalogsource is located, otherwise, the upgrade will BLOCK, waiting for MCE to complete the install. TODO: Reference KCS.

## Upgrading from RHACM 2.4 to RHACM 2.5

0. 6 node OCP 4.9.48 cluster, 3 master, 3 worker.
1. manually install RHACM 2.4.0 GA, via kustomizaton manifests, subscription for channel release-2.4, csv: 2.4.0
2. manually approve install @ 2.4.0
3. deployed 10 managed clusters, 20 applications, 20 policies
4. manually approve install plan @ 2.4.5
5. deployed 10 managed clusters, 20 applications, 20 policies
6. manually install RHACM 2.5 GA
7. manually approve install plan @ 2.5
8. automatically approve install plan for mce 2.0

    ```bash
    NAMESPACE                 NAME            CSV                                  APPROVAL    APPROVED
    multicluster-engine       install-bw7b4   multicluster-engine.v2.0.2           Automatic   true
    open-cluster-management   install-5mqxx   advanced-cluster-management.v2.4.0   Manual      true
    open-cluster-management   install-bgnqv   advanced-cluster-management.v2.4.5   Manual      true
    open-cluster-management   install-t5jnb   advanced-cluster-management.v2.5.2   Manual      true
    ```

    ```bash
    oc apply -k rhacm-operator/base-release-2.5
    oc patch installplan install-t5jnb --type merge --patch '{"spec":{"approved":true}}' -n open-cluster-management
    ```

    * backup was disabled in mch in 2.4

    * mch is currently Not Running, because the local-cluster has not completed.

    ```yaml
    local-cluster:
        lastTransitionTime: "2022-09-24T13:07:31Z"
        message: No conditions available
        reason: No conditions available
        status: Unknown
        type: Unknown
    ```

    ```yaml
    currentVersion: 2.4.5
    desiredVersion: 2.5.2
    phase: Updating
    ```

9. When I delete all the current manifestwork, the state of all managedclusters went to `Unknown`. I dumped out the current list of manifestwork, then iterated the list and deleted each manifestwork. The expectation is that that RHACM would get back to the desired state, and the manifestwork would be recreated. As I deleted the manifestwork list, RHACM detected the change, and gradually recreated the manifestwork. Ordering is not a requirement of k8s.

    ```bash
    Every 2.0s: oc get managedclusters ; oc get klusterletaddonconfig                       cdoan-mac: Sat Sep 24 14:59:14 2022

    NAME                           HUB ACCEPTED   MANAGED CLUSTER URLS                           JOINED   AVAILABLE   AGE
    cdoan-upgrade-test-1-kind      true                                                          True     Unknown     17h
    local-cluster                  true           https://api.cs-upgrade-24.stolostron.io:6443   True     True        18h
    managed-k3s-cluster-0205b515   true                                                          True     Unknown     16h
    managed-k3s-cluster-06d3d9e6   true                                                          True     Unknown     16h
    managed-k3s-cluster-07234b54   true                                                          True     Unknown     7h56m
    managed-k3s-cluster-1b92e12f   true                                                          True     Unknown     16h
    managed-k3s-cluster-1dd7cb6c   true                                                                               68s
    managed-k3s-cluster-21ecb4b3   true                                                          True     Unknown     7h32m
    managed-k3s-cluster-25408850   true                                                          True     Unknown     5h59m
    managed-k3s-cluster-324f7846   true                                                                   Unknown     6h17m
    managed-k3s-cluster-39594b40   true                                                          True     Unknown     7h56m
    managed-k3s-cluster-3df52922   true                                                          True     Unknown     7h55m
    managed-k3s-cluster-3f86a180   true                                                          True     Unknown     7h55m
    managed-k3s-cluster-40ca86e5   true                                                          True     Unknown     7h55m
    managed-k3s-cluster-4aefde27   true                                                          True     Unknown     16h
    managed-k3s-cluster-4c92d9ff   true                                                          True     Unknown     6h4m
    managed-k3s-cluster-4f412f27   true                                                          True     Unknown     7h55m
    managed-k3s-cluster-6f333d41   true                                                          True     Unknown     7h32m
    managed-k3s-cluster-730a70fb   true                                                          True     Unknown     16h
    managed-k3s-cluster-8408ce7c   true                                                          True     Unknown     7h32m
    managed-k3s-cluster-84b7024e   true                                                          True     Unknown     7h32m
    managed-k3s-cluster-8bda408c   true                                                          True     Unknown     7h32m
    managed-k3s-cluster-9992d0e5   true                                                          True     Unknown     7h32m
    managed-k3s-cluster-9c08718f   true                                                          True     Unknown     7h32m
    managed-k3s-cluster-b4088b6d   true                                                          True     Unknown     7h55m
    managed-k3s-cluster-bd0890a4   true                                                          True     Unknown     7h55m
    managed-k3s-cluster-c71915fa   true                                                          True     Unknown     16h
    managed-k3s-cluster-c8f69c48   true                                                          True     Unknown     7h32m
    managed-k3s-cluster-cd844019   true                                                          True     Unknown     16h
    managed-k3s-cluster-d1bae603   true                                                          True     Unknown     7h56m
    managed-k3s-cluster-d7f79e29   true                                                          True     Unknown     6h4m
    managed-k3s-cluster-dba33367   true                                                          True     Unknown     7h32m
    managed-k3s-cluster-e05ee27b   true                                                                   Unknown     6h4m
    managed-k3s-cluster-e09ac848   true                                                          True     Unknown     16h
    managed-k3s-cluster-e5efdc53   true                                                          True     Unknown     6h4m
    managed-k3s-cluster-ef2230ac   true                                                          True     Unknown     7h32m
    managed-k3s-cluster-fd2282b7   true                                                          True     Unknown     7h56m
    managed-k3s-cluster-fe1b17c7   true                                                          True     Unknown     16h
    managed-k3s-cluster-fe8afd3e   true                                                          True     Unknown     16h
    NAME                           AGE
    managed-k3s-cluster-324f7846   6h17m
    ```

10. Now, re-iterate the list of manifestwork, and patch the finalizer and delete all those resources, that still reamin after the first pass.

11. Checked the klusterlet namespaces on the managed cluster, they are all gone! ssh into k3s node, and running `kubectl get ns`

    ```bash
    NAME                  STATUS   AGE
    default               Active   17h
    kube-system           Active   17h
    kube-public           Active   17h
    kube-node-lease       Active   17h
    app-perf-sub-git-1    Active   9h
    app-perf-sub-git-2    Active   9h
    app-perf-sub-git-3    Active   9h
    app-perf-sub-git-4    Active   9h
    app-perf-sub-git-5    Active   9h
    app-perf-sub-git-6    Active   9h
    ...
    ```

12. cleanup, deleted all managed clusters
13. added 10 new managed cluster and successfully imported the 10, all 10 are ready
14. attempt to delete all the manifestwork, but did not force patch delete finalizer, or skip klusterlet, klusterlet-crds.
15. NOTE: manifestwork includes the `klusterlet` and `klusterlet-crds` manifestwork. These cannot be deleted. If this is deleted, it will remove the klusterlet from the remote managed cluster.

16. for a given managed cluster, deleting the manifestfwork for the addons will just trigger the recreate, and have no impact to the addon status, they will continue to be available. The manifestwork for applications are not immediately recreated--perhaps at the next application reconsile interval.

17. Turns out, its very easy to delete manifestwork. Not sure what would require deleting the finalizer on the manifestwork resource. I found that these records can be deleted without any block.

## Problems Observed

1. import controler pod was crashloop. One out of 2. Manually deleted the pod, and did not occur again.
2. `local-cluster` is in `Ready` state, but mch still shows that local-cluster from `mch` is `Unknown` state.
3. 3 out of n clusters is in `Unknown` state. 2 are pending import. This is likely due to the cluster itself.
4. After testing deleting manifestwork, I think the reason why ALL managed cluster reached `Unknown` is because the klusterlet / klusterlet-crds manifestwork was deleted on the hub, and caused the klusterlet to be deleted on the managed cluster. The managedcluster and managedclusteraddons records should all be `Unknown`. Or, if you list them and they seem to be there, they might have been recreated, but if they were recreated, the klusterlet is probably already deleted on the remote.

## Tools

| description | tool |
|-------------|------|
| script to check the current status of ACM 2.5                | ./hack/check-acm-status.sh |
| script to delete all the manifestwork except klusterlet ones | ./hack/chaos-delete-current-manifestwork.sh |

## Monitoring

While running this upgrade testing, its useful to monitor the resource changes using `watch`. You can run these watch commands in separate terminals.

```bash
watch 'oc get managedclusters ; oc get managedclusteraddons -A'
watch 'oc get manifestwork -A --sort-by=.metadata.creationTimestamp | tail -n 50; echo; echo "count manifestwork: " $(oc get manifestwork -A | wc -l)'

stern import-con -n multicluster-engine
```

## Misc

Example output from the `check-acm-status.sh`

```bash
current acm operator phase                   :  Updating ❌
current acm subscription currentCSV version  :  advanced-cluster-management.v2.5.2
current acm csv phase                        :  Succeeded ✅
current mce operator phase                   :  Available ✅
current mce subscription currentCSV version  :  multicluster-engine.v2.0.2
current mce csv phase                        :  Succeeded ✅
count current managed clusters               :  8
count current manifestwork                   :  68
Current InstallPlan State
NAME            CSV                                  APPROVAL   APPROVED
install-5mqxx   advanced-cluster-management.v2.4.0   Manual     true
install-bgnqv   advanced-cluster-management.v2.4.5   Manual     true
install-t5jnb   advanced-cluster-management.v2.5.2   Manual     true
NAME            CSV                          APPROVAL    APPROVED
install-bw7b4   multicluster-engine.v2.0.2   Automatic   true
```

## Automation

* It is possible to automate the creation of an upgraded environment, starting with release-2.4.
* We can leverage this same process, and upgrade to the latest release sprint drivers as well.
* Once we capture the data wither any issues were seen in upgrade, we can revert back to reinstalling the current sprint driver as a fresh install.

### Input

| parameter | description |
|-----------|-------------|
| secret_name | name of the secret that contains the target cluster `data.kubeconfig`, base64 encoded string. `data.token`, string. `data.api_endpoint`, string.
