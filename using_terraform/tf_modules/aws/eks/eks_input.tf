
variable "project_name" {
  type = string
}

variable "eks_iam_assume_role_tags" {
  type = map(string)
}

variable "eks_kubernetes_version" {
  type = string
}

variable "eks_cluster_tags" {
  type = map(string)
}

variable "eks_cluster_control_plane_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  description = "More details: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html"
}

variable "eks_workers_node_group_tags" {
  type = map(string)
}

# https://aws.amazon.com/ec2/instance-types/
variable "eks_workers_general_node_group_ec2_instance_types" {
  type    = list(string)
  default = ["t2.micro", "t3.micro"]
}

variable "eks_workers_cpu_optimized_node_group_ec2_instance_types" {
  type    = list(string)
  default = ["c7g.xlarge", "c7g.4xlarge"]
}

variable "eks_workers_memory_optimized_node_group_ec2_instance_types" {
  type    = list(string)
  default = ["r8g.12xlarge", "r8g.24xlarge"]
}

variable "eks_workers_GPU_optimized_node_group_ec2_instance_types" {
  type    = list(string)
  default = ["g4dn.12xlarge", "g4ad.2xlarge"]
}

variable "eks_workers_storage_optimized_node_group_ec2_instance_types" {
  type    = list(string)
  default = ["i4g.4xlarge", "i4g.16xlarge"]
}

# High Performance Computing
variable "eks_workers_HPC_optimized_node_group_ec2_instance_types" {
  type    = list(string)
  default = ["hpc7g.16xlarge", "hpc7a.24xlarge"]
}

variable "eks_developer_group_access_tags" {
  type = map(string)
}

variable "eks_cluster_endpoint_private_access" {
  type = bool
}

# Specify a block that does not overlap with resources in other networks that are peered or connected to your VPC.
# More details: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster.html
variable "eks_cluster_service_ipv4_cidr" {
  type    = string
  default = "172.20.0.0/16"
}

variable "eks_addon_vpc_cni_version" {
  type = string
}

variable "eks_addon_details" {
  type = map(map(string))
}

variable "aws_config_profile_name" {
  type = string
}

