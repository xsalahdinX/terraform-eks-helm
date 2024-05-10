module "aws_auth" {
  source       = "./aws-auth"
  cluster_name = "eks"
  iam_admin_roles = ["eks_access_role"]
  nodegroup_role = ["eks_nodegroup_role"]

}


module "alb" {
  source       = "./alb"
  cluster_name = "eks"
  version    = "1.7.1"
}


module "efs" {
  source = "./efs"
}