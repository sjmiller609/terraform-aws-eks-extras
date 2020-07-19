# Connecting to worker nodes

enable_bastion = true
```
eval `ssh-agent`
ssh-add ~/.ssh/*
ssh <bastion host>
```

# Get Grafana admin password

```
kubectl get secrets -n system-components grafana -o json | jq '.data["admin-password"]' -r | base64 --decode && echo
```
