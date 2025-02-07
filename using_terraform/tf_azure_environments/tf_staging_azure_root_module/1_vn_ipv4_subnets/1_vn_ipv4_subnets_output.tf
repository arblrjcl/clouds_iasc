
output "resource_group_id" {
  value = module.vn_ipv4.resource_group_id
}

output "resource_group_region" {
  value = module.vn_ipv4.resource_group_region
}

output "resource_group_name" {
  value = module.vn_ipv4.resource_group_name
}

output "az_ipv4_nw_private_subnets_ids" {
  value = module.vn_ipv4.az_ipv4_nw_private_subnets_ids
}

output "az_ipv4_nv_is_ids" {
  value = module.vn_ipv4.az_ipv4_nv_is_ids
}

/*output "az_ipv4_nw_private_subnets" {
  value = module.vn_ipv4.az_ipv4_nw_private_subnets
}*/

