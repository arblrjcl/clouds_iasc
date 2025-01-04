
resource "random_string" "resource_name_lower_case_suffix" {
  count            = var.random_strings_count
  length           = 6
  special          = false
  override_special = "/@£$"
  lower            = true
  upper            = false
  min_lower        = 3
  min_numeric      = 3
  min_special      = 0
  min_upper        = 0
  numeric          = true

  # To keep generated string unique
  keepers = {
    unique_id = "${count.index}"
  }
}

resource "aws_vpc" "vpc_instance" {
  cidr_block           = var.vpc_ipv4_cidr_block
  instance_tenancy     = var.vpc_tenancy
  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  tags                 = merge(var.vpc_tags, { Name : "${var.project_name}_vpc" })
}

resource "aws_internet_gateway" "vpc_igw_instance" {
  vpc_id = aws_vpc.vpc_instance.id
  tags   = merge(var.vpc_igw_instance_tags, { Name : "${var.project_name}_vpc_igw" })
}

resource "aws_subnet" "vpc_public_subnets" {
  count                   = length(var.vpc_public_subnets_cidr_blocks)
  cidr_block              = element(var.vpc_public_subnets_cidr_blocks, count.index)
  vpc_id                  = aws_vpc.vpc_instance.id
  map_public_ip_on_launch = var.vpc_public_subnets_map_public_ip_on_launch
  availability_zone       = element(var.vpc_public_subnets_availability_zones, count.index)
  tags                    = merge(var.vpc_public_subnets_tags, { Name : "${var.project_name}_vpc_public_subnet_${var.vpc_public_subnets_availability_zones[count.index]}_${random_string.resource_name_lower_case_suffix[count.index].id}", "kubernetes.io/role/elb" : 1, "Tier" : "Public" })
}

resource "aws_route_table" "vpc_public_rts" {
  count  = length(var.vpc_public_subnets_cidr_blocks)
  vpc_id = aws_vpc.vpc_instance.id
  route {
    cidr_block = var.ipv4_cidr_block_to_all_ip_addresses
    gateway_id = aws_internet_gateway.vpc_igw_instance.id
  }
  tags = merge(var.vpc_public_route_table_tags, { Name : format("%s%s", "${var.project_name}_vpc_public_rt_", "${var.vpc_public_subnets_availability_zones[count.index]}_${random_string.resource_name_lower_case_suffix[count.index].id}") })
}

resource "aws_route_table_association" "vpc_public_subnets_rt_associations" {
  count          = length(var.vpc_public_subnets_cidr_blocks)
  depends_on     = [aws_subnet.vpc_public_subnets, aws_route_table.vpc_public_rts]
  subnet_id      = element(aws_subnet.vpc_public_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.vpc_public_rts[*].id, count.index)
}

resource "aws_network_acl" "vpc_public_acls" {
  count      = length(var.vpc_public_subnets_cidr_blocks)
  depends_on = [aws_subnet.vpc_public_subnets]
  vpc_id     = aws_vpc.vpc_instance.id
  subnet_ids = [element(aws_subnet.vpc_public_subnets[*].id, count.index)]

  ingress {
    protocol   = "-1"
    rule_no    = 1
    action     = "allow"
    cidr_block = var.vpc_ipv4_cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 103
    action     = "allow"
    cidr_block = var.ipv4_cidr_block_to_all_ip_addresses
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_ipv4_cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 101
    action     = "allow"
    cidr_block = var.ipv4_cidr_block_to_all_ip_addresses
    from_port  = 0
    to_port    = 0
  }
  tags = merge(var.vpc_public_acl_tags, { Name : format("%s%s%s", "${var.project_name}_", "vpc_public_acl_", "${var.vpc_public_subnets_availability_zones[count.index]}_${random_string.resource_name_lower_case_suffix[count.index].id}") })
}

