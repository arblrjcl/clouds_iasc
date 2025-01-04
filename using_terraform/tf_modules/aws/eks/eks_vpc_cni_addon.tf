
resource "aws_eks_addon" "eks_vpc_cni_addon" {
  cluster_name  = aws_eks_cluster.eks_cluster_instance.name
  addon_name    = "vpc-cni"
  addon_version = var.eks_addon_vpc_cni_version
  configuration_values = jsonencode(
    {
      # "CNI Configuration Variables" from https://github.com/aws/amazon-vpc-cni-k8s
      env = {
        ENABLE_PREFIX_DELEGATION          = "true" # check if the existing (/28) prefixes are enough to maintain the WARM_IP_TARGET
        WARM_ENI_TARGET                   = "1"    # keep "a full ENI" of available IPs around
        WARM_PREFIX_TARGET                = "1"
        POD_SECURITY_GROUP_ENFORCING_MODE = "standard" # traffic of pod with security group behaves same as pods without a security group,
        ENABLE_POD_ENI                    = "true"
        AWS_VPC_K8S_CNI_EXTERNALSNAT      = "true"
      }
      enableNetworkPolicy = "true"
    }
  )
}
