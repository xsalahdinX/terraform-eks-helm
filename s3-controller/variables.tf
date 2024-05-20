variable "s3-controller-policy-name" {
  description = "The name of the policy for the S3 controller"
  default     = "s3_controller_policy"
}
variable "s3-controller-role-name" {
  description = "The name of the role for the S3 controller"
  default     = "s3-controller-role"
}
variable "s3-controller-serviceaccount" {
  description = "The name of the service account for the S3 controller"
  default     = "s3-controller"
}
variable "s3-controller-namespace" {
  description = "The namespace of the service account for the S3 controller"
  default     = "default"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "eks"

}
variable "s3-bucket-name" {
  description = "The name of the S3 bucket"
}

variable "region" {
  description = "The region of the S3 bucket"
  default     = "us-east-1"

}
variable "kms-key-arn" {
  description = "The ARN of the KMS key"
}