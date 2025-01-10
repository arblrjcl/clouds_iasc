
output "k3s_cluster_name" {
  value       = civo_kubernetes_cluster.civo_k3s_cluster.name
  description = "The randomly generated name for this cluster ??"
}

output "k3s_cluster_master_node_ip" {
  value = civo_kubernetes_cluster.civo_k3s_cluster.master_ip
}

output "k3s_cluster_api_endpoint" {
  value = civo_kubernetes_cluster.civo_k3s_cluster.api_endpoint
}
