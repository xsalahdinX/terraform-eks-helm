resource "aws_kms_key" "mykey" {
  description = "This key is used to encrypt bucket objects"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3-bucket-name
  tags = {Name = "My bucket", Environment = "Dev"}
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-conifgration" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
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
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.s3-bucket-name}/*"
        ]
      },
       {
           "Sid": "KMSAccess",
           "Effect": "Allow",
           "Action": [
               "kms:Decrypt",
           ],
           "Resource": [
               "${aws_kms_key.mykey.arn}"
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


resource "aws_iam_role_policy_attachment" "s3-controller-policy-attachment" {
  policy_arn = aws_iam_policy.bucket_policy.arn
  role       = aws_iam_role.s3-controller-role.name
  depends_on = [aws_iam_role.s3-controller-role]
}
