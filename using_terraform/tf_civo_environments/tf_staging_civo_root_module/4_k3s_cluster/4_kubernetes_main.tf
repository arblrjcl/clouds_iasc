
module "k3s_cluster_instance" {
  source                   = "../../../tf_modules/civo/kubernetes/"
  project_name             = local.common_tags.PROJECT_NAME
  tf_civo_provider_version = var.tf_civo_provider_version
  applications             = var.apps_to_be_installed_from_k8s_cluster
  cidr_v4                  = var.cidr_v4
  node_count               = 4
  # Standard g4s.kube.xsmall    1 CPU Core,   1GB RAM, 30GB NVMe Storage
  # Standard g4s.kube.small     1 CPU Core,   2GB RAM, 40GB NVMe Storage
  # Standard g4s.kube.medium    2 CPU Cores,  4GB RAM, 50GB NVMe Storage
  # Standard g4s.kube.large     4 CPU Cores,  8GB RAM, 60GB NVMe Storage
  # Performance g4p.kube.small  4 CPU Cores, 16GB RAM, 60GB NVMe Storage
  node_size    = "g4s.kube.medium"
  cluster_type = "k3s"     # Default is K3S. Other supported type is  "talos"  TALOS LINUX
  cni_name     = "flannel" # Default is flannel and other supported cni is "cilium"
}
