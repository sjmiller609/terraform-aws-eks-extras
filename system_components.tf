resource "helm_release" "metrics-server" {
  chart      = "metrics-server"
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "4.2.0"
}

resource "helm_release" "vertical-pod-autoscaler" {
  chart      = "vertical-pod-autoscaler"
  name       = "vertical-pod-autoscaler"
  namespace  = "kube-system"
  repository = "https://cowboysysop.github.io/charts/"
  version    = "2.0.0"
}