resource "aws_subnet" "vpc_private_subnets" {
  count             = length(var.vpc_private_subnets_cidr_blocks)
  cidr_block        = element(var.vpc_private_subnets_cidr_blocks, count.index)
  vpc_id            = aws_vpc.vpc_instance.id
  availability_zone = element(var.vpc_private_subnets_availability_zones, count.index)
  tags              = merge(var.vpc_public_subnets_tags, { Name : "${var.project_name}_vpc_private_subnet_${var.vpc_private_subnets_availability_zones[count.index]}_${random_string.resource_name_lower_case_suffix[count.index].id}", "kubernetes.io/role/internal-elb" : 1, "Tier" : "Private" })
}

resource "aws_eip" "vpc_nat_gw_eip" {
  count      = length(var.vpc_private_subnets_cidr_blocks)
  depends_on = [aws_internet_gateway.vpc_igw_instance]
  domain     = "vpc"
  tags       = merge(var.vpc_nat_gws_eips_tags, { Name : "${var.project_name}_vpc_nat_gw_${var.vpc_private_subnets_availability_zones[count.index]}_${random_string.resource_name_lower_case_suffix[count.index].id}", "kubernetes.io/role/internal-elb" : 1 })
}

resource "aws_nat_gateway" "vpc_nat_gateway_instances" {
  count         = length(var.vpc_private_subnets_cidr_blocks)
  depends_on    = [aws_eip.vpc_nat_gw_eip, aws_route_table_association.vpc_public_subnets_rt_associations]
  allocation_id = aws_eip.vpc_nat_gw_eip[count.index].id
  subnet_id     = element(aws_subnet.vpc_public_subnets[*].id, count.index)
  tags          = merge(var.vpc_nat_gateway_tags, { Name : "${var.project_name}_vpc_nat_gateway_${var.vpc_private_subnets_availability_zones[count.index]}_${random_string.resource_name_lower_case_suffix[count.index].id}" })
}

resource "aws_route_table" "vpc_private_rts" {
  count      = length(var.vpc_private_subnets_cidr_blocks)
  depends_on = [aws_nat_gateway.vpc_nat_gateway_instances]
  vpc_id     = aws_vpc.vpc_instance.id
  route {
    cidr_block = var.ipv4_cidr_block_to_all_ip_addresses
    gateway_id = element(aws_nat_gateway.vpc_nat_gateway_instances[*].id, count.index)
  }
  tags = merge(var.vpc_private_route_table_tags, { Name : format("%s%s%s", "${var.project_name}_", "vpc_private_rt_", "${var.vpc_private_subnets_availability_zones[count.index]}_${random_string.resource_name_lower_case_suffix[count.index].id}") })
}

resource "aws_route_table_association" "vpc_private_subnets_rt_associations" {
  count          = length(var.vpc_private_subnets_cidr_blocks)
  depends_on     = [aws_subnet.vpc_private_subnets, aws_route_table.vpc_private_rts]
  subnet_id      = element(aws_subnet.vpc_private_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.vpc_private_rts[*].id, count.index)
}

resource "aws_network_acl" "vpc_private_acls" {
  count      = length(var.vpc_private_subnets_cidr_blocks)
  depends_on = [aws_subnet.vpc_private_subnets]
  vpc_id     = aws_vpc.vpc_instance.id
  subnet_ids = [element(aws_subnet.vpc_private_subnets[*].id, count.index)]

  ingress {
    protocol   = "-1"
    rule_no    = 1
    action     = "allow"
    cidr_block = var.vpc_ipv4_cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "deny"
    cidr_block = var.ipv4_cidr_block_to_all_ip_addresses
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "deny"
    cidr_block = var.ipv4_cidr_block_to_all_ip_addresses
    from_port  = 3389
    to_port    = 3389
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = var.ipv4_cidr_block_to_all_ip_addresses
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_ipv4_cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 101
    action     = "allow"
    cidr_block = var.ipv4_cidr_block_to_all_ip_addresses
    from_port  = 0
    to_port    = 0
  }
  tags = merge(var.vpc_private_acl_tags, { Name : format("%s%s", "${var.project_name}_vpc_private_acl_", "${var.vpc_private_subnets_availability_zones[count.index]}_${random_string.resource_name_lower_case_suffix[count.index].id}") })
}
