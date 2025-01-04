
resource "aws_route53_zone" "public_hosted_zone" {
  name = var.public_hosted_zone_name
  tags = var.public_hosted_zone_tags
}

resource "aws_route53_zone" "environment_specific_public_hosted_zone" {
  name       = "${var.project_environment_name}.${var.public_hosted_zone_name}"
  tags       = var.public_hosted_zone_tags
  depends_on = [aws_route53_zone.public_hosted_zone]
}

resource "aws_route53_record" "public_hosted_zone_delegation" {
  zone_id    = aws_route53_zone.public_hosted_zone.zone_id
  name       = "${var.project_environment_name}.${var.public_hosted_zone_name}"
  type       = "NS"
  ttl        = "30"
  records    = aws_route53_zone.environment_specific_public_hosted_zone.name_servers
  depends_on = [resource.aws_route53_zone.environment_specific_public_hosted_zone]
}

data "aws_subnets" "vpc_private_subnets" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0afef6dfc37c3dff0"]
  }

  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }
}

resource "aws_route53_zone" "private_hosted_zone" {
  #count = length(data.aws_subnets.vpc_private_subnets.ids) >= 0 ? 1 : 0
  name = var.private_hosted_zone_name
  tags = var.private_hosted_zone_tags
  vpc {
    vpc_id = var.vpc_instance_id
  }
}

/*resource "aws_route53_zone" "environment_specific_private_hosted_zone" {
  name = "${var.project_environment_name}.${var.private_hosted_zone_name}"
  tags = var.private_hosted_zone_tags
  vpc {
    vpc_id = var.vpc_instance_id
  }
  depends_on = [aws_route53_zone.private_hosted_zone]
}

resource "aws_route53_record" "private_hosted_zone_delegation" {
  zone_id    = aws_route53_zone.private_hosted_zone.zone_id
  name       = "${var.project_environment_name}.${var.private_hosted_zone_name}"
  type       = "NS"
  ttl        = "30"
  records    = aws_route53_zone.environment_specific_private_hosted_zone.name_servers
  depends_on = [aws_route53_zone.environment_specific_private_hosted_zone]
}
*/