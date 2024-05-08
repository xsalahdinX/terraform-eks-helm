module "aws_auth" {
  source       = "./aws-auth"
  cluster_name = "eks_cluster"
  iam_admin_roles = ["eks_access_role"]
  nodegroup_role = ["eks_nodegroup_role"]

}


