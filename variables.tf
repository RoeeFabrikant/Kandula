variable "aws_region" {
  description     = "AWS region"
  default         = "us-east-1"
}

variable "kubernetes_version" {
  default         = 1.18
  description     = "kubernetes version"
}

resource "random_string" "suffix" {
  length          = 8
  special         = false
}

locals {
  cluster_name    = "kandula-eks-${random_string.suffix.result}"
}

locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "kandula-sa"
}

