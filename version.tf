# TERRAFORM VERSION & BACKEND INFO

terraform {
  required_version = ">= 0.12"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 2.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">=1.13.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.28.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 1.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.1"
    }
  }
}

terraform {
   backend "s3" {
       bucket  = "<YOUR-S3-BUCKET-NAME>"
       key     = "terraform-kandula/terraform.tfstate"
       region  = "us-east-1"
   }
}

