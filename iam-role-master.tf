resource "aws_iam_role" "eks" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_identity_provider_config" "oidc" {
  cluster_name = aws_eks_cluster.main.name

  oidc {
    client_id                     = "sts.amazonaws.com"
    identity_provider_config_name = "${aws_eks_cluster.main.name}-oidc"
    issuer_url                    = aws_eks_cluster.main.identity.0.oidc.0.issuer
  }
}

# # # OIDC associate, copy this oidc id after cluster creation and paste

# resource "aws_iam_openid_connect_provider" "eks" {
#   url             = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/https://oidc.eks.ap-south-1.amazonaws.com/id/BA603EA87C513EB480CF5EF8F3174989"
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd60e22"] # Default EKS thumbprint
# }
