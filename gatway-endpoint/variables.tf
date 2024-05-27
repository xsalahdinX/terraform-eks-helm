variable "region" {
  description = "The region of the S3 bucket"
  default     = "us-east-1"

}

variable "resource_principal_map" {
  description = "Map of S3 resources to IAM roles"
  type        = map(string)
  default     = {
    "example-bucket-1" = "ExampleRole",
    "example-bucket-2" = "AnotherRole",
    "example-bucket-3" = "YetAnotherRole"
  } 
  
}

data "aws_caller_identity" "current" {}



variable "bucket_name" {
  description = "The name of the S3 bucket"
  type = set(string)
}

variable "s3_addon_iam_role_name" {
  description = "The ARN of the IAM role to be used by the S3 addon"
  type        = string
  default     = "s3-controller-role"
}



