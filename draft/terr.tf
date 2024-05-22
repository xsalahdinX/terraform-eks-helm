module "s3-csi-driver" {
  source = "git::https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/vois-coe-terraform-modules//eks/addons?ref=v2.8.0"
  eks_issuer      = data.aws_eks_cluster.eks_data.identity[0].oidc[0].issuer
  aws-kms-alias = "alias/vois-coe-kms"
  s3-bucket-name = ["vois-envirtual-preprod-562194619178"]
  tags = local.tags
}


