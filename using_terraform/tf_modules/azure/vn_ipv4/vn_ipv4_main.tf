
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
  name                 = format("%s%s", "${var.project_name}-vn-private-subnet-", tostring(count.index))
  resource_group_name  = data.azurerm_resource_group.az_resource_group.name
  virtual_network_name = resource.azurerm_virtual_network.az_ipv4_vn.name
  address_prefixes     = [var.vn_private_subnets_cidr_blocks[count.index]]
  depends_on           = [resource.azurerm_virtual_network.az_ipv4_vn]
}

resource "azurerm_network_interface" "az_ipv4_nv_is" {
  count               = length(var.vn_private_subnets_cidr_blocks)
  name                = format("%s%s%s", "${var.project_name}-vn-private-subnet-", tostring(count.index), "-nic")
  location            = data.azurerm_resource_group.az_resource_group.location
  resource_group_name = data.azurerm_resource_group.az_resource_group.name
  tags                = merge({ "Name" : format("%s%s%s", "${var.project_name}-vn-private-subnet-", tostring(count.index), "-nic") }, var.vn_tags)

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = resource.azurerm_subnet.az_ipv4_nw_private_subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}
