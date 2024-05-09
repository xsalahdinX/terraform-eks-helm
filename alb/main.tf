resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "eks/aws-load-balancer-controller"
  version    = "1.7.2"
  values = [
    "${file("values.yaml")}"
  ]

  # set {
  #   name  = "serviceAccount.annotations"
  #   value = "true"
  # }

  # set_list {
  #   name  = "serviceAccount.annotations"
  #   value = "{}"
  # }

  # set {
  #   name  = "service.annotations.prometheus\\.io/port"
  #   value = "9127"
  #   type  = "string"
  # }
}
