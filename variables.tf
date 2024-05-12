variable "access_key" {
  description = " from terraform cloud"
  type        = string

}

variable "secret_key" {
  description = " from terraform cloud"
  type        = string

}

variable "region" {
  description = " from terraform cloud"
  type        = string

}


variable "cluster_name" {
    description = "The name of the EKS cluster."
    type = string
    default = "eks"
  
}
