resource "kubernetes_namespace" "system-components" {
  metadata {
    name = "system-components"
  }
}

resource "helm_release" "metrics-server" {
  chart      = "metrics-server"
  name       = "metrics-server"
  namespace  = kubernetes_namespace.system-components.metadata.0.name
  repository = "https://charts.bitnami.com/bitnami"
  version    = "4.2.0"
}

resource "helm_release" "vertical-pod-autoscaler" {
  chart      = "vertical-pod-autoscaler"
  name       = "vertical-pod-autoscaler"
  namespace  = kubernetes_namespace.system-components.metadata.0.name
  repository = "https://cowboysysop.github.io/charts/"
  version    = "2.0.0"
}

resource "helm_release" "prometheus" {
  chart      = "prometheus"
  name       = "prometheus"
  namespace  = kubernetes_namespace.system-components.metadata.0.name
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version    = "11.7.0"
}

resource "helm_release" "grafana" {
  chart      = "grafana"
  name       = "grafana"
  namespace  = kubernetes_namespace.system-components.metadata.0.name
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version    = "5.4.1"
  values = [<<EOF
---
adminUser: admin
adminPassword: admin
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      url: http://prometheus-server.${kubernetes_namespace.system-components.metadata.0.name}.svc.cluster.local
      isDefault: true
dashboards:
  default:
    prometheus-stats:
      gnetId: 3662
      revision: 2
      datasource: Prometheus
sidecar:
  dashboards:
    enabled: true
dashboardProviders:
  dashboardproviders.yaml:
    apiVersion: 1
    providers:
    - name: 'default'
      orgId: 1
      folder: ''
      type: file
      disableDeletion: false
      editable: true
      options:
        path: /var/lib/grafana/dashboards/default
EOF
]

}
