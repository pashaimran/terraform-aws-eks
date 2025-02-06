# terraform/module/eks/main.tf --- ALB CONTROLLER
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.alb_controller_version

  timeout = 600  # Timeout in seconds, adjust as needed

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "image.tag"
    value = "v2.4.2"
  }

#   set {
#     name  = "serviceAccount.create"
#     value = "false"
#   }

  set {
    name  = "serviceAccount.name"
    value = aws_iam_role.alb_role.name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.alb_role.arn
}
}


# Deploy Nginx Ingress after ALB Controller
resource "helm_release" "nginx_ingress" {
  name        = "nginx-ingress"
  repository  = "https://kubernetes.github.io/ingress-nginx"
  chart       = "ingress-nginx"
  namespace   = "ingress-nginx"
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
