variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "eks"

}
variable "efs_controller_chart_version" {
  description = "The version of the EFS CSI Driver Helm chart."
  type        = string
  default     = "2.3.3"
  
}
variable "efs_id" {
  description = "The ID of the EFS file system."
  type        = string  
}

variable "values_path" {
    description = "The path to the values file for the AWS Load Balancer Controller Helm chart."
    type = string
    default = "./values/efs_values.yaml"
  
}

variable "efs_controller_namespace" {
  description = "The namespace for the EFS CSI Driver."
  type        = string
  default     = "efs-controller"
  
}

variable "efs_serviceaccount" {
  description = "The AWS account ID."
  type        = string
  default     = "efs-controller-sa"
}

variable "efs_role" {
  description = "The name of the IAM role for the EFS CSI Driver."
  type        = string
  default     = "efs-controller-role"
  
}

variable "efs_storage_class_name" {
  description = "The name of the storage class."
  type        = string
  default     = "efs-sc"
  
}

variable "eks_issuer_url" {
    description = "The OIDC issuer URL for the EKS cluster."
    type = string
  
}

variable "eks_issuer_arn" {
    description = "The ARN of the OIDC provider for the EKS cluster."
    type = string
  
}

variable "account_id" {
    description = "The AWS account ID."
    type = string  
}