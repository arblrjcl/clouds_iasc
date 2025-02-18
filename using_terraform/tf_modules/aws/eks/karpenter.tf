
# https://www.youtube.com/watch?v=C_YZXpXwtbg
# Kubernetes Node Autoscaling with Karpenter (AWS EKS & Terraform)

# Trust policy to allow the "K8S SA" to assume the IAM role with a condition that Karpenter to the "karpenter - K8S namespace" and "karpenter - K8S SA name"  
data "aws_iam_policy_document" "karpenter_controller_iam_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster_openid_connect_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter"]
    }
    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_cluster_openid_connect_provider.arn]
      type        = "Federated"
    }
  }
  depends_on = [aws_iam_openid_connect_provider.eks_cluster_openid_connect_provider]
}

resource "aws_iam_role" "karpenter_controller_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.karpenter_controller_iam_assume_role_policy.json
  name               = "${var.project_name}_eks_karpenter_controller_iam_role"
  depends_on         = [data.aws_iam_policy_document.karpenter_controller_iam_assume_role_policy]
}

# Permissions to Karpenter to manage K8S nodes.
resource "aws_iam_policy" "karpenter_controller_iam_policy" {
  policy = file("${path.module}/karpenter-controller-trust-policy.json")
  name   = "${var.project_name}_eks_karpenter_controller_iam_policy"
}

resource "aws_iam_role_policy_attachment" "karpenter_iam_policy_attachment_to_iam_role" {
  role       = aws_iam_role.karpenter_controller_iam_role.name
  policy_arn = aws_iam_policy.karpenter_controller_iam_policy.arn
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "${var.project_name}_Karpenter_Nodes_Instance_Profile"
  role = aws_iam_role.eks_worker_nodes_iam_role.name
}

data "aws_eks_cluster" "eks_cluster_details" {
  name       = "${var.project_name}_eks_cluster"
  depends_on = [aws_iam_role_policy_attachment.karpenter_iam_policy_attachment_to_iam_role, aws_iam_instance_profile.karpenter]
}
