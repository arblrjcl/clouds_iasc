
module "twingate_setup" {
  source                           = "../../tf_modules/twingate/"
  twingate_api_token               = var.twingate_api_token
  twingate_network_or_account_name = var.twingate_network_or_account_name
  remotenetworkname                = format("%s%s", local.common_tags.PROJECT_NAME, "k3sclusterremotenw")
  twingate_group_name              = "Administrators"
  twingate_operator_logVerbosity   = "debug"
  twingate_operator_logFormat      = "plain"
  tf_twingate_provier_version      = var.tf_twingate_provier_version
}
