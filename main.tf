module "aws_auth" {
  source          = "./aws-auth"
  cluster_name    = "eks"
  iam_admin_roles = ["eks_access_role"]
  nodegroup_role  = ["eks_nodegroup_role"]

}


module "alb" {
  source              = "./alb"
  elb_chart_version   = "1.7.1"
  cluster_name = "eks"
  alb-namespace = "alb-controller"
  alb-serviceaccount = "alb-controller-sa"
  eks-alb-policy-name = "eks-alb-controller-policy"
  eks-alb-role-name = "eks-alb-controller-role"
}


module "efs" {
  source = "./efs"
}


