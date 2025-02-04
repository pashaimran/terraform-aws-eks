# cluster-iam.tf
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# # OIDC associate, copy this oidc id after cluster creation and paste

resource "aws_iam_openid_connect_provider" "eks" {
  url             = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/https://oidc.eks.ap-south-1.amazonaws.com/id/C1875370041CE5C4CC2CAB39F0AA5396"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd60e22"] # Default EKS thumbprint
}
