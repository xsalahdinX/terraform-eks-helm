resource "aws_efs_file_system" "eks-file-system" {
  creation_token = "my-efs"
  tags = {Name = "eks_efs"}
}

resource "aws_efs_mount_target" "foo" {
  for_each      = toset(data.aws_subnets.private_subnets.ids)
  file_system_id = aws_efs_file_system.eks-file-system.id
  subnet_id      = each.value
}


data "aws_subnets" "private_subnets" {
    filter {
    name   = "tag:Name"
    values = ["private_subnets_*"]
  }
}

