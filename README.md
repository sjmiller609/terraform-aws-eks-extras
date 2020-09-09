# EKS

A terraform module that deploys an EKS cluster and sets up various kubernetes tools.

This repository is used to experiement with EKS or Kubernetes features.

# Features

- Run on spot instances using Spot.io
- Prometheus
- Grafana
- EFS
- local-storage class using local NVME SSDs
- Velero
- Bastion / jump host for connecting to workers

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
