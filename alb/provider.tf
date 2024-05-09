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