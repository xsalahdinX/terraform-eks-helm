resource "aws_vpc_endpoint" "s3" {
  vpc_id            = data.aws_vpc.eks-vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = [data.aws_route_table.private-aws_route_table.id]
  vpc_endpoint_type = "Gateway"
  policy            = data.aws_iam_policy_document.s3_endpoint_policy.json
  tags              = { Name = "app-vpce-s3" }

}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Name"
    values = ["private_subnets_*"]
  }

}

data "aws_route_table" "private-aws_route_table" {
  subnet_id = data.aws_subnets.private_subnets.ids[0]
}


data "aws_vpc" "eks-vpc" {
  filter {
    name   = "tag:Name"
    values = ["EKS_VPC"]
  }

}

data "aws_iam_policy_document" "s3_endpoint_policy" {
  dynamic "statement" {
    for_each = local.resource_principal_map

    content {
      sid    = "AllowAllActionsToAllPrincipals${statement.key}"
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
      resources = [statement.key]
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


variable "s3_resources" {
  description = "List of S3 resources to be included in the policy"
  type        = list(string)
  default     = [
    "arn:aws:s3:::example-bucket-1",
    "arn:aws:s3:::example-bucket-2",
    "arn:aws:s3:::example-bucket-3"
  ]
}


variable "roles" {
  description = "List of principals to be included in the policy"
  type        = list(string)
  default     = [
    "arn:aws:iam::123456789012:role/ExampleRole",
    "arn:aws:iam::123456789012:role/AnotherRole",
    "arn:aws:iam::123456789012:role/YetAnotherRole"

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