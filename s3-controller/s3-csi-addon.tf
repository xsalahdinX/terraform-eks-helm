resource "aws_eks_addon" "s3_controller_addon" {
  cluster_name                = var.cluster_name
  addon_name                  = "aws-mountpoint-s3-csi-driver"
  addon_version               = "v1.5.1-eksbuild.1" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.s3_controller_role.arn
}