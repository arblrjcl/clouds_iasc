
data "aws_region" "aws_region_details" {}

resource "aws_vpc_endpoint" "vpc_s3_gateway_endpoint" {
  vpc_id            = aws_vpc.vpc_instance.id
  service_name      = format("com.amazonaws.%s.s3", data.aws_region.aws_region_details.name)
  vpc_endpoint_type = "Gateway"
  tags              = merge(var.vpc_tags, { Name : "${var.project_name}_vpc_s3_gateway_endpoint" })
  depends_on        = [aws_network_acl.vpc_public_acls, aws_network_acl.vpc_private_acls]
}

resource "aws_vpc_endpoint_route_table_association" "vpc_public_subnets_s3_gateway_endpoint_association" {
  count           = length(var.vpc_public_subnets_cidr_blocks)
  route_table_id  = element(aws_route_table.vpc_public_rts[*].id, count.index)
  vpc_endpoint_id = aws_vpc_endpoint.vpc_s3_gateway_endpoint.id
}

resource "aws_vpc_endpoint_route_table_association" "vpc_private_subnets_s3_gateway_endpoint_association" {
  count           = length(var.vpc_private_subnets_cidr_blocks)
  route_table_id  = element(aws_route_table.vpc_private_rts[*].id, count.index)
  vpc_endpoint_id = aws_vpc_endpoint.vpc_s3_gateway_endpoint.id
}

