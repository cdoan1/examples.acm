## Usage

1. Install the ACM OSD Addon Operator in a standard OCP Cluster.

```bash
✗ oc apply -k redhat-advanced-cluster-management-addon/3.7.0-pre8
namespace/multicluster-engine created
namespace/redhat-open-cluster-management created
imagecontentsourcepolicy.operator.openshift.io/rhacm-repo created
operatorgroup.operators.coreos.com/default created
operatorgroup.operators.coreos.com/default created
catalogsource.operators.coreos.com/addon-advanced-cluster-management-catalog created
catalogsource.operators.coreos.com/addon-advanced-cluster-management-catalog created
subscription.operators.coreos.com/advanced-cluster-management created
```

2. Verify that the subscription is installed.

3. Install the ACM OSD Addon Instance.

```bash
✗ oc apply -k redhat-advanced-cluster-management-addon-instance/overlays/3.7.0-pre8
multiclusterhub.operator.open-cluster-management.io/multiclusterhub created
```

4. Verfiy deployment

```bash
watch 'oc get pods -n redhat-open-cluster-management; oc get pods -n multicluster-hub; oc get pods -n multicluster-engine; oc get csv -n redhat-open-cluster-management; oc get csv -n multicluster-engine; echo "acm:"; oc get mch multiclusterhub -n multicluster-hub -ojsonpath='{.status.phase}' || oc get mch multiclusterhub -n redhat-open-cluster-management -ojsonpath='{.status.phase}'; echo; echo "mce:"; oc get mce multiclusterengine -ojsonpath="{.status.phase}" -n multicluster-engine'
```

## Uninstall

* If ACM is successfully running

```bash
oc delete mce --All -n multicluster-engine



oc delete -k redhat-advanced-cluster-management-addon-instance/overlays/3.7.0-pre8
oc delete -k redhat-advanced-cluster-management-addon/3.7.0-pre8

oc delete mce --All
oc delete mch --All