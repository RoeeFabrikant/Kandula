# VPC VARIABLES

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  description = "the project name"
  type        = string
}

variable "vpc_cidr" {
  description = "your vpc CIDR"
  type        = string
}

variable "private_subnet_cidr" {
  type        = list(string)
  default     = ["10.10.10.0/24", "10.10.11.0/24"]
}

variable "public_subnet_cidr" {
  type        = list(string)
  default     = ["10.10.20.0/24", "10.10.21.0/24"]
}

variable "k8s_cluster_name" {
  type        = string
}
