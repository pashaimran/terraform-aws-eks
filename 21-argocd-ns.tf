# Deploy Namespace-Level ArgoCD
resource "helm_release" "argocd_ns" {
  name       = "argocd-ns"
  namespace  = var.argocd_namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_namespace_version

#   set {
#     name  = "server.service.type"
#     value = "LoadBalancer"
#   }

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }
#   set {
#     name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
#     value = "internet-facing"
#   }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "installCRDs"
    value = "false" # Prevents Helm from trying to install CRDs again
  }

  set {
    name  = "server.insecure"
    value = "true"
  }

  depends_on = [
    aws_eks_cluster.main,
    helm_release.argocd_cluster
  ]
}

# Create ArgoCD namespace for namespace-level deployments
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

variable "argocd_namespace_version" {
  type        = string
#   default     = "6.1.0" # Use latest stable version
}

variable "argocd_namespace" {
  type        = string
#   default     = "argocd"
}