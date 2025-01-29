output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "cluster_iam_role_name" {
  value = aws_iam_role.eks_cluster_role.name
}

output "node_group_id" {
  value = aws_eks_node_group.main.id
}