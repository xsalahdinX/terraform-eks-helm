resource "aws_iam_policy" "service-account-policy" {
  name        = "s3_controller_policy"
  path        = "/"
  description = "My s3 policy"
 policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "MountpointFullBucketAccess",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.s3-bucket-name}"
        ]
      },
      {
        "Sid" : "MountpointFullObjectAccess",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.s3-bucket-name}/*"
        ]
      },
      {
        "Sid" : "FullKMSAccess",
        "Effect" : "Allow",
        "Action" : "kms:*",
        "Resource" : "*"
      }
    ]
  })
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.eks-cluster-oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:s3-csi-driver-sa"]
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



resource "aws_iam_role" "s3-controller-role" {
  name               = var.s3-controller-role-name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags               = { "ServiceAccountName" = var.s3-controller-serviceaccount, "ServiceAccountNameSpace" = var.s3-controller-namespace }
  depends_on         = [aws_iam_policy.service-account-policy]
}

resource "aws_iam_role_policy_attachment" "s3-controller-policy-attachment" {
  policy_arn = aws_iam_policy.service-account-policy.arn
  role       = aws_iam_role.s3-controller-role.name
  depends_on = [aws_iam_role.s3-controller-role]
}
