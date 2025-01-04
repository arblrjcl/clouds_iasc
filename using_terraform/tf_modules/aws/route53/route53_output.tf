
output "public_hosted_zone_arn" {
  value = aws_route53_zone.public_hosted_zone.arn
}

output "public_hosted_zone_id" {
  value = aws_route53_zone.public_hosted_zone.zone_id
}

output "public_hosted_zone_name_servers" {
  value = aws_route53_zone.public_hosted_zone.name_servers
}

output "private_hosted_zone_arn" {
  value = aws_route53_zone.private_hosted_zone.arn
}

output "private_hosted_zone_id" {
  value = aws_route53_zone.private_hosted_zone.zone_id
}

output "private_hosted_zone_name_servers" {
  value = aws_route53_zone.private_hosted_zone.name_servers
}
