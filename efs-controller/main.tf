resource "helm_release" "aws-efs-csi-driver" {
  name       = "aws-efs-csi-driver"
  namespace  = var.efs_controller_namespace
  create_namespace = true
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  version    = var.efs_controller_chart_version
  values = ["${file("${var.values_path}")}"]

  set {
    name  = "controller.serviceAccount.name"
    value = "${var.efs_serviceaccount}"
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${var.account_id}:role/${var.efs_role}"
  }

  set {
    name  = "storageClasses[0].name"
    value = "${var.efs_storage_class_name}"
  }
  set {
    name  = "storageClasses[0].parameters.fileSystemId"
    value = "${var.efs_id}"
    # value = aws_efs_file_system.eks-file-system.id
  }

}
