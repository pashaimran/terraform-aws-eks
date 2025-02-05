# # # Retrieve AWS Account ID Dynamically
# # data "aws_caller_identity" "current" {}

# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = <<YAML
# - rolearn: ${aws_iam_role.eks_node_group_role.arn}
#   username: system:node:{{EC2PrivateDNSName}}
#   groups:
#     - system:bootstrappers
#     - system:nodes
# - rolearn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AdminRole
#   username: admin
#   groups:
#     - system:masters
# YAML
#   }
# }

