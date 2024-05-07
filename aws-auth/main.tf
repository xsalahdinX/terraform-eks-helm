resource "kubernetes_labels" "aws_auth_labels" {
  api_version = "v1"
  kind        = "ConfigMap"
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  labels = {
    "app.kubernetes.io/managed-by" = "Helm"
  }
}
resource "kubernetes_annotations" "aws_auth_annotations" {
  api_version = "v1"
  kind        = "ConfigMap"
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  annotations = {
    "meta.helm.sh/release-name": "aws-auth"
    "meta.helm.sh/release-namespace": "default"
  }
}

resource "helm_release" "aws_auth" {
  name       = "aws-auth"
  chart      = "./charts/aws-auth"
  
  
  set {
    name   = "accountId"
    value = "${local.account_id}"
  }
  set_list {
    name   = "nodegroup_role_arn"
    value = ["arn:aws:iam::${local.account_id}:role/node-group-role"]
  }
}
