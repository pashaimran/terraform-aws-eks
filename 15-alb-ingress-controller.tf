resource "helm_release" "alb_controller" {
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  create_namespace = true
  timeout          = 600

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.alb_controller.arn
  }

  set {
    name  = "ingressClass"
    value = "alb"
  }

  set {
    name  = "enableServiceController"
    value = "true"
  }

  set {
    name  = "vpcId"
    value = data.aws_eks_cluster.this.vpc_config[0].vpc_id
  }

  set {
    name  = "region"
    value = data.aws_region.current.name
  }

  # Remove these settings as they're not needed and might cause issues
  # set {
  #   name  = "server.insecure"
  #   value = "true"
  # }
  # set {
  #   name  = "configs.params.server\\.insecure"
  #   value = "true"
  # }
  # set {
  #   name  = "server.ingress.enabled"
  #   value = "true"
  # }
  
  depends_on = [aws_iam_role_policy_attachment.alb_controller]
}



# output for alb controller

# modules/aws-load-balancer-controller/outputs.tf
output "iam_role_arn" {
  description = "ARN of IAM role for ALB controller"
  value       = aws_iam_role.alb_controller.arn
}

output "iam_role_name" {
  description = "Name of IAM role for ALB controller"
  value       = aws_iam_role.alb_controller.name
}



