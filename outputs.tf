# outputs.tf
output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster API server"
  value       = module.aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority" {
  description = "The base64 encoded certificate data required to communicate with the cluster"
  value       = module.aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = module.aws_eks_cluster.main.role_arn
}

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = module.aws_iam_role.eks_cluster_role.name
}

output "cluster_version" {
  description = "The Kubernetes version of the EKS cluster"
  value       = module.aws_eks_cluster.main.version
}

output "node_group_id" {
  description = "EKS Node Group ID"
  value       = module.aws_eks_node_group.main.id
}

output "node_group_arn" {
  description = "EKS Node Group ARN"
  value       = module.aws_eks_node_group.main.arn
}

output "node_group_role_arn" {
  description = "IAM role ARN for EKS Node Group"
  value       = module.aws_iam_role.eks_node_group_role.arn
}

output "node_group_role_name" {
  description = "IAM role name for EKS Node Group"
  value       = module.aws_iam_role.eks_node_group_role.name
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = module.aws_eks_node_group.main.status
}

output "configure_kubectl" {
  description = "Command to configure kubectl to connect to the EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.aws_eks_cluster.main.name}"
}
