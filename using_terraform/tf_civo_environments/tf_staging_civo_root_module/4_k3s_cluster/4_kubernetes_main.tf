
module "k3s_cluster_instance" {
  source                   = "../../../tf_modules/civo/kubernetes/"
  project_name             = local.common_tags.PROJECT_NAME
  tf_civo_provider_version = var.tf_civo_provider_version
  applications             = var.apps_to_be_installed_from_k8s_cluster
  cidr_v4                  = var.cidr_v4
  node_count               = 2
  node_size                = "g4s.kube.medium" # "g4s.kube.large" "g4s.kube.xsmall" "g4s.kube.medium"
}
