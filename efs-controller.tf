module "efs-controller" {
  source = "./efs"
  efs_controller_chart_version = "3.0.3"
  values_path              = "./values/efs-controller.yaml"
  efs_controller_namespace = "efs-controller"
  efs_serviceaccount       = "efs-csi-controller-sa"
  efs_role                 = "efs-controller-role"
  efs_storage_class_name   = "efs-sc"
  cluster_name             = local.cluster_name
  efs_id                   = var.efs_id
  eks_issuer_url           = var.eks_issuer_url
  eks_issuer_arn           = var.eks_issuer_arn
}