
# To get AWS account number from current user caller identity
data "aws_caller_identity" "current_iam_user" {}

# IAM Role that would get admin privileges inside the K8S cluster.
resource "aws_iam_role" "eks_cluster_admin_access_iam_role" {
  name = "${var.project_name}_eks_cluster_admin_access_iam_role"
  tags = merge(var.eks_iam_assume_role_tags, { Name : "${var.project_name}_eks_cluster_admin_iam_role" })

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current_iam_user.account_id}:root"
      }
    }
  ]
}
POLICY

  depends_on = [aws_eks_node_group.eks_cluster_workers_general_node_group]
}

# IAM Policy with admin access inside AWS account 
resource "aws_iam_policy" "eks_cluster_admin_access_iam_policy" {
  name = "${var.project_name}_eks_cluster_admin_access_iam_policy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_admin_role_policy_attachment" {
  role       = aws_iam_role.eks_cluster_admin_access_iam_role.name
  policy_arn = aws_iam_policy.eks_cluster_admin_access_iam_policy.arn
}

# IAM User who assumes above mentioned IAM admin role
resource "aws_iam_user" "eks_admin_access_iam_user" {
  name = "admin_manager"
}

# IAM Policy assuming above mentioned IAM admin role
resource "aws_iam_policy" "eks_cluster_admin_to_assumt_admin_role_policy" {
  name = "${var.project_name}_eks_cluster_admin_to_assumt_admin_role_policy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "${aws_iam_role.eks_cluster_admin_access_iam_role.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_user_policy_attachment" "manager" {
  user       = aws_iam_user.eks_admin_access_iam_user.name
  policy_arn = aws_iam_policy.eks_cluster_admin_to_assumt_admin_role_policy.arn
}

# Best practice: use IAM roles due to temporary credentials
resource "aws_eks_access_entry" "manager" {
  cluster_name      = aws_eks_cluster.eks_cluster_instance.name
  principal_arn     = aws_iam_role.eks_cluster_admin_access_iam_role.arn
  kubernetes_groups = ["my-admin"] # K8S RABC Group Name
}
