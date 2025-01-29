### EKS Cluster Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

### EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = concat(var.public_subnet_ids, var.private_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = var.cluster_tags

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

### Node Group IAM Role
resource "aws_iam_role" "eks_node_group_role" {
  name = "${var.cluster_name}-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

### Security Group for Node Group
resource "aws_security_group" "node_group_sg" {
  name_prefix = "${var.cluster_name}-node-group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-node-group-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

### Launch Template
resource "aws_launch_template" "eks_node_group" {
  name_prefix   = "${var.cluster_name}-node-group-"
  instance_type = var.node_group_instance_types[0]

  user_data = base64encode(<<-EOF
  MIME-Version: 1.0
  Content-Type: multipart/mixed; boundary="==BOUNDARY=="

  --==BOUNDARY==
  Content-Type: text/x-shellscript; charset="us-ascii"

  #!/bin/bash
  set -ex
  /etc/eks/bootstrap.sh ${var.cluster_name} \
    --b64-cluster-ca ${aws_eks_cluster.main.certificate_authority[0].data} \
    --apiserver-endpoint ${aws_eks_cluster.main.endpoint}

  --==BOUNDARY==--
  EOF
  )

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.node_group_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda" # Default device name for Amazon Linux 2

    ebs {
      volume_size = 20 # Specify the disk size here
      volume_type = "gp2" # General Purpose SSD
      delete_on_termination = true
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-node"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

### EKS Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.private_subnet_ids

  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  launch_template {
    id      = aws_launch_template.eks_node_group.id
    version = "$Latest"
  }

  tags = merge(
    var.node_group_tags,
    {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_container_registry_policy,
  ]

  update_config {
    max_unavailable = 1
  }
}