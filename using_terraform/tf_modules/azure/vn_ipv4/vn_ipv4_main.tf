
data "azurerm_resource_group" "az_resource_group" {
  name = "${var.project_name}-rg"
}

resource "azurerm_virtual_network" "az_ipv4_vn" {
  name                = "${var.project_name}-vn"
  address_space       = [var.vn_ipv4_cidr_block]
  location            = data.azurerm_resource_group.az_resource_group.location
  resource_group_name = data.azurerm_resource_group.az_resource_group.name
  tags                = merge({ "Name" : "${var.project_name}-vn" }, var.vn_tags)
  depends_on          = [data.azurerm_resource_group.az_resource_group]
}

resource "azurerm_subnet" "az_ipv4_nw_private_subnets" {
  count                = length(var.vn_private_subnets_cidr_blocks)
  name                 = "${var.project_name}-vn-private-subnet"
  resource_group_name  = data.azurerm_resource_group.az_resource_group.name
  virtual_network_name = resource.azurerm_virtual_network.az_ipv4_vn.name
  address_prefixes     = [count.index]
  depends_on           = [resource.azurerm_virtual_network.az_ipv4_vn]
}
