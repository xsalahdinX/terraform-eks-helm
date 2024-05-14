resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3-bucket-name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "aws_iam_policy" "bucket_policy" {
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
          "s3:GetObject",
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.s3-bucket-name}/*"
        ]
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
      values   = ["system:serviceaccount:kube-system:s3-csi-*"]
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
  tags = {"ServiceAccountName" = var.s3-controller-serviceaccount, "ServiceAccountNameSpace" = var.s3-controller-namespace}
  depends_on = [ aws_iam_policy.bucket_policy ]
}


resource "aws_eks_addon" "s3-controller-addon" {
  cluster_name                = var.cluster_name
  addon_name                  = "aws-mountpoint-s3-csi-driver"
  addon_version               = "v1.5.1-eksbuild.1" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn = aws_iam_role.s3-controller-role.arn
}
