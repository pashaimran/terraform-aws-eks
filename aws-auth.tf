# Admin IAM User Access
resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.admin_user_name}"
        username = var.admin_user_name
        groups   = ["system:masters"]
      }
    ])

    mapRoles = yamlencode([
      {
        rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.eks_admin_role}"
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:masters"]
      }
    ])
  }

  depends_on = [aws_eks_cluster.main]
}
