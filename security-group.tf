# Security Group for EKS Nodes
resource "aws_security_group" "eks_nodes" {
  name_prefix = "${aws_eks_cluster.main.name}-nodes-"
  description = "Security group for EKS nodes"
  vpc_id      = aws_eks_cluster.main.vpc_config[0].vpc_id

  # Allow inbound traffic from the EKS cluster Security Group
  ingress {
    description     = "Allow traffic from EKS cluster security group"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_eks_cluster.main.vpc_config[0].cluster_security_group_id]  # ✅ Corrected
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# # Security Group for NGINX Ingress Controller
# resource "aws_security_group" "nginx_ingress" {
#   name_prefix = "${aws_eks_cluster.main.name}-ingress-"
#   description = "Security group for NGINX Ingress Controller"
#   vpc_id      = aws_eks_cluster.main.vpc_config[0].vpc_id

#   ingress {
#     description = "Allow HTTP traffic"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow HTTPS traffic"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Security Group for Monitoring (Prometheus and Grafana)
# resource "aws_security_group" "monitoring" {
#   name_prefix = "${aws_eks_cluster.main.name}-monitoring-"
#   description = "Security group for Prometheus and Grafana"
#   vpc_id      = aws_eks_cluster.main.vpc_config[0].vpc_id

#   ingress {
#     description = "Allow Prometheus traffic"
#     from_port   = 9090
#     to_port     = 9090
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow Grafana traffic"
#     from_port   = 3000
#     to_port     = 3000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

#For the NGINX Ingress Controller security group:

# resource "helm_release" "nginx_ingress" {
#   name       = "nginx-ingress"
#   chart      = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   namespace  = "ingress-nginx"
#   create_namespace = true

#   values = [
#     <<EOF
# controller:
#   service:
#     annotations:
#       service.beta.kubernetes.io/aws-load-balancer-security-groups: "${aws_security_group.nginx_ingress.id}"
#     type: LoadBalancer
# EOF
#   ]
# }
