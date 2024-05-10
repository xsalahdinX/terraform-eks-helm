resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
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
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "storageClasses.name"
    value = "eks-efs-sc"
  }
  set {
    name  = "storageClasses.parameters.fileSystemId"
    value = "fs-1122aabb"
  }
  set {
    name  = "storageClasses.reclaimPolicy"
    value = "Delete"
  }

  set {
    name  = "storageClasses.volumeBindingMode"
    value = "Immediate"
  }
}