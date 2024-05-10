resource "helm_release" "aws-efs-csi-driver" {
  name       = "aws-efs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  version    = "3.0.3"
  values = [
    "${file("./efs/values.yaml")}"
  ]

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  set {
    name  = "controller.serviceAccount.annotations"
    value = "arn:aws:iam::${local.account_id}:role/efs-csi-role-role"
  }

  set {
    name  = "node.serviceAccount.name"
    value = "efs-csi-node-sa"
  }
  set {
    name  = "node.serviceAccount.annotations"
    value = "arn:aws:iam::${local.account_id}:role/efs-csi-node-role"
  }



  set {
    name  = "storageClasses[0].name"
    value = "eks-efs-sc"
  }
  set {
    name  = "storageClasses[0].parameters.fileSystemId"
    value = aws_efs_file_system.eks-file-system.id
  }

}
