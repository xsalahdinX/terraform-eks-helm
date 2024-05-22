data "aws_iam_policy_document" "s3-controller-policy-document" {
  statement {
    sid    = "MountpointFullBucketAccess"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.s3-bucket-name}"
    ]
  }
  statement {
    sid    = "MountpointFullObjectAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.s3-bucket-name}/*"
    ]
  }
  statement {
    sid    = "FullKMSAccess"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = [
      "${data.aws_kms_alias.s3.arn}"
    ]
  }
}

resource "aws_iam_policy" "s3-controller-policy" {
  name        = var.s3-controller-policy-name
  path        = "/"
  policy = data.aws_iam_policy_document.s3-controller-policy-document.json
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
  depends_on         = [aws_iam_policy.s3-controller-policy]
}

resource "aws_iam_role_policy_attachment" "s3-controller-policy-attachment" {
  policy_arn = aws_iam_policy.s3-controller-policy.arn
  role       = aws_iam_role.s3-controller-role.name
  depends_on = [aws_iam_role.s3-controller-role]
}

data "aws_kms_alias" "s3" {
  name = var.aws-kms-alias
}