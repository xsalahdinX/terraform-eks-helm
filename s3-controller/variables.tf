variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "eks"

}
variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type = set(string)
}

variable "aws_kms_alias" {
  description = "The alias of the KMS key"
  default = "alias/test"
  
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

variable "s3_controller_namespace" {
  description = "The namespace of the service account for the S3 controller"
  type        = string
  default     = "kube-system"
}
