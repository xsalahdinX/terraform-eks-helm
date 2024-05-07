data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}


data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster" "eks_info" {
  name = var.cluster_name
}