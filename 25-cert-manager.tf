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
  set {
    name  = "serviceAccount.create"
    value = "false"  # We created it manually above
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.cert_manager.metadata[0].name
  }

  depends_on = [
    kubernetes_service_account.cert_manager,
    kubernetes_cluster_role.cert_manager,
    kubernetes_cluster_role_binding.cert_manager
  ]
}


# Create ServiceAccount
resource "kubernetes_service_account" "cert_manager" {
  metadata {
    name      = "cert-manager"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
    labels = {
      "app.kubernetes.io/name"      = "cert-manager"
      "app.kubernetes.io/component" = "controller"
    }
  }

}

# Create ClusterRole
resource "kubernetes_cluster_role" "cert_manager" {
  metadata {
    name = "cert-manager-controller"
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["certificates", "certificaterequests", "issuers", "clusterissuers"]
    verbs      = ["create", "delete", "deletecollection", "patch", "update", "get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets", "events", "configmaps", "services"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["endpoints"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["route.openshift.io"]
    resources  = ["routes/custom-host"]
    verbs      = ["create"]
  }
}

# Create ClusterRoleBinding
resource "kubernetes_cluster_role_binding" "cert_manager" {
  metadata {
    name = "cert-manager-controller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cert_manager.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert_manager.metadata[0].name
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }
}
