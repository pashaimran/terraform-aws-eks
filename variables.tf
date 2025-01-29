variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
}

# variable "public_subnet_ids" {
#   type        = list(string)
#   description = "List of public subnet IDs for the EKS cluster"
# }

# variable "private_subnet_ids" {
#   type        = list(string)
#   description = "List of private subnet IDs for worker nodes"
# }

# variable "vpc_id" {
#   type        = string
#   description = "VPC ID where the cluster will be deployed"
# }

variable "cluster_tags" {
  type        = map(string)
  description = "Additional tags for the EKS cluster"
  default     = {}
}

variable "node_group_name" {
  type        = string
  description = "Name of the EKS node group"
}

variable "node_group_instance_types" {
  type        = list(string)
  description = "List of instance types for the node group"
}

variable "node_group_desired_size" {
  type        = number
  description = "Desired number of worker nodes"
}

variable "node_group_max_size" {
  type        = number
  description = "Maximum number of worker nodes"
}

variable "node_group_min_size" {
  type        = number
  description = "Minimum number of worker nodes"
}

variable "node_group_tags" {
  type        = map(string)
  description = "Additional tags for the node group"
  default     = {}
}

variable "enable_vpc_cni" {
  description = "Enable VPC CNI addon"
  type        = bool
  default     = true
}

variable "enable_coredns" {
  description = "Enable CoreDNS addon"
  type        = bool
  default     = true
}

variable "enable_kube_proxy" {
  description = "Enable kube-proxy addon"
  type        = bool
  default     = true
}

variable "enable_ebs_csi" {
  description = "Enable EBS CSI Driver addon"
  type        = bool
  default     = false
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

