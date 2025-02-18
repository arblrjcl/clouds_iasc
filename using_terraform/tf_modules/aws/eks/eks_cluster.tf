
data "aws_vpc" "vpc_instance" {
  state = "available"
  filter {
    name   = "tag:Name"
    values = [format("%s%s", var.project_name, "_vpc")]
  }
}

data "aws_subnets" "vpc_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_instance.id]
  }

  tags = {
    Tier = "Private"
  }
}

data "aws_subnets" "vpc_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_instance.id]
  }

  tags = {
    Tier = "Public"
  }
}

# AWS EKS instance requires an IAM role to access AWS API on our behalf to create required K8S resources
resource "aws_iam_role" "eks_iam_assume_role" {
  name               = "${var.project_name}_eks_cluster_iam_assume_role"
  description        = "AWS EKS service uses this IAM role to create required AWS resources on our behalf for Kubernetes cluster[s]."
  assume_role_policy = file("${path.module}/eks-cluster-role-trust-policy.json")
  tags               = merge(var.eks_iam_assume_role_tags, { Name : "${var.project_name}_eks_iam_assume_role" })
}

# IAM policy to be attached to above mentioned IAM assume role
resource "aws_iam_role_policy_attachment" "eks_iam_role_policy_attachment" {
  role = aws_iam_role.eks_iam_assume_role.name

  # https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKSClusterPolicy
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  depends_on = [aws_iam_role.eks_iam_assume_role]
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks_cluster_VPC_ResourceController_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_iam_assume_role.name
  depends_on = [aws_iam_role.eks_iam_assume_role]
}

# Reference: https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
resource "aws_eks_cluster" "eks_cluster_instance" {
  name     = "${var.project_name}_eks_cluster"
  role_arn = aws_iam_role.eks_iam_assume_role.arn
  version  = var.eks_kubernetes_version

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_iam_role_policy_attachment,
    aws_iam_role_policy_attachment.eks_cluster_VPC_ResourceController_policy_attachment,
  ]
  vpc_config {
    endpoint_private_access = var.eks_cluster_endpoint_private_access ? true : false
    endpoint_public_access  = var.eks_cluster_endpoint_private_access ? false : true
    // Subnets to worker nodes
    subnet_ids = var.eks_cluster_endpoint_private_access ? data.aws_subnets.vpc_private_subnets.ids : data.aws_subnets.vpc_public_subnets.ids
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.eks_cluster_service_ipv4_cidr
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags                      = merge(var.eks_cluster_tags, { Name : "${var.project_name}_eks_cluster" })
  enabled_cluster_log_types = var.eks_cluster_control_plane_log_types
}

# AWS IAM role for K8S worker nodes managed by "Auto Scaling Group", not for nodes managed by Karpenter
resource "aws_iam_role" "eks_worker_nodes_iam_role" {
  name               = "${var.project_name}_eks_worker_nodes_iam_role"
  description        = "Worker nodes use this IAM role"
  tags               = merge(var.eks_iam_assume_role_tags, { Name : "${var.project_name}_eks_worker_nodes_iam_role" })
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_worker_nodes_policy_attachment" {
  role = aws_iam_role.eks_worker_nodes_iam_role.name

  # https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSWorkerNodePolicy.html
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# To manage secondary IPs for the pods
resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  role = aws_iam_role.eks_worker_nodes_iam_role.name

  # https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKS_CNI_Policy.html
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# To get READ ONLY access to AWS ECR private container image repositories to download required container image
resource "aws_iam_role_policy_attachment" "ecr_repositories_ro_access_policy_attachment" {
  role = aws_iam_role.eks_worker_nodes_iam_role.name

  # https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEC2ContainerRegistryReadOnly.html
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Get latest optimized AL2023 AMI for the given EKS version
data "aws_ssm_parameter" "eks_ami_release_version" {
  #name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_cluster_instance.version}/amazon-linux-2/recommended/release_version"
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_cluster_instance.version}/amazon-linux-2023/x86_64/standard/recommended/release_version"
}

# https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/eks_node_group#labels-1
# EKS managed node group created as an AWS autoscaling group [Worker nodes managed as an EC2 Auto Scaling group.]
# Karpenter doesn't use node autoscaling groups. Create required EC2 instances or nodes directly.
resource "aws_eks_node_group" "eks_cluster_workers_general_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster_instance.name
  node_group_name = "${var.project_name}_eks_cluster_workers_general_node_group"
  node_role_arn   = aws_iam_role.eks_worker_nodes_iam_role.arn
  // Subnets to worker nodes
  subnet_ids      = var.eks_cluster_endpoint_private_access ? data.aws_subnets.vpc_private_subnets.ids : data.aws_subnets.vpc_public_subnets.ids
  version         = var.eks_kubernetes_version
  tags            = merge(var.eks_workers_node_group_tags, { Name : "${var.project_name}_eks_workers_general_node_group" })
  capacity_type   = "ON_DEMAND"
  instance_types  = var.eks_workers_general_node_group_ec2_instance_types
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
  ami_type        = "AL2023_x86_64_STANDARD"
  disk_size       = 20 # Default is 20GiB to node groups except for Windows. For Windows default is 50GiB
  # Cluster autoscaler configuration
  scaling_config {
    desired_size = 1
    max_size     = 10
    min_size     = 1
  }

  # To be used for EKS cluster upgrades
  update_config {
    max_unavailable = 1
  }

  # To be used for pods affinity and node selectors.
  labels = {
    role = "general"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_eks_cluster.eks_cluster_instance,
    aws_iam_role_policy_attachment.eks_cluster_worker_nodes_policy_attachment,
    aws_iam_role_policy_attachment.eks_cni_policy_attachment,
    aws_iam_role_policy_attachment.ecr_repositories_ro_access_policy_attachment,
  ]

  // Optional: Allow external changes without Terraform plan difference
  /* Terraform resources also allow you to ignore certain attributes of the objects we are trying to create.
     For example, when we deploy the cluster autoscaler, it will manage the desired size property of the auto-scaling
     group, which will conflict with the Terraform state. So the solution is to ignore the desired size attribute after
     creating it. */
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

resource "aws_iam_openid_connect_provider" "eks_cluster_openid_connect_provider" {
  url = aws_eks_cluster.eks_cluster_instance.identity[0]["oidc"][0]["issuer"]

  client_id_list = [
    "sts.amazonaws.com",
  ]
  tags       = merge(var.eks_iam_assume_role_tags, { Name : "${var.project_name}_eks_iam_openid_connect_provider" })
  depends_on = [aws_eks_node_group.eks_cluster_workers_general_node_group]
}

data "aws_region" "current" {}

resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = format("%s%s%s%s%s", "aws eks update-kubeconfig --name ", "${var.project_name}_eks_cluster", " --region ", "${data.aws_region.current.name} --profile ", "${var.aws_config_profile_name}")
  }
  depends_on = [resource.aws_eks_node_group.eks_cluster_workers_general_node_group]
}
