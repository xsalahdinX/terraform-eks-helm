
data "aws_eks_cluster" "eks_info" {
  name = var.cluster_name
}
data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}