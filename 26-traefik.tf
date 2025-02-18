# resource "kubernetes_namespace" "traefik" {
#   metadata {
#     name = "traefik"
#   }
# }

# resource "helm_release" "traefik" {
#   name             = "traefik"
#   repository       = "https://helm.traefik.io/traefik"
#   chart            = "traefik"
#   namespace        = "traefik"
#   create_namespace = true
#   version          = "23.0.1"
#   # set {
#   #   name  = "dashboard.enabled"
#   #   value = "true"
#   # }
#   values = [
#     <<EOF
# # deployment:
# #   enabled: true

# # service:
# #   enabled: true
# #   type: LoadBalancer
# #   externalTrafficPolicy: Local
# #   annotations:
# #     service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
# #     service.beta.kubernetes.io/aws-load-balancer-type: "nlb"

# # rbac:
# #   enabled: true

# # # ingressRoute:
# # #   dashboard:
# # #     enabled: true
# # #     matchRule: PathPrefix(`/dashboard`)

# ingressClass:
#   enabled: true
# #   isDefaultClass: true

# ports:
#   web:
#     redirectTo:
#       port: websecure
# EOF
#   ]
# }

# resource "kubernetes_service_account" "traefik" {
#   metadata {
#     name      = "traefik-ingress-controller"
#     namespace = kubernetes_namespace.traefik.metadata[0].name
#   }
# }

# resource "kubernetes_role" "traefik_ingressroute_role" {
#   metadata {
#     name      = "traefik-ingressroute-access"
#     namespace = "demo-project"
#   }

#   rule {
#     api_groups = ["traefik.containo.us"]
#     resources  = ["ingressroutes"]
#     verbs      = ["get", "list", "create", "update", "delete"]
#   }
# }

# resource "kubernetes_role_binding" "traefik_ingressroute_binding" {
#   metadata {
#     name      = "traefik-ingressroute-access-binding"
#     namespace = "demo-project"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.traefik_ingressroute_role.metadata[0].name
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = kubernetes_service_account.traefik.metadata[0].name
#     namespace = kubernetes_namespace.traefik.metadata[0].name
#   }
# }


# resource "kubernetes_cluster_role" "traefik" {
#   metadata {
#     name = "traefik-cluster-role"
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["services", "endpoints", "pods", "nodes"]
#     verbs      = ["get", "list", "watch"]
#   }

#   rule {
#     api_groups = ["extensions", "networking.k8s.io"]
#     resources  = ["ingresses"]
#     verbs      = ["get", "list", "watch"]
#   }

#   rule {
#     api_groups = ["networking.k8s.io"]
#     resources  = ["ingressclasses"]
#     verbs      = ["get", "list", "watch"]
#   }
# }

# resource "kubernetes_cluster_role_binding" "traefik" {
#   metadata {
#     name = "traefik-role-binding"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = kubernetes_cluster_role.traefik.metadata[0].name
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = kubernetes_service_account.traefik.metadata[0].name
#     namespace = kubernetes_namespace.traefik.metadata[0].name
#   }
# }