
resource "aws_secretsmanager_secret" "example" {
  name = "example"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = jsonencode({ username = "example", password = "example" })
}

resource "aws_sagemaker_code_repository" "sagemaker_code_repository" {
  code_repository_name = format("%s%s", "${var.project_name}-", "sagemaker-code-repository")

  git_config {
    repository_url = "https://github.com/hashicorp/terraform-provider-aws.git"
    secret_arn     = aws_secretsmanager_secret.example.arn
  }
  tags       = merge({ "Name" : format("%s%s", "${var.project_name}", "sagemaker_code_repository") }, var.common_tags)
  depends_on = [aws_secretsmanager_secret_version.example]
}
