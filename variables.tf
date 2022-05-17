# Reference: https://www.terraform.io/language/configuration-0-11/variables
variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = ""
}

variable "cluster_env" {
  type        = string
  description = "EKS cluster environment: alpha / beta / staging / production"
  default     = ""
}

variable "prj_code" {
  type        = string
  description = "Project ID or unique key"
  default     = ""
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
  default     = ""
}

variable "cluster_iam_role" {
  type        = string
  description = "IAM Role ARN for EKS Cluster"
  default     = ""
}

variable "nodegroup_iam_role" {
  type        = string
  description = "IAM Role ARN for EKS Node Group"
  default     = ""
}

variable "vpc_subnets" {
  type        = list
  description = "VPC Subnet list"
  default     = [""]
}

variable "vpc_security_groups" {
  type        = list
  description = "VPC Security Groups list"
  default     = [""]
}

variable "private_access" {
  type        = string
  description = "Configure access to the Kubernetes API server endpoint"
  default     = "true"
}

variable "public_access" {
  type        = string
  description = "Configure access to the Kubernetes API server endpoint"
  default     = "false"
}

variable "nodegroup_shape_service_api" {
  type        = list
  description = "Amazon EC2 Instance Types for EKS Node service API"
  default     = [""] 
}

variable "nodegroup_shape_service_rabbitmq" {
  type        = list
  description = "Amazon EC2 Instance Types for EKS Node Sevice RabbitMQ"
  default     = [""] 
}

variable "nodegroup_shape_service_elastic" {
  type        = list
  description = "Amazon EC2 Instance Types for EKS Node Sevice ElasticSearch"
  default     = [""] 
}

variable "nodegroup_ssh_key" {
  type        = string
  description = "EC2 SSH Key"
  default     = ""
}

