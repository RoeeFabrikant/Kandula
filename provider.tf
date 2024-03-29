# PROVIDERS

provider "aws" {
    region = var.aws_region
}

provider "random" {
}

provider "local" {
}

provider "null" {
}

provider "template" {
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}