module "alb-controller" {
  source              = "./alb-controller"
  elb_chart_version   = "1.7.1"
  alb-namespace       = "alb-controller"
  alb-serviceaccount  = "alb-controller-sa"
  eks-alb-policy-name = "eks-alb-controller-policy"
  eks-alb-role-name   = "eks-alb-controller-role"
  values_path         = "./values/alb-controller.yaml"
  cluster_name        = local.cluster_name
  account_id          = local.account_id
  eks_issuer_url      = local.eks_issuer_url
  eks_issuer_arn      = local.eks_issuer_arn

}