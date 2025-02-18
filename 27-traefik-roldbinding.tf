# Create cluster role for Traefik
resource "kubernetes_cluster_role" "traefik_role" {
  metadata {
    name = "traefik-role"
    labels = {
      "app.kubernetes.io/name" = "traefik"
      "app.kubernetes.io/instance" = "traefik"
      "app.kubernetes.io/managed-by" = "Helm"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["services", "endpoints", "secrets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses", "ingressclasses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses/status"]
    verbs      = ["update"]
  }

  rule {
    api_groups = ["traefik.containo.us", "traefik.io"]
    resources  = [
      "middlewares",
      "middlewaretcps",
      "ingressroutes",
      "traefikservices",
      "ingressroutetcps",
      "ingressrouteudps",
      "tlsoptions",
      "tlsstores",
      "serverstransports"
    ]
    verbs = ["get", "list", "watch"]
  }
}

# Create cluster role binding
resource "kubernetes_cluster_role_binding" "traefik_role_binding" {
  metadata {
    name = "traefik-role-binding"
    labels = {
      "app.kubernetes.io/name" = "traefik"
      "app.kubernetes.io/instance" = "traefik"
      "app.kubernetes.io/managed-by" = "Helm"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.traefik_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "traefik"  # This should match the service account name created by Helm
    namespace = "traefik"   # This should match your Traefik namespace
  }
}

# Create additional role for Traefik CRD management
resource "kubernetes_cluster_role" "traefik_crd_role" {
  metadata {
    name = "traefik-crd-role"
    labels = {
      "app.kubernetes.io/name" = "traefik"
      "app.kubernetes.io/instance" = "traefik"
      "app.kubernetes.io/managed-by" = "Helm"
    }
  }

  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
    verbs      = ["get", "list", "watch"]
  }
}

# Create CRD role binding
resource "kubernetes_cluster_role_binding" "traefik_crd_role_binding" {
  metadata {
    name = "traefik-crd-role-binding"
    labels = {
      "app.kubernetes.io/name" = "traefik"
      "app.kubernetes.io/instance" = "traefik"
      "app.kubernetes.io/managed-by" = "Helm"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.traefik_crd_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "traefik"
    namespace = "traefik"
  }
}