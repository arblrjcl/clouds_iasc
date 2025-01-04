
resource "aws_iam_group" "iam_groups" {
  for_each = toset(var.iam_group_names)
  name     = format("%s%s", "${var.project_name}_iam_group_", each.value)
  path     = "/users/"
}

/*data "aws_iam_group" "iam_admins_group_name" {
  group_name = var.iam_admins_group_name
  depends_on = [resource.aws_iam_group.iam_groups]
}

resource "aws_iam_group_policy" "admin_group_iam_policy" {
  name  = "${var.project_name}_admin_group_iam_policy"
  group = var.iam_admins_group_name #data.aws_iam_group.iam_admins_group_name.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
*/
