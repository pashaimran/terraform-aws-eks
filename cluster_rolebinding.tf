resource "kubernetes_cluster_role_binding" "imran_node_access" {
  metadata {
    name = "imran-node-access"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"  # This grants read-only access to resources like nodes
  }

  # Corrected: Use `subject` instead of `subjects`
  subject {
    kind      = "User"
    name      = "arn:aws:iam::264278751395:user/imran"  # Replace with your IAM user ARN
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [
    kubernetes_config_map_v1_data.aws_auth  # Ensure aws-auth is applied first
  ]
}
