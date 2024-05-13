resource "aws_iam_policy" "ALBIngressControllerIAMPolicy" {
    name = "${var.eks-alb-policy-name}"
    policy = file("./alb/policies/iam-policy.json")
}
resource "aws_iam_role" "alb-ingress-controller-role" {
  name = "${var.eks-alb-role-name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {"ServiceAccountName" = "${var.alb-sa}", "ServiceAccountNameSpace" = "${var.alb-namespace}"
  }
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
