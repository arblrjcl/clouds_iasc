
module "ipv4_private_network" {
  source                   = "../../../../using_terraform/tf_modules/civo/ipv4_network/"
  project_name             = local.common_tags.PROJECT_NAME
  tf_civo_provider_version = var.tf_civo_provider_version
  cidr_v4                  = var.cidr_v4
  domain_name              = var.public_hosted_zone_name
  custom_v4_nameservers    = var.google_v4_nameservers
  default_network_instance = false
}

/*module "ipv4_default_network_instance" {
  source                   = "../../../../using_terraform/tf_modules/civo/ipv4_network/"
  project_name             = local.common_tags.PROJECT_NAME
  tf_civo_provider_version = var.tf_civo_provider_version
  domain_name       = var.public_hosted_zone_name
  custom_v4_nameservers    = var.google_v4_nameservers
  default_network_instance = true
}*/
