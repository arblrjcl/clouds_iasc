
module "eks_instance" {
  source                              = "../../../../../tf_modules/aws/eks/"
  project_name                        = local.common_tags.PROJECT_NAME
  eks_iam_assume_role_tags            = merge(local.common_tags, { "TF_LAYER_NAME" : var.tf_layer_name })
  eks_kubernetes_version              = "1.30"
  eks_cluster_tags                    = merge(local.common_tags, { "TF_LAYER_NAME" : var.tf_layer_name })
  eks_workers_node_group_tags         = merge(local.common_tags, { "TF_LAYER_NAME" : var.tf_layer_name })
  eks_developer_group_access_tags     = merge(local.common_tags, { "TF_LAYER_NAME" : var.tf_layer_name })
  eks_cluster_endpoint_private_access = var.eks_cluster_endpoint_private_access
  # https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html#vpc-cni-latest-available-version
  eks_addon_vpc_cni_version = "v1.19.0-eksbuild.1"
  aws_config_profile_name   = var.aws_config_profile_name
}

data "aws_eks_cluster" "eks_cluster_details" {
  name       = "${local.common_tags.PROJECT_NAME}_eks_cluster"
  depends_on = [module.eks_instance]
}

provider "helm" {
  kubernetes {
    host                   = yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).clusters.0.cluster.server
    client_certificate     = base64decode(yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).users.0.user.client-certificate-data)
    client_key             = base64decode(yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).users.0.user.client-key-data)
    cluster_ca_certificate = base64decode(yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).clusters.0.cluster.certificate-authority-data)
  }
}

provider "kubernetes" {
  host                   = yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).clusters.0.cluster.server
  client_certificate     = base64decode(yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).users.0.user.client-certificate-data)
  client_key             = base64decode(yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).users.0.user.client-key-data)
  cluster_ca_certificate = base64decode(yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).clusters.0.cluster.certificate-authority-data)
}

provider "kubectl" {
  host                   = yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).clusters.0.cluster.server
  client_certificate     = base64decode(yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).users.0.user.client-certificate-data)
  client_key             = base64decode(yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).users.0.user.client-key-data)
  cluster_ca_certificate = base64decode(yamldecode(data.aws_eks_cluster.eks_cluster_details.kubeconfig).clusters.0.cluster.certificate-authority-data)
  load_config_file       = false
}

data "aws_iam_policy_document" "s3_bucket_contents_read_iam_policy_document" {
  statement {
    sid    = "S3BucketsContentsReadOnly"
    effect = "Allow"

    actions   = ["s3:GetObject"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "s3_bucket_contents_read_iam_policy" {
  name   = "${local.common_tags.PROJECT_NAME}_s3_bucket_contents_read_iam_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.s3_bucket_contents_read_iam_policy_document.json
  tags   = merge(local.common_tags, { "TF_LAYER_NAME" : var.tf_layer_name, "Name" : "${local.common_tags.PROJECT_NAME}_s3_bucket_contents_read_iam_policy" })
}

data "aws_iam_policy_document" "s3_bucket_contents_read_iam_role_trust_policy_document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks_instance.eks_cluster_openid_connect_provider_url, "https://", "")}:sub"
      values   = ["system:serviceacccount:default:app"]
    }
    principals {
      identifiers = [module.eks_instance.eks_cluster_openid_connect_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "s3_bucket_contents_read_iam_role" {
  name               = "${local.common_tags.PROJECT_NAME}_s3_bucket_contents_read_iam_role"
  assume_role_policy = data.aws_iam_policy_document.s3_bucket_contents_read_iam_role_trust_policy_document.json
}

resource "aws_iam_role_policy_attachment" "s3_bucket_contents_read_iam_role_policy_attachment" {
  policy_arn = aws_iam_policy.s3_bucket_contents_read_iam_policy.arn
  role       = aws_iam_role.s3_bucket_contents_read_iam_role.name
}

resource "aws_s3_bucket" "some_test_bucket" {
  bucket = "${local.common_tags.PROJECT_NAME}-some-test-bucket"
  tags   = merge(local.common_tags, { "TF_LAYER_NAME" : var.tf_layer_name, "Name" : "${local.common_tags.PROJECT_NAME}_same_test_bucket" })
}

