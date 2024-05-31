data "aws_iam_policy_document" "s3_controller_policy_document" {
  statement {
    sid    = "MountpointFullBucketAccess"
    effect = "Allow"
    actions = ["s3:ListBucket","s3:GetObject"]
    resources = flatten([for bucket_name in var.s3_bucket_names : ["arn:aws:s3:::${bucket_name}", "arn:aws:s3:::${bucket_name}/*"]])
  }
  statement {
    sid    = "FullKMSAccess"
    effect = "Allow"
    actions = ["kms:Decrypt","kms:DescribeKey"]
    resources = ["${var.aws_kms_arn}"]
  }
}


resource "aws_iam_policy" "s3_controller_policy" {
  name   = var.s3_controller_policy_name
  policy = data.aws_iam_policy_document.s3_controller_policy_document.json
}


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:${var.s3_controller_serviceaccount}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [var.eks_issuer_arn]
      type        = "Federated"
    }
  }
}


resource "aws_iam_role" "s3_controller_role" {
  name               = var.s3_controller_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  depends_on         = [aws_iam_policy.s3_controller_policy]
}


resource "aws_iam_role_policy_attachment" "s3_controller_policy_attachment" {
  policy_arn = aws_iam_policy.s3_controller_policy.arn
  role       = aws_iam_role.s3_controller_role.name
  depends_on = [aws_iam_role.s3_controller_role]
}
