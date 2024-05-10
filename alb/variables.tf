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