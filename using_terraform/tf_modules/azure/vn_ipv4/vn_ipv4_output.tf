
output "resource_group_id" {
  value = data.azurerm_resource_group.az_resource_group.id
}

output "resource_group_region" {
  value = data.azurerm_resource_group.az_resource_group.location
}

output "resource_group_name" {
  value = data.azurerm_resource_group.az_resource_group.name
}

