resource "kubernetes_namespace" "argocd_cluster" {
  metadata {
    name = var.argocd_cluster_namespace
  }
}

# Deploy Cluster-Level ArgoCD
resource "helm_release" "argocd_cluster" {
  name       = "argocd-cluster"
  namespace  = var.argocd_cluster_namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_cluster_version

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  depends_on = [
    aws_eks_cluster.main,
    kubernetes_cluster_role.argocd_cluster_role
  ]
}


variable "argocd_cluster_namespace" {
  type        = string
#   default     = "argocd-cluster"
}

variable "argocd_cluster_version" {
  type        = string
#   default     = "6.1.0" # Use latest stable version
}