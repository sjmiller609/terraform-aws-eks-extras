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

# directory naming 

```
/local-ssd/pvc-2641de65-a14e-4848-80f1-56bb35b67713_default_data-etcd-4
```
