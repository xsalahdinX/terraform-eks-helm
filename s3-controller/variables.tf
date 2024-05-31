variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "eks"

}
variable "s3_bucket_names" {
  description = "The name of the S3 bucket"
  type = set(string)
}

variable "s3_controller_policy_name" {
  description = "The name of the policy for the S3 controller"
  type        = string
  default     = "s3-controller-policy"
}

variable "s3_controller_role_name" {
  description = "The name of the role for the S3 controller"
  type        = string
  default     = "s3-controller-role"
}

variable "s3_controller_serviceaccount" {
  description = "The name of the service account for the S3 controller"
  type        = string
  default     = "s3-csi-driver-sa"
}


variable "eks_issuer_url" {
    description = "The OIDC issuer URL for the EKS cluster."
    type = string
  
}

variable "eks_issuer_arn" {
    description = "The ARN of the OIDC provider for the EKS cluster."
    type = string
  
}

variable "aws_kms_arn" {
    description = "The ARN of the KMS key"
    type = string
}