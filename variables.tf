variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  cluster_name = "kandula-eks-${random_string.suffix.result}"
}

variable "kubernetes_version" {
  default = 1.18
  description = "kubernetes version"
}

