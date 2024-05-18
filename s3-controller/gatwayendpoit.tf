resource "aws_vpc_endpoint" "s3" {
  vpc_id            = data.aws_vpc.eks-vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = [data.aws_route_table.private-aws_route_table.id]
  vpc_endpoint_type = "Gateway"
  policy            = local.s3-endpoint-policy
  tags              = { Name = "app-vpce-s3" }

}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Name"
    values = ["private_subnets_*"]
  }

}

data "aws_route_table" "private-aws_route_table" {
  subnet_id = data.aws_subnets.private_subnets.ids[0]
}


data "aws_vpc" "eks-vpc" {
  filter {
    name   = "tag:Name"
    values = ["EKS_VPC"]
  }

}

locals {
  s3-endpoint-policy = <<POLICY
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Action": "s3:GetObject",
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${var.s3-bucket-name}/*",
        "Principal": "*"
      },
      {
        "Action": "s3:*",
        "Effect": "Deny",
        "Resource": "arn:aws:s3:::${var.s3-bucket-name}/*",
        "Principal": "*",
        "Condition": {
          "StringNotEquals": {
            "s3:action": "s3:GetObject"
          }
        }
      }
    ]
  }
  POLICY
}
