resource "helm_release" "prometheus_operator" {
  name             = "prometheus-operator-crds"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  version          = "56.6.2"  # Use the latest stable version

  values = [
    yamlencode({
      prometheusOperator = {
        enabled = true
      }
      alertmanager = {
        enabled = true
      }
      grafana = {
        enabled = true
      }
      prometheus = {
        enabled = true
      }
    })
  ]
}