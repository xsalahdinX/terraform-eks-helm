module "aws_auth" {
  source          = "./aws-auth"
  cluster_name    = "eks"
  iam_admin_roles = ["eks_access_role"]
  nodegroup_role  = ["eks_nodegroup_role"]

}


module "alb" {
  source              = "./alb"
  elb_chart_version   = "1.7.1"
  cluster_name        = "eks"
  alb-namespace       = "alb-controller"
  alb-serviceaccount  = "alb-controller-sa"
  eks-alb-policy-name = "eks-alb-controller-policy"
  eks-alb-role-name   = "eks-alb-controller-role"
}


# module "efs" {
#   source = "./efs"
# }
 module "gatway-s3" {
  source = "./gatway-endpoint"
  region = "us-east-1"
  bucket_name = ["azzgamilsalahgg-s3-bucket, azzgamilsalahgg-s3-bucket2"]
  s3_bucket_name = "azzgamilsalahgg-s3-bucket"

   
 }
module "s3" {
  source = "./s3-controller"
  cluster_name = "eks"
  s3_bucket_name = ["azzgamilsalahgg-s3-bucket"]
  aws_kms_alias = "alias/test"
  depends_on = [ module.gatway-s3 ]
}
