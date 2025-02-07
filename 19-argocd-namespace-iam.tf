resource "aws_iam_role" "argocd_ns_role" {
  name = "argocd-ns-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}"
      }
      Condition = {
        StringEquals = {
          "oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}:sub" = "system:serviceaccount:${var.argocd_namespace}:argocd-ns-sa"
        }
      }
    }]
  })
}


resource "aws_iam_policy" "argocd_ns_policy" {
  name        = "argocd-ns-policy"
  description = "Policy for namespace-level ArgoCD"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi",
          "eks:*"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = "arn:aws:s3:::my-argocd-bucket/*"
      }
    ]
  })
}


# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "argocd_ns_attach" {
  role       = aws_iam_role.argocd_ns_role.name
  policy_arn = aws_iam_policy.argocd_ns_policy.arn
}
