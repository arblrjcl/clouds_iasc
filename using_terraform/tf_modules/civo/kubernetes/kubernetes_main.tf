
data "civo_network" "project_civo_private_network" {
  label = "${var.project_name}-private-network"
  //cidr_v4 = var.cidr_v4
  //region = "LON1"
}

data "civo_firewall" "project_civo_network_firewall" {
  //network_id = data.civo_network.project_civo_network.id
  name = "${var.project_name}-network-firewall"
}

resource "civo_kubernetes_cluster" "civo_k3s_cluster" {
  name         = "${var.project_name}-k3s-cluster"
  applications = var.applications
  cluster_type = var.cluster_type
  cni          = var.cni_name
  network_id   = data.civo_network.project_civo_private_network.id
  firewall_id  = data.civo_firewall.project_civo_network_firewall.id
  pools {
    size       = var.node_size
    node_count = var.node_count
  }
  depends_on = [data.civo_firewall.project_civo_network_firewall]
}

