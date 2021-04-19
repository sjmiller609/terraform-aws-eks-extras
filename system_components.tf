resource "null_resource" "helm_repo" {

  provisioner "local-exec" {
    command = <<EOF
    set -xe
    cd ${path.root}
    rm -rf ./local-path-provisioner-${var.local_path_provisioner_version} || true
    rm -rf ./local-path-provisioner || true
    git clone https://github.com/rancher/local-path-provisioner.git
    cd ./local-path-provisioner
    git checkout v${var.local_path_provisioner_version}
    cd ..
    mv ./local-path-provisioner/deploy/chart ./local-path-provisioner-${var.local_path_provisioner_version}
    rm -rf ./local-path-provisioner
    EOF
  }

  triggers = {
    build_number = timestamp()
  }
}
resource "helm_release" "local-path-provisioner" {
  name      = "local-path-provisioner"
  chart     = "./local-path-provisioner-${var.local_path_provisioner_version}"
  namespace = "kube-system"
  version   = var.local_path_provisioner_version
  values = [<<EOF
---
replicaCount: 1

image:
  repository: rancher/local-path-provisioner
  tag: v${var.local_path_provisioner_version}
  pullPolicy: IfNotPresent

helperImage:
  repository: busybox
  tag: latest

storageClass:
  create: true
  provisionerName: rancher.io/local-path
  defaultClass: false
  name: local-path
  reclaimPolicy: Delete

nodePathMap:
  - node: DEFAULT_PATH_FOR_NON_LISTED_NODES
    paths:
      - /local-ssd

resources:
  limits:
    cpu: 500m
    memory: 125Mi
  requests:
    cpu: 50m
    memory: 50Mi

rbac:
  # Specifies whether RBAC resources should be created
  create: true

serviceAccount:
  create: true

nodeSelector: {}

tolerations: []

affinity: {}

setup: |-
  #!/bin/sh
  path=$1
  mkdir -m 0777 -p $${path}

teardown: |-
  #!/bin/sh
  path=$1
  rm -rf $${path}
EOF
  ]

}

resource "helm_release" "metrics-server" {
  chart      = "metrics-server"
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  timeout    = 1200
  version    = "4.2.0"
}

resource "helm_release" "traefik" {
  chart      = "traefik"
  name       = "traefik"
  namespace  = "kube-system"
  repository = "https://containous.github.io/traefik-helm-chart"
  timeout    = 1200
  version    = "8.9.1"
  values = [<<EOF
---
resources:
  requests:
    cpu: "100m"
    memory: "50Mi"
  limits:
    cpu: "300m"
    memory: "150Mi"
podDisruptionBudget:
  enabled: true
  maxUnavailable: 1
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      targetAverageUtilization: 60
  - type: Resource
    resource:
      name: memory
      targetAverageUtilization: 75
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchExpressions:
      - key: app
        operator: In
        values:
        - traefik
    topologyKey: failure-domain.beta.kubernetes.io/zone
  EOF
  ]
}
