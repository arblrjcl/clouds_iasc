
output "eks_cluster_endpoint" {
  value = module.eks_instance.eks_cluster_endpoint
}

output "eks_cluster_id" {
  value = module.eks_instance.eks_cluster_id
}

/*output "eks_cluster_instance_details" {
  value = module.eks_instance.eks_cluster_instance_details
}*/

output "eks_cluster_openid_connect_identity_provider_url" {
  value = module.eks_instance.eks_cluster_openid_connect_identity_provider_url
}

output "eks_cluster_arn" {
  value = module.eks_instance.eks_cluster_arn
}

output "eks_cluster_openid_connect_provider_arn" {
  value = module.eks_instance.eks_cluster_openid_connect_provider_arn
}

output "eks_cluster_openid_connect_provider_url" {
  value = module.eks_instance.eks_cluster_openid_connect_provider_url
}
