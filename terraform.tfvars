# terraform.tfvars
aws_region = "ap-south-1"
cluster_name = "my-eks-cluster"
vpc_id = "vpc-0e41739252a7e8e7e"# Replace with your VPC ID
private_subnet_ids =  ["subnet-0f6af018b0e0426b6", "subnet-0f8380b72381e688e"]# Replace with your subnet IDs
node_group_desired_size = 2
node_group_max_size = 4
node_group_min_size = 1