# Retrieve the Prometheus and Grafana services from the Kubernetes cluster.

resource "aws_iam_role" "eks_admin" {
  name = "EKSAdminRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.admin_user_name}"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
