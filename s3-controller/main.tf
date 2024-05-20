
resource "aws_kms_key" "mykey" {
  description = "This key is used to encrypt bucket objects"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3-bucket-name
  tags   = { Name = "My bucket", Environment = "Dev" }
}


resource "aws_s3_bucket" "default" {
  bucket        = var.s3-bucket-name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "default" {
  bucket = aws_s3_bucket.default.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encrypted" {
  bucket   = aws_s3_bucket.default.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms_encrypted" {
  bucket   = aws_s3_bucket.default.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.id
      sse_algorithm     = "aws:kms"
    }
  }
}




resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3-policy
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


data "aws_iam_policy_document" "s3-policy" {
  statement {
    sid     = "EnforceHttpsAlways"
    effect  = "Deny"
    actions = ["*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = ["arn:aws:s3:::${var.s3-bucket-name}", "arn:aws:s3:::${var.s3-bucket-name}/*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
  statement {
    sid     = "DenySSES3"
    effect  = "Deny"
    actions = ["s3:PutObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = ["arn:aws:s3:::${var.s3-bucket-name}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
  }
  statement {
    sid       = "RequireKMSEncryption"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.s3-bucket-name}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "StringNotLikeIfExists"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [aws_kms_key.mykey.arn]
    }
  }
}