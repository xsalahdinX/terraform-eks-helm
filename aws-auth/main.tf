resource "helm_release" "aws_auth" {
  name       = "aws-auth"
  chart      = "./charts/aws-auth"
  

  set {
    name   = "accountId"
    value = "${local.account_id}"
 }
  set {
    name   = "nodegroup_role_arn"
    value = "[arn:aws:iam::${local.account_id}:role/node-group-role]"
 }

}