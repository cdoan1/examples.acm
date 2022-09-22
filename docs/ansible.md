# Ansible

## ansible-collection.core

You can run this playbook to setup dyanmic inventory of all the OCM/ACM/MCE managed clusters.
The ansible-collection.core is provided through an exeuction engine docker container.

```bash
ansible-playbook playbooks/aap-controller-ocm-collection-setup.yml -e tenant=playback
```
