
resource "aws_route53_zone" "public_hosted_zone" {
  name = var.public_hosted_zone_name
  tags = var.public_hosted_zone_tags
}

resource "aws_route53_zone" "private_hosted_zone" {
  name = var.private_hosted_zone_name
  tags = var.private_hosted_zone_tags
  vpc {
    vpc_id = var.vpc_instance_id
  }
  depends_on = [aws_route53_zone.public_hosted_zone]
}

resource "aws_route53_record" "private_hosted_zone_delegation" {
  zone_id    = aws_route53_zone.public_hosted_zone.zone_id
  name       = var.private_hosted_zone_name
  type       = "NS"
  ttl        = "30"
  records    = aws_route53_zone.private_hosted_zone.name_servers
  depends_on = [aws_route53_zone.public_hosted_zone, aws_route53_zone.private_hosted_zone]
}
