data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.eks-cluster-oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.alb-namespace}:${var.alb-serviceaccount}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.eks-cluster-oidc.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.eks-cluster-oidc.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_policy" "ALBIngressControllerIAMPolicy" {
    name = "${var.eks-alb-policy-name}"
    policy = file("./alb/iam-policy.json")
}
resource "aws_iam_role" "alb-ingress-controller-role" {
  name = "${var.eks-alb-role-name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {"ServiceAccountName" = "${var.alb-serviceaccount}", "ServiceAccountNameSpace" = "${var.alb-namespace}"}
  depends_on = [ aws_iam_policy.ALBIngressControllerIAMPolicy ]
}
resource "aws_iam_role_policy_attachment" "alb-ingress-controller-role-ALBIngressControllerIAMPolicy" {
  policy_arn = aws_iam_policy.ALBIngressControllerIAMPolicy.arn
  role       = aws_iam_role.alb-ingress-controller-role.name
  depends_on = [aws_iam_role.alb-ingress-controller-role]
}
resource "aws_iam_role_policy_attachment" "alb-ingress-controller-role-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.alb-ingress-controller-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  depends_on = [aws_iam_role.alb-ingress-controller-role]
}
