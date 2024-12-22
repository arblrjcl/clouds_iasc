
# Output the generated random strings
output "random_strings" {
  description = "The generated random strings"
  value       = random_string.resource_name_lower_case_suffix[*].result
}

output "vpc_instance_name" {
  value = aws_vpc.vpc_instance.tags.Name
}

output "vpc_instance_id" {
  value = aws_vpc.vpc_instance.id
}

output "vpc_instance_arn" {
  value = aws_vpc.vpc_instance.arn
}

output "vpc_instance_main_route_table_id" {
  value = aws_vpc.vpc_instance.main_route_table_id
}

output "vpc_instance_owner_id" {
  value = aws_vpc.vpc_instance.owner_id
}

output "vpc_instance_default_route_table_id" {
  value = aws_vpc.vpc_instance.default_route_table_id
}

output "vpc_instance_default_network_acl_id" {
  value = aws_vpc.vpc_instance.default_network_acl_id
}

output "vpc_instance_tenancy" {
  value = aws_vpc.vpc_instance.instance_tenancy
}

output "vpc_igw_instance_name" {
  value = aws_internet_gateway.vpc_igw_instance.tags.Name
}

output "vpc_igw_instance_id" {
  value = aws_internet_gateway.vpc_igw_instance.id
}

output "vpc_nat_gw_instances_ids" {
  value = aws_nat_gateway.vpc_nat_gateway_instances[*].id
}

output "eips_with_nat_gw_instances" {
  value = aws_eip.vpc_nat_gw_eip[*].public_ip
}

output "vpc_public_subnets_ids" {
  value = aws_subnet.vpc_public_subnets[*].id
}

output "vpc_public_subnets_names" {
  value = aws_subnet.vpc_public_subnets[*].tags.Name
}

output "vpc_private_subnets_ids" {
  value = aws_subnet.vpc_private_subnets[*].id
}

output "vpc_private_subnets_names" {
  value = aws_subnet.vpc_private_subnets[*].tags.Name
}

output "vpc_private_acls_ids" {
  value = aws_network_acl.vpc_private_acls[*].id
}

output "vpc_private_acls_names" {
  value = aws_network_acl.vpc_private_acls[*].tags.Name
}

output "vpc_public_acls_ids" {
  value = aws_network_acl.vpc_public_acls[*].id
}

output "vpc_public_acls_names" {
  value = aws_network_acl.vpc_public_acls[*].tags.Name
}

output "vpc_public_rts_ids" {
  value = aws_route_table.vpc_public_rts[*].id
}

output "vpc_private_rts_ids" {
  value = aws_route_table.vpc_private_rts[*].id
}

output "vpc_private_rts_names" {
  value = aws_route_table.vpc_private_rts[*].tags.Name
}

output "vpc_public_rts_names" {
  value = aws_route_table.vpc_public_rts[*].tags.Name
}
