locals {
  cluster_name = "eks"
  account_id = data.aws_caller_identity.current.account_id
  eks_issuer_url = data.aws_iam_openid_connect_provider.eks-cluster-oidc.url
  eks_issuer_arn = data.aws_iam_openid_connect_provider.eks-cluster-oidc.arn
  s3_bucket_names = ["azzgamilsalahgg-s3-bucket"]
  aws_kms_alias = "alias/test"
}