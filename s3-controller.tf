# module "s3-controller" {
#   source = "./s3-controller"
#   cluster_name = local.cluster_name
#   s3_bucket_names = local.s3_bucket_names
#   aws_kms_arn = data.aws_kms_key.by_alias.arn
#   eks_issuer_url = local.eks_issuer_url
#   eks_issuer_arn = local.eks_issuer_arn
#   s3_controller_policy_name = "s3-controller-policy"
#   s3_controller_serviceaccount = "s3-csi-driver-sa"
#   s3_controller_role_name = "s3-controller-role"
#   depends_on = [ module.gatway-s3 ]
# }




module "test-s3" {
  source = "./test-s3"
  s3_bucket_name = "azzgamilsalahgg-s3-bucket"

}

 module "gatway-s3" {
  source = "./gatway-endpoint"
  region = "us-east-1"
  bucket_name = ["azzgamilsalahgg-s3-bucket", "azzgamilsalahgg-s3-bucket2"]
  depends_on = [ module.test-s3]

 }