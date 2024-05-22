variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "eks"

}
variable "s3-bucket-name" {
  description = "The name of the S3 bucket"
  type = list(string)
}

variable "aws-kms-alias" {
  description = "The alias of the KMS key"
  default = "alias/test"
  
}

variable "s3-controller-policy-name" {
  description = "The name of the policy for the S3 controller"
  type        = string
  default     = "s3-controller-policy"
}

variable "s3-controller-role-name" {
  description = "The name of the role for the S3 controller"
  type        = string
  default     = "s3-controller-role"
}

variable "s3-controller-serviceaccount" {
  description = "The name of the service account for the S3 controller"
  type        = string
  default     = "s3-csi-driver-sa"
}

variable "s3-controller-namespace" {
  description = "The namespace of the service account for the S3 controller"
  type        = string
  default     = "kube-system"
}
