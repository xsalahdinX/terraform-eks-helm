terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_info.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_info.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_info.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_info.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
