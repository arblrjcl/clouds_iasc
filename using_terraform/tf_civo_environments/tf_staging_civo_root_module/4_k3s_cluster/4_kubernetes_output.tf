
output "k3s_cluster_instance_name" {
  value = module.k3s_cluster_instance.k3s_cluster_name
}

output "k3s_cluster_master_node_ip" {
  value = module.k3s_cluster_instance.k3s_cluster_master_node_ip
}

output "k3s_cluster_api_endpoint" {
  value = module.k3s_cluster_instance.k3s_cluster_api_endpoint
}
