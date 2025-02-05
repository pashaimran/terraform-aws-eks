# Admin IAM User Access
resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    # Adding the admin IAM user to system:masters group
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.admin_user_name}"
        username = var.admin_user_name
        groups   = ["system:masters"]
      }
    ])

    # Adding the EKS admin role to system:masters group
    mapRoles = yamlencode([
      {
        rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.eks_admin_role}"
        username = "admin"  # Use admin username for the EKS admin role
        groups   = ["system:masters"]
      }
    ])
  }

  force = true
  depends_on = [aws_eks_cluster.main]
}
