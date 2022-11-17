# Patch Operator

> NOTE: Patch Operator should be the first operations operator to be installed because all subsequent installations can leverage this operator.

## Verify that the MutatingWebhookConfiguration was created

```bash
✗ oc get mutatingwebhookconfiguration
NAME                                    WEBHOOKS   AGE
machine-api                             2          171m
mpatch.kb.io-5ssnl                      1          18m
mutate.webhooks.cert-manager.io-ck7hv   1          18m
patch-operator-inject                   1          3m26s
pod-identity-webhook                    1          165m
vault-agent-injector-cfg                1          19m
```

## Examples

```yaml
kind: ConfigMap 
apiVersion: v1 
metadata:
  name: cm-test-99
  annotations:
    "redhat-cop.redhat.io/patch": |
      data:
        acme: {{ (lookup "config.openshift.io/v1" "DNS" "" "cluster").spec.baseDomain }}
data:
  acme: data
```
