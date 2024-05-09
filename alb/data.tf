data "aws_eks_cluster" "eks_info" {
  name = var.cluster_name
}

locals {
  issuer = data.aws_eks_cluster.eks_info.identity[0].oidc[0].issuer
}

data "tls_certificate" "eks-cluster-tls-certificate" {
  url = local.issuer
}



data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
  # eks_oidc = replace(replace(aws_eks_cluster.eks_info.endpoint, "https://", ""), "/\\..*$/", "")
}


