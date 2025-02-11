# Create Namespace for Cert-Manager
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

# Create ServiceAccount for Cert-Manager
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

# Install Helm release for Cert-Manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = kubernetes_namespace.cert_manager.metadata[0].name
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "1.13.3"  # Corrected version

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

  # Enable Prometheus monitoring
  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  # Use the manually created ServiceAccount
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.cert_manager.metadata[0].name
  }

  depends_on = [
    kubernetes_namespace.cert_manager,
    kubernetes_service_account.cert_manager
  ]
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


# Webhook ServiceAccount
resource "kubernetes_service_account" "cert_manager_webhook" {
  metadata {
    name      = "cert-manager-webhook"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
    labels = {
      "app.kubernetes.io/name"      = "webhook"
      "app.kubernetes.io/component" = "webhook"
    }
  }
}

# Webhook Role
resource "kubernetes_role" "cert_manager_webhook" {
  metadata {
    name      = "cert-manager-webhook"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["create", "get", "patch", "update"]
  }
}

# Webhook RoleBinding
resource "kubernetes_role_binding" "cert_manager_webhook" {
  metadata {
    name      = "cert-manager-webhook"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.cert_manager_webhook.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert_manager_webhook.metadata[0].name
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }
}