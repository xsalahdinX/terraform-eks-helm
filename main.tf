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

# module "s3" {
#   source = "./s3-controller"
#   cluster_name = "eks"
#   s3-controller-role-name = "s3-controller-role"
#   s3-controller-serviceaccount = "s3-csi"
#   s3-controller-namespace = "s3-controller"
#   s3-bucket-name = "azzgamilsalahgg-s3-bucket"
#   s3-controller-policy-name = "s3-controller-policy"
#   kms-key-arn = "arn:aws:kms:us-east-1:905418093184:key/36079170-58e5-4098-9852-c97fc9488b12"

# }

