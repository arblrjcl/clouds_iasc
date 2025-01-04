
output "supported_availability_zones" {
  value = local.supported_available_zones
}

output "vpc_instance_name" {
  value = module.vpc_ipv4_network_instance.vpc_instance_name
}

output "vpc_instance_id" {
  value = module.vpc_ipv4_network_instance.vpc_instance_id
}

output "vpc_instance_arn" {
  value = module.vpc_ipv4_network_instance.vpc_instance_arn
}

output "vpc_instance_main_route_table_id" {
  value = module.vpc_ipv4_network_instance.vpc_instance_main_route_table_id
}

output "vpc_instance_owner_id" {
  value = module.vpc_ipv4_network_instance.vpc_instance_owner_id
}

output "vpc_instance_default_route_table_id" {
  value = module.vpc_ipv4_network_instance.vpc_instance_default_route_table_id
}

output "vpc_instance_default_network_acl_id" {
  value = module.vpc_ipv4_network_instance.vpc_instance_default_network_acl_id
}

output "vpc_instance_tenancy" {
  value = module.vpc_ipv4_network_instance.vpc_instance_tenancy
}

output "vpc_igw_instance_name" {
  value = module.vpc_ipv4_network_instance.vpc_igw_instance_name
}

output "vpc_igw_instance_id" {
  value = module.vpc_ipv4_network_instance.vpc_igw_instance_id
}

output "vpc_nat_gw_instances_ids" {
  value = module.vpc_ipv4_network_instance.vpc_nat_gw_instances_ids
}

output "vpc_eips_with_nat_gw_instances" {
  value = module.vpc_ipv4_network_instance.eips_with_nat_gw_instances
}

output "vpc_public_subnets_ids" {
  value = module.vpc_ipv4_network_instance.vpc_public_subnets_ids
}

output "vpc_public_subnets_names" {
  value = module.vpc_ipv4_network_instance.vpc_public_subnets_names
}

output "vpc_private_subnets_ids" {
  value = module.vpc_ipv4_network_instance.vpc_private_subnets_ids
}

output "vpc_private_subnets_names" {
  value = module.vpc_ipv4_network_instance.vpc_private_subnets_names
}
