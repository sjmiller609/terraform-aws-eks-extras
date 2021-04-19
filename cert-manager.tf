resource "kubernetes_namespace" "cert_manager" {
  count = var.cert_manager_enabled ? 1 : 0
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  count      = var.cert_manager_enabled ? 1 : 0
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.3.1"
  namespace  = kubernetes_namespace.cert_manager.0.metadata.0.name

  values = [<<EOF
---
installCRDs: true
EOF
  ]
}
