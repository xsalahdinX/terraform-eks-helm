resource "aws_efs_file_system" "eks-file-system" {
  creation_token = "my-efs"

  tags = {
    Name = "eks_efs"
  }
}

# resource "aws_efs_mount_target" "foo" {
#   count = length(data.aws_subnet.private_subnets)
#   file_system_id = aws_efs_file_system.eks-file-system.id
#   subnet_id      = data.aws_subnet.private_subnets[count.index].id
# }
resource "aws_efs_mount_target" "aws_efs_mount_targe" {
  count          = length(data.aws_subnet.private_subnets.ids)
  file_system_id = aws_efs_file_system.eks-file-system.id
  subnet_id      = data.aws_subnet.private_subnets.ids[count.index]
}

data "aws_subnet" "private_subnets" {
  filter {
    name   = "tag-key"
    values = ["Name"]
  }

  filter {
    name   = "tag-value"
    values = ["private_subnets_*"]
  }
}


