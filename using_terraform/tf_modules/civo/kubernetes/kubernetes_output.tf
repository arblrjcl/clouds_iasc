
output "k8s_cluster_name" {
  value       = civo_kubernetes_cluster.civo_k3s_cluster.name
  description = "The randomly generated name for this cluster ??"
}
