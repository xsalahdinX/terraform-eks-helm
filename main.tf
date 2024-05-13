module "aws_auth" {
  source          = "./aws-auth"
  cluster_name    = "eks"
  iam_admin_roles = ["eks_access_role"]
  nodegroup_role  = ["eks_nodegroup_role"]

}


module "alb" {
  source              = "./alb"
  cluster_name        = "eks"
  elb_chart_version   = "1.7.1"
  alb_sa              = "alb-controller-sa"
  alb_namespace       = "alb-controller"
  eks_alb_policy_name = "eks-alb-controller-policy"
  eks_alb_role_name   = "eks-alb-controller-role"

}


module "efs" {
  source = "./efs"
}


