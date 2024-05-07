variable "host" {
    description = "The Kubernetes host. Set to the EKS cluster endpoint."   
    type = string
}

variable "cluster_ca_certificate" {
    description = "The base64 encoded PEM. Set to the EKS cluster certificate-authority-data."
    type = string
  
}

variable "cluster_name" {
    description = "The name of the EKS cluster."
    type = string
    default = "eks-cluster"
  
}