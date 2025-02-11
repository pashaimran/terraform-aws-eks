# cert-manager.tf
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = kubernetes_namespace.cert_manager.metadata[0].name
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.13.3"
  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "extraArgs[0]"
    value = "--dns01-recursive-nameservers=1.1.1.1:53,8.8.8.8:53"
  }

  # Optional: Enable Prometheus monitoring
  set {
    name  = "prometheus.enabled"
    value = "true"
  }
}
