resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.elb_chart_version
  values = [
    "${file("./alb/values.yaml")}"
  ]

  set {
    name  = "serviceAccount.serviceAccount.annotations"
    value = "arn:aws:iam::${local.account_id}:role/alb-ingress-controller"
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}
