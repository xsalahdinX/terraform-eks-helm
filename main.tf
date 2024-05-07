module "aws_auth" {
  source = "./aws-auth"
  cluster_name = "eks-cluster"
  cluster_ca_certificate = data.aws_eks_cluster.eks.certificate_authority[0].data
  host = data.aws_eks_cluster.eks.endpoint
}


