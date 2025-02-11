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

  values = [
    <<-EOT
    extraArgs:
      - --dns01-recursive-nameservers=1.1.1.1:53
      - --dns01-recursive-nameservers=8.8.8.8:53
      - --dns01-recursive-nameservers-only
    EOT
  ]

  # Optional: Enable Prometheus monitoring
  set {
    name  = "prometheus.enabled"
    value = "true"
  }
}