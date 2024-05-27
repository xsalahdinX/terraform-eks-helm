variable "s3_resources" {
  description = "List of S3 resources to be included in the policy"
  type        = list(string)
  default     = [
    "arn:aws:s3:::example-bucket-1",
    "arn:aws:s3:::example-bucket-2/*"
  ]
}


variable "bucket_name" {
  description = "The name of the S3 bucket"
  type = set(string)
}


variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = list(string)
  default     = ["example-bucket-1", "example-bucket-2"]
  
}

variable "roles" {
  description = "List of principals to be included in the policy"
  type        = list(string)
  default     = [
    "arn:aws:iam::123456789012:role/ExampleRole",
    "arn:aws:iam::123456789012:role/AnotherRole"
  ]
}

variable "s3_addon_iam_role_arn" {
  description = "The ARN of the IAM role to be used by the S3 addon"
  type        = string
  default     = "arn:aws:iam::123456789012:role/S3AddonRole"
}

locals {
  resource_principal_map = zipmap(var.s3_resources, var.roles)
}

data "aws_iam_policy_document" "s3_endpoint_policy" {
  dynamic "statement" {
    for_each = local.resource_principal_map

    content {
      sid    = "AllowAllActionsToAllPrincipals"
      effect = "Allow"

      actions = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucketMultipartUploads",
        "s3:ListBucketVersions",
        "s3:ListBucket",
        "s3:DeleteObject",
        "s3:ListMultipartUploadParts"
      ]
      resources = [statement.key, statement.key/*]
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      condition {
        test     = "ArnEquals"
        variable = "aws:PrincipalArn"
        values   = [statement.value]
      }
    }
  }
  
  statement {
    sid    = "AllowListBucket"
    effect = "Allow"

    actions = ["s3:ListBucket"]
    resources =[
      for bucket_name in var.bucket_name : "arn:aws:s3:::${bucket_name}"
    ]
      principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "ArnEquals"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::590183933432:role/s3-controller-role"]
    }
  }

statement {
    sid    = "AllowGetObject"
    effect = "Allow"

    actions = [ "s3:GetObject"]

    resources =[
      for bucket_name in var.bucket_name : "arn:aws:s3:::${bucket_name}/*"
    ]
  
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "ArnEquals"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::590183933432:role/s3-controller-role"]
    }
  }
}








module "s3_endpoint_policy" {
  source = "./path-to-your-module"

  s3_resources = [
    "arn:aws:s3:::example-bucket-1",
    "arn:aws:s3:::example-bucket-2/*"
  ]

  principals = [
    "arn:aws:iam::123456789012:role/ExampleRole",
    "arn:aws:iam::123456789012:role/AnotherRole"
  ]
}
