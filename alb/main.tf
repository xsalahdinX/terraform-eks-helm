resource "helm_release" "aws-load-balancer-controller" {
  name       = "alb-controller-helm-release"
  namespace  = "${var.alb-namespace}"
  create_namespace = true
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.elb_chart_version
  values = ["${file("./alb/values.yaml")}"]
  set {
    name  = "serviceAccount.name"
    value = "${var.alb-sa}"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${local.account_id}:role/${var.eks-alb-role-name}"
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}
