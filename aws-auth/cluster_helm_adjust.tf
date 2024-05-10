resource "kubernetes_labels" "aws_auth_labels" {
  api_version = "v1"
  kind        = "ConfigMap"
  field_manager = "labels"
  force = true
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
  field_manager = "annotations"
  force = true
  depends_on = [ kubernetes_labels.aws_auth_labels ]
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  annotations = {
    "meta.helm.sh/release-name" = "aws-auth"
    "meta.helm.sh/release-namespace" = "default"
  }
}
