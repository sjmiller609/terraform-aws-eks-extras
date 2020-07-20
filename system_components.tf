resource "helm_release" "metrics-server" {
  chart      = "metrics-server"
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  timeout    = 1200
  version    = "4.2.0"
}

resource "helm_release" "vertical-pod-autoscaler" {
  chart      = "vertical-pod-autoscaler"
  name       = "vertical-pod-autoscaler"
  namespace  = "kube-system"
  repository = "https://cowboysysop.github.io/charts/"
  timeout    = 1200
  version    = "2.0.0"
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
