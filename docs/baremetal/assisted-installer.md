# Setup

Setup ODF Logicalvolume Manager Operator Policy. When a managed cluster is labeled with `odflvmo=true` the policy will be applied.

```bash
oc apply -f docs/policies/storage/odf-lvm-operator.yaml -n policies
```
