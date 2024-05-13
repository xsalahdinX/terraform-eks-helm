data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.eks-cluster-oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:alb-controller:alb-controller-sa" ]
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



#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": {
#         "Federated": "${data.aws_iam_openid_connect_provider.eks-cluster-oidc.arn}"
#       },
#       "Action": "sts:AssumeRoleWithWebIdentity",
#       "Condition": {
#         "StringEquals": {
#           "${replace(data.aws_iam_openid_connect_provider.eks-cluster-oidc.url, "https://", "")}:sub": "system:serviceaccount:alb-controller:alb-controller-sa",
#           "${replace(data.aws_iam_openid_connect_provider.eks-cluster-oidc.url, "https://", "")}:aud": "sts.amazonaws.com"
#         }
#       }
#     }
#   ]
# }
# POLICY