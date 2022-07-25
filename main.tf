# terraform init -backend-config="bucket=<BUCKET-NAME>" -backend-config="key=<path/to/terraform.tfstate>" -backend-config="region=<REGION>"
terraform {
  backend "s3" {
    bucket = ""
    key    = ""
    region = ""
  }
}

provider "aws" {
  region = var.aws_region
}

# AWS EKS Cluster
resource "aws_eks_cluster" "reportportal" {
  depends_on = [aws_cloudwatch_log_group.reportportal]

  name                      = "${var.prj_code}-reportportal-${var.cluster_env}-eks"
  role_arn                  = var.cluster_iam_role 
  version                   = var.cluster_version
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    subnet_ids              = var.vpc_subnets
    security_group_ids      = var.vpc_security_groups
    endpoint_private_access = var.private_access
    endpoint_public_access  = var.public_access
  }

  tags = {
    "Environment" = var.cluster_env
    "Owner" = "terraform"
  }
}

resource "aws_cloudwatch_log_group" "reportportal" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.prj_code}-reportportal-${var.cluster_env}-eks/cluster"
  retention_in_days = 7
}

# AWS EKS Node Group
# API Node Group
resource "aws_eks_node_group" "reportportal-api" {
  cluster_name    = aws_eks_cluster.reportportal.name
  node_group_name = "${var.prj_code}-api-${var.cluster_env}-nodegroup"
  node_role_arn   = var.nodegroup_iam_role
  subnet_ids      = var.vpc_subnets
  
  instance_types = var.nodegroup_shape_service_api
  capacity_type  = "ON_DEMAND"
  disk_size      = "50"

  labels = {
    "service" = "api"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key               = var.nodegroup_ssh_key
    source_security_group_ids = var.vpc_security_groups
  }
  
  tags = {
    "Environment" = var.cluster_env
    "Owner" = "terraform"
    "NodeGroup" = "api"
  }
}

# RabbitMQ Node Group
resource "aws_eks_node_group" "reportportal-rabbitmq" {
  cluster_name    = aws_eks_cluster.reportportal.name
  node_group_name = "${var.prj_code}-rabbitmq-${var.cluster_env}-nodegroup"
  node_role_arn   = var.nodegroup_iam_role
  subnet_ids      = var.vpc_subnets
  
  instance_types = var.nodegroup_shape_service_rabbitmq
  capacity_type  = "ON_DEMAND"
  disk_size      = "50"

  labels = {
    "service" = "rabbitmq"
  }

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key               = var.nodegroup_ssh_key
    source_security_group_ids = var.vpc_security_groups
  }
  
  tags = {
    "Environment" = var.cluster_env
    "Owner" = "terraform"
    "NodeGroup" = "rabbitmq"
  }
}

# ElasticSearch Node Group
resource "aws_eks_node_group" "reportportal-elastic" {
  cluster_name    = aws_eks_cluster.reportportal.name
  node_group_name = "${var.prj_code}-elastic-${var.cluster_env}-nodegroup"
  node_role_arn   = var.nodegroup_iam_role
  subnet_ids      = var.vpc_subnets
  
  instance_types = var.nodegroup_shape_service_elastic
  capacity_type  = "ON_DEMAND"
  disk_size      = "50"

  labels = {
    "service" = "elasticsearch"
  }

  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 3
  }

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key               = var.nodegroup_ssh_key
    source_security_group_ids = var.vpc_security_groups
  }
  
  tags = {
    "Environment" = var.cluster_env
    "Owner" = "terraform"
    "NodeGroup" = "elasticsearch"
  }
}

# Monitoring Node Group
resource "aws_eks_node_group" "reportportal-monitoring" {
  cluster_name    = aws_eks_cluster.reportportal.name
  node_group_name = "${var.prj_code}-monitoring-${var.cluster_env}-nodegroup"
  node_role_arn   = var.nodegroup_iam_role
  subnet_ids      = var.vpc_subnets
  
  instance_types = var.nodegroup_shape_service_elastic
  capacity_type  = "ON_DEMAND"
  disk_size      = "20"

  labels = {
    "service" = "monitoring"
  }

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key               = var.nodegroup_ssh_key
    source_security_group_ids = var.vpc_security_groups
  }
  
  tags = {
    "Environment" = var.cluster_env
    "Owner" = "terraform"
    "NodeGroup" = "monitoring"
  }
}
