
resource "azurerm_resource_group" "az_resource_group" {
  name     = "${var.project_environment_name}-${var.project_name}-rg"
  location = var.azure_region
  tags     = merge({ "Name" : "${var.project_environment_name}-${var.project_name}-rg" }, local.common_tags)
}

module "vn_ipv4" {
  source                         = "../../../tf_modules/azure/vn_ipv4/"
  project_name                   = local.common_tags.PROJECT_NAME
  vn_ipv4_cidr_block             = local.vn_ipv4_cidr_block
  vn_tags                        = local.common_tags
  vn_public_subnets_cidr_blocks  = local.public_network_ipv4_cidr_blocks
  vn_private_subnets_cidr_blocks = local.private_network_ipv4_cidr_blocks
  depends_on                     = [resource.azurerm_resource_group.az_resource_group]
}
