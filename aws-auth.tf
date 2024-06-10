module "aws-auth" {
  source = "github.com/xsalahdinX/terraform-modules//aws-auth"
  account_id = local.account_id
  iam_admin_roles = ["eks_access_role"]
  nodegroup_role  = ["eks_nodegroup_role"]   
}