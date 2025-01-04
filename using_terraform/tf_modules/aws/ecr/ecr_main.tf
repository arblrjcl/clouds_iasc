
resource "aws_ecr_repository" "ecr_repository" {
  name                 = "${var.project_name}-ecr-repository"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

