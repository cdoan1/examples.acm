# Setup

Setup ODF Logicalvolume Manager Operator Policy. When a managed cluster is labeled with `odflvmo=true` the policy will be applied.

```bash
oc apply -f docs/policies/storage/odf-lvm-operator.yaml -n policies
```

or

```bash
oc apply -f https://raw.githubusercontent.com/cdoan1/examples.acm/main/docs/policies/storage/odf-lvm-operator.yaml -n policies
```
