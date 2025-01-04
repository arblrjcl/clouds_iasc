
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
  network_id   = data.civo_network.project_civo_private_network.id
  firewall_id  = data.civo_firewall.project_civo_network_firewall.id
  pools {
    size       = var.node_size
    node_count = var.node_count
  }
  depends_on = [data.civo_firewall.project_civo_network_firewall]
}

data "civo_kubernetes_cluster" "civo_k3s_cluster_details" {
  name       = "${var.project_name}-k3s-cluster"
  depends_on = [resource.civo_kubernetes_cluster.civo_k3s_cluster]
}

resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = format("%s%s%s", "civo kubernetes config ", data.civo_kubernetes_cluster.civo_k3s_cluster_details.name, " --save")
  }
}
