# terraform/module/eks/main.tf --- ALB CONTROLLER
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.alb_controller_version

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = aws_iam_role.alb_role.name
  }
}

# IAM ROLE for ALB controller
resource "aws_iam_role" "alb_role" {
  name = "aws-load-balancer-controller-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          "StringEquals" = {
            "${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

# IAM policies for the IAM role

resource "aws_iam_policy" "alb_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM Policy for AWS Load Balancer Controller"

  policy = file("aws_load_balancer_controller_policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.alb_role.name
  policy_arn = aws_iam_policy.alb_policy.arn
}


# NGINX INGRESS controller

# Deploy Nginx Ingress after ALB Controller
resource "helm_release" "nginx_ingress" {
  name        = "nginx-ingress"
  repository  = "https://kubernetes.github.io/ingress-nginx"
  chart       = "ingress-nginx"
  namespace   = "kube-system"
  version     = var.ingress_version

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  depends_on  = [helm_release.aws_load_balancer_controller]
}


# terraform/module/eks/variable.tf
variable "alb_controller_version" {
  description = "Version of AWS Load Balancer Controller Helm chart"
  type        = string
}

variable "ingress_version" {
  description = "Version of Nginx Ingress Helm chart"
  type        = string
}


# terraform/module/eks/output.tf
output "alb_controller_status" {
  description = "Status of the AWS Load Balancer Controller"
  value       = helm_release.aws_load_balancer_controller.status
}