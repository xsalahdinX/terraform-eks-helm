module "efs-controller" {
  source = "github.com/xsalahdinX/terraform-modules//efs-controller"
  efs_controller_chart_version = "3.0.3"
  values_path              = "./values/efs-controller.yaml"
  efs_controller_namespace = "efs-controller"
  efs_serviceaccount       = "efs-csi-controller-sa"
  efs_role                 = "efs-controller-role"
  efs_storage_class_name   = "efs-sc"
  cluster_name             = local.cluster_name
  efs_id                   = module.efs-controller.efs_id
  eks_issuer_url           = local.eks_issuer_url
  eks_issuer_arn           = local.eks_issuer_arn
  account_id               = local.account_id
}