terraform {
  cloud {
    organization = "aws-infra-practice" # Replace with your Terraform Cloud organization

    workspaces {
      name = "terraform-aws-eks" # Replace with your workspace name in Terraform Cloud
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63.1" # Keep your existing AWS provider version
    }
  }
}

# provider.tf
provider "aws" {
  region = var.aws_region  # Replace with your AWS region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)  # Updated
  token                  = data.aws_eks_cluster_auth.main.token
}

# data "aws_eks_cluster_auth" "eks" {
#   name = module.eks.cluster_name
# }

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.cluster.id]
      command     = "aws"
    }
  }
}


# data "aws_eks_cluster" "main" {
#   name = aws_eks_cluster.main.name
# }

data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}

data "aws_caller_identity" "current" {}

