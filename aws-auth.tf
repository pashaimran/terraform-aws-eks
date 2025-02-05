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
        groups   = ["system:masters", "system:bootstrappers"]
      },

      # Adding worker nodes to system:nodes group
      {
        rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.eks_node_group_role}"  # IAM role for the worker node group
        username = "system:node:{{EC2PrivateDNSName}}"  # Dynamically generated username for each node
        groups   = ["system:bootstrappers", "system:nodes"]  # Nodes are typically part of bootstrappers and nodes groups
      }
    ])
  }

  force = true
  depends_on = [aws_eks_cluster.main]
}



# Creating a ClusterRoleBinding for the IAM user 'imran' to give them read-only access to nodes
resource "kubernetes_cluster_role_binding" "imran_node_access" {
  metadata {
    name = "imran-node-access"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"  # This grants read-only access to resources like nodes
  }

  subjects {
    kind      = "User"
    name      = "arn:aws:iam::264278751395:user/imran"  # Replace with your IAM user ARN
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [
    kubernetes_config_map_v1_data.aws_auth  # Ensure aws-auth is applied first
  ]
}