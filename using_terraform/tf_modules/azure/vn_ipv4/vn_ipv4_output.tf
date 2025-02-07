
output "resource_group_id" {
  value = data.azurerm_resource_group.az_resource_group.id
}

output "resource_group_region" {
  value = data.azurerm_resource_group.az_resource_group.location
}

output "resource_group_name" {
  value = data.azurerm_resource_group.az_resource_group.name
}

output "az_ipv4_nw_private_subnets_ids" {
  value = azurerm_subnet.az_ipv4_nw_private_subnets[*].id
}

output "az_ipv4_nv_is_ids" {
  value = azurerm_network_interface.az_ipv4_nv_is[*].id
}

output "az_ipv4_nw_private_subnets" {
  value = azurerm_subnet.az_ipv4_nw_private_subnets
}


