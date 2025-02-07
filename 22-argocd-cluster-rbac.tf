resource "kubernetes_cluster_role" "argocd_cluster_role" {
  metadata {
    name = "argocd-cluster-role"
  }

  rule {
    api_groups = ["", "apps", "networking.k8s.io", "batch", "policy", "rbac.authorization.k8s.io", "autoscaling", "apiextensions.k8s.io"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "namespaces", "persistentvolumes", "events", "secrets", "configmaps"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["clusterroles", "roles", "rolebindings", "clusterrolebindings"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "argocd_cluster_rolebinding" {
  metadata {
    name = "argocd-cluster-rolebinding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "argocd-server"
    namespace = "argocd-cluster"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.argocd_cluster_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}
