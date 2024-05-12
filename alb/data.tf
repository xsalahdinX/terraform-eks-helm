data "aws_eks_cluster" "eks_info" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "eks-cluster-oidc" {
  url = data.aws_eks_cluster.eks_info.identity[0].oidc[0].issuer
}

data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
}





data "aws_eks_cluster" "eks_info" {
  name = var.cluster_name
}
data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}











