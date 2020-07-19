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
