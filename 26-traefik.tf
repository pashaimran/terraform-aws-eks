# resource "kubernetes_namespace" "traefik" {
#   metadata {
#     name = "traefik"
#   }
# }

# resource "helm_release" "traefik" {
#   name       = "traefik"
#   repository = "https://traefik.github.io/charts"
#   chart      = "traefik"
#   namespace  = kubernetes_namespace.traefik.metadata[0].name
#   create_namespace = true  # Let Helm manage namespace creation

#   values = [
#     <<EOF
# deployment:
#   enabled: true

# service:
#   enabled: true
#   type: LoadBalancer
#   externalTrafficPolicy: Local
#   annotations:
#     service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
#     service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
#     service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"

# rbac:
#   enabled: true

# ingressRoute:
#   dashboard:
#     enabled: true
#     matchRule: PathPrefix(`/dashboard`)

# ingressClass:
#   enabled: true
#   isDefaultClass: true


# EOF
#   ]
# }
