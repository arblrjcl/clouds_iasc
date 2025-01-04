
/*module "bastion_instance" {
  source                             = "../../../modules/civo/instances/"
  project_name                       = local.common_tags.PROJECT_NAME
  instance_name                      = "${local.common_tags.PROJECT_NAME}_bastion"
  instance_tags                      = ["bastion_system"]
  instance_notes                     = "Bastion Instance Notes"
  instance_size                      = "g3.xsmall"
  ssh_public_key_file_name_with_path = "~/.ssh/id_ed25519.pub"
  volume_type                        = "csi-s3"
}*/

module "openvpn_instance" {
  source                             = "../../../modules/civo/instances/"
  project_name                       = local.common_tags.PROJECT_NAME
  instance_name                      = "${local.common_tags.PROJECT_NAME}_openvpn"
  instance_tags                      = ["openvpn_system"]
  instance_notes                     = "OpenVPN Instance Notes"
  instance_size                      = "g4s.xsmall"
  ssh_public_key_file_name_with_path = "~/.ssh/id_ed25519.pub"
  volume_type                        = "csi-s3"
}
