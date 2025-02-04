# # variables.tf
# variable "aws_region" {
#   description = "AWS region"
#   type        = string
#   default     = "us-west-2"
# }

# variable "cluster_name" {
#   description = "Name of the EKS cluster"
#   type        = string
#   default     = "my-eks-cluster"
# }

# variable "vpc_id" {
#   description = "VPC ID where the cluster will be created"
#   type        = string
# }

# variable "private_subnet_ids" {
#   description = "List of private subnet IDs"
#   type        = list(string)
# }

# variable "node_group_desired_size" {
#   description = "Desired number of worker nodes"
#   type        = number
#   default     = 2
# }

# variable "node_group_max_size" {
#   description = "Maximum number of worker nodes"
#   type        = number
#   default     = 4
# }

# variable "node_group_min_size" {
#   description = "Minimum number of worker nodes"
#   type        = number
#   default     = 1
# }

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# variable "subnet_ids" {
#   description = "List of subnet IDs for the EKS cluster"
#   type        = list(string)
# }

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

# variable "node_group_name" {
#   description = "Name of the EKS node group"
#   type        = string
# }

variable "instance_types" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "node_group_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "node_group_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "cluster_version" {
  description = "The desired Kubernetes version for your EKS cluster."
  type        = string
 # default     = "1.26"
}

variable "cluster_tags" {
  description = "A map of tags to assign to the EKS cluster."
  type        = map(string)
  default     = {}
}

variable "node_group_tags" {
  description = "A map of tags to assign to the EKS node groups."
  type        = map(string)
  default     = {}
}

# variable "aws_account_id" {
#   default = data.aws_caller_identity.current.account_id
# }

# variable "ami_id" {
#   description = "The AMI ID to use for the EC2 instances in the EKS node group."
#   type        = string
# }

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
  default     = true
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}