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

variable "account_id" {
    description = "The AWS account ID."
    type = string  
}

variable "chart_path" {
    description = "The path to the chart directory."
    type = string
  
}