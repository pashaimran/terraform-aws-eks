output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

# output "node_group_status" {
#   value = aws_eks_node_group.main.status
# }

# output "cluster_version" {
#   value = aws_eks_cluster.main.version
# }

# output "node_group_id" {
#   value = aws_eks_node_group.main.id
# }

# output "node_group_role_arn" {
#   value = aws_iam_role.eks_node_group_role.arn
# }

# output "cluster_iam_role_name" {
#   value = aws_iam_role.eks_cluster_role.name
# }

# output "cluster_certificate_authority" {
#   value = aws_eks_cluster.main.certificate_authority[0].data
# }

# output "node_group_arn" {
#   value = aws_eks_node_group.main.arn
# }

# output "cluster_security_group_id" {
#   value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
# }

# output "cluster_iam_role_arn" {
#   value = aws_iam_role.eks_cluster_role.arn
# }

# output "node_group_role_name" {
#   value = aws_iam_role.eks_node_group_role.name
# }

# output "configure_kubectl" {
#   value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
# }
