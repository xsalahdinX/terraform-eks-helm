resource "aws_vpc_endpoint" "s3" {
  vpc_id            = data.aws_ssm_parameter.app_vpc_id.value
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = [data.aws_route_table.private-aws_route_table.id]
  vpc_endpoint_type = "Gateway"
  policy = file("./s3-controller/endpoint-policy.js")
  tags = {Name = "app-vpce-s3"}
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