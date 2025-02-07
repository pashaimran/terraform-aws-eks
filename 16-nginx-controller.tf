# modules/nginx-ingress-controller/main.tf
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = var.nginx_chart_version
  
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"
  }

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  values = [
    yamlencode({
      controller = {
        service = {
          targetPorts = {
            http  = "http"
            https = "https"
          }
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-type"            = "nlb"
            "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = "true"
          }
        }
        config = {
          "use-forwarded-headers" = "true"
          "compute-full-forwarded-for" = "true"
          "use-proxy-protocol"    = "false"
          "allow-snippet-annotations": "true",
          "compute-full-forwarded-for": "true",
          "use-forwarded-headers": "true",
          "use-proxy-protocol": "false",
          "ssl-passthrough": "true",
          "enable-ssl-passthrough": "true"

        }
        metrics = {
          enabled = true
          serviceMonitor = {
            enabled = var.enable_monitoring
          }
        }
        resources = {
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "200m"
            memory = "256Mi"
          }
        }
      }
    })
  ]
  depends_on = [aws_eks_cluster.main]
}

# Variable.tf

variable "nginx_chart_version" {
  description = "Version of the Nginx ingress controller Helm chart"
  type        = string
#   default     = "4.7.1"
}

variable "enable_monitoring" {
  description = "Enable Prometheus monitoring"
  type        = bool
  default     = false
}


# outputs.tf
output "nginx_ingress_namespace" {
  description = "Namespace of the Nginx ingress controller"
  value       = helm_release.nginx_ingress.namespace
}