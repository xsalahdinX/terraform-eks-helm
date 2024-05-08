variable "cluster_name" {
    description = "The name of the EKS cluster."
    type = string
    default = "eks_cluster"
  
}

variable "iam_admin_roles" {
    description = "List of IAM roles to map to the `system:masters` RBAC role."
    type = list(string)
    default = []
  
}

variable "nodegroup_role" {
    description = "List of IAM roles to Nodegroups."
    type = list(string)
    default = []

}