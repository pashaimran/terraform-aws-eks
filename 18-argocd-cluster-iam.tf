# resource "aws_iam_role" "argocd_cluster_role" {
#   name = "argocd-cluster-role"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRoleWithWebIdentity"
#       Effect = "Allow"
#       Principal = {
#         Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}"
#       }
#       Condition = {
#         StringEquals = {
#           "oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}:sub" = "system:serviceaccount:${var.argocd_cluster_namespace}:argocd-server"
#         }
#       }
#     }]
#   })
# }



# resource "aws_iam_policy" "argocd_cluster_policy" {
#   name        = "argocd-cluster-policy"
#   description = "Custom policy for ArgoCD to manage AWS resources"
  
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "eks:DescribeCluster",
#           "eks:ListClusters",
#           "eks:AccessKubernetesApi"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "elasticloadbalancing:CreateLoadBalancer",
#           "elasticloadbalancing:DescribeLoadBalancers",
#           "elasticloadbalancing:ModifyLoadBalancerAttributes",
#           "elasticloadbalancing:CreateTargetGroup",
#           "elasticloadbalancing:RegisterTargets",
#           "elasticloadbalancing:DeregisterTargets",
#           "elasticloadbalancing:DeleteTargetGroup",
#           "elasticloadbalancing:DescribeTargetGroups",
#           "elasticloadbalancing:DescribeListeners",
#           "elasticloadbalancing:CreateListener",
#           "elasticloadbalancing:DeleteListener",
#           "elasticloadbalancing:ModifyListener"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "route53:ChangeResourceRecordSets",
#           "route53:GetHostedZone",
#           "route53:ListHostedZones",
#           "route53:ListResourceRecordSets"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "iam:PassRole"
#         ]
#         Resource = "*"
#         Condition = {
#           "StringLike" = {
#             "iam:PassedToService" = "eks.amazonaws.com"
#           }
#         }
#       }
#     ]
#   })
# }

# # Attach the policy to ArgoCD's IAM Role
# resource "aws_iam_role_policy_attachment" "argocd_cluster_attach" {
#   role       = aws_iam_role.argocd_cluster_role.name
#   policy_arn = aws_iam_policy.argocd_cluster_policy.arn
# }
