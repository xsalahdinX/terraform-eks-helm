# module "aws_auth" {
#   source          = "./aws-auth"
#   cluster_name    = "eks"
#   iam_admin_roles = ["eks_access_role"]
#   nodegroup_role  = ["eks_nodegroup_role"]

# }


# module "alb" {
#   source              = "./alb"
#   alb-namespace       = "alb-controller"
#   elb_chart_version   = "1.7.1"
#   alb-serviceaccount  = "alb-controller-sa"
#   account_id          = local.account_id
#   eks-alb-role-name   = "eks-alb-controller-role"
#   cluster_name        = "eks"
#   eks-alb-policy-name = "eks-alb-controller-policy"
# }


# module "efs" {
#   source = "./efs"
# }


module "test-s3" {
  source = "./test-s3"
  s3_bucket_name = "azzgamilsalahgg-s3-bucket"

  
}

# module "s3-controller" {
#   source = "./s3-controller"
#   cluster_name = "eks"
#   s3_bucket_name = ["azzgamilsalahgg-s3-bucket"]
#   aws_kms_alias = "alias/test"
#   depends_on = [ module.test-s3]
# }


 module "gatway-s3" {
  source = "./gatway-endpoint"
  region = "us-east-1"
  bucket_name = ["azzgamilsalahgg-s3-bucket", "azzgamilsalahgg-s3-bucket2"]
  depends_on = [ module.s3-controller]

 }