resource "aws_iam_policy" "ALBIngressControllerIAMPolicy" {
    name = "AWSLoadBalancerControllerIAMPolicy"
    description = "Allow ELB to describe and modify its load balancers"
    policy = file("./alb/iam-policy.json")
}

resource "aws_iam_role" "alb-ingress-controller-role" {
  name = "alb-ingress-controller"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Federated": "${data.aws_iam_openid_connect_provider.eks-cluster-oidc.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${replace(aws_iam_openid_connect_provider.eks-cluster-oidc.url, "https://", "")}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller",
          "${replace(aws_iam_openid_connect_provider.eks-cluster-oidc.url, "https://", "")}:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
POLICY

  depends_on = [aws_iam_openid_connect_provider.eks-cluster-oidc]

  tags = {
    "ServiceAccountName" = "alb-ingress-controller"
    "ServiceAccountNameSpace" = "kube-system"
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