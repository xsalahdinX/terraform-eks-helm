variable "cluster_name" {
    description = "The name of the EKS cluster."
    type = string
    default = "eks"
  
}

variable "elb_chart_version" {
    description = "The version of the AWS Load Balancer Controller Helm chart."
    type = string
    default = "1.7.1"
  
}

variable "alb-sa"   {
    description = "The name of the service account for the AWS Load Balancer Controller."
    type = string
    default = "alb-controller-sa"
  
}

variable "alb-namespace" {
    description = "The namespace for the AWS Load Balancer Controller."
    type = string
    default = "alb-controller"
  
}

variable "eks-alb-policy-name" {
    description = "The name of the IAM policy for the AWS Load Balancer Controller."
    type = string
    default = "eks-alb-controller-policy"
  
}

variable "eks-alb-role-name" {
    description = "The name of the IAM role for the AWS Load Balancer Controller."
    type = string
    default = "eks-alb-controller-role"
  
}