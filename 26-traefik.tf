# Helm release for Traefik
resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  namespace  = "traefik"
  create_namespace = true  # Let Helm manage namespace creation
  version    = "24.0.0"

  # Force recreation if exists
  replace        = true
  force_update   = true
  cleanup_on_fail = true

  values = [
    <<-EOT
    deployment:
      enabled: true
      replicas: 2
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "9100"

    ingressClass:
      enabled: true
      isDefaultClass: true

    serviceAccount:
      create: true

    rbac:
      enabled: true

    service:
      enabled: true
      type: LoadBalancer
      annotations:
        service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
        service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"

    ports:
      web:
        port: 80
        expose: true
        exposedPort: 80
        protocol: TCP
      websecure:
        port: 443
        expose: true
        exposedPort: 443
        protocol: TCP

    additionalArguments:
      - "--api.dashboard=true"
      - "--api.insecure=true"
      - "--providers.kubernetescrd"
      - "--log.level=INFO"

    dashboard:
      enabled: true
      insecure: true  # Allows access without authentication

    resources:
      requests:
        cpu: "100m"
        memory: "100Mi"
      limits:
        cpu: "300m"
        memory: "300Mi"

    securityContext:
      capabilities:
        drop: [ALL]
        add: [NET_BIND_SERVICE]
      readOnlyRootFilesystem: true
      runAsGroup: 65532
      runAsNonRoot: true
      runAsUser: 65532

    podSecurityContext:
      fsGroup: 65532
    EOT
  ]
}
