resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  chart      = "prometheus"
  name       = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata.0.name
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version    = "11.7.0"
}

resource "helm_release" "grafana" {
  chart      = "grafana"
  name       = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata.0.name
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
      url: http://prometheus-server.${kubernetes_namespace.monitoring.metadata.0.name}.svc.cluster.local
      isDefault: true
dashboards:
  default:
    kubernetes:
      gnetId: 315
      revision: 3
      datasource: Prometheus
    prometheus-stats:
      gnetId: 3662
      revision: 2
      datasource: Prometheus
    velero:
      gnetId: 11055
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
