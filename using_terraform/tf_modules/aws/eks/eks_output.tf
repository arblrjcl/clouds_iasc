
output "eks_cluster_name_from_tags" {
  value = aws_eks_cluster.eks_cluster_instance.tags.Name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster_instance.endpoint
}

output "eks_cluster_kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks_cluster_instance.certificate_authority[0].data
}

output "eks_cluster_security_group_id" {
  value = aws_eks_cluster.eks_cluster_instance.vpc_config[0].cluster_security_group_id
}

output "vpc_id_with_eks_cluster" {
  value = aws_eks_cluster.eks_cluster_instance.vpc_config[0].vpc_id
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks_cluster_instance.cluster_id
}

output "eks_cluster_name_from_id" {
  value = aws_eks_cluster.eks_cluster_instance.id
}

output "eks_cluster_identity_provider_info" {
  value = aws_eks_cluster.eks_cluster_instance.identity
}

output "eks_cluster_platform_version" {
  value = aws_eks_cluster.eks_cluster_instance.platform_version
}

output "eks_cluster_status" {
  value = aws_eks_cluster.eks_cluster_instance.status
}

output "eks_cluster_openid_connect_identity_provider_url" {
  value = aws_eks_cluster.eks_cluster_instance.identity[0]["oidc"][0]["issuer"]
}

output "eks_cluster_openid_connect_identity_provider_info" {
  value = aws_eks_cluster.eks_cluster_instance.identity[0]["oidc"]
}

output "eks_cluster_instance_details" {
  value = aws_eks_cluster.eks_cluster_instance
}

output "eks_cluster_vpc_id" {
  value = data.aws_vpc.vpc_instance.id
}

output "eks_cluster_vpc_private_subnets_ids" {
  value = data.aws_subnets.vpc_private_subnets.ids
}

output "eks_cluster_vpc_public_subnets_ids" {
  value = data.aws_subnets.vpc_public_subnets.ids
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks_cluster_instance.arn
}

output "eks_cluster_openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.eks_cluster_openid_connect_provider.arn
}

output "eks_cluster_openid_connect_provider_url" {
  value = aws_iam_openid_connect_provider.eks_cluster_openid_connect_provider.url
}

