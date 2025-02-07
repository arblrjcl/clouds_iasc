
output "k3s_cluster_instance_name" {
  value     = module.k3s_cluster_instance.k3s_cluster_name
  sensitive = true
}

output "k3s_cluster_master_node_ip" {
  value     = module.k3s_cluster_instance.k3s_cluster_master_node_ip
  sensitive = true
}

output "k3s_cluster_api_endpoint" {
  value     = module.k3s_cluster_instance.k3s_cluster_api_endpoint
  sensitive = true
}
