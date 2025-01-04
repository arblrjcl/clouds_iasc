
output "supported_availability_zones" {
  value = local.supported_available_zones
}

###########################################################
output "public_hosted_zone_arn" {
  value = module.route53_hosted_zones.public_hosted_zone_arn
}

output "public_hosted_zone_id" {
  value = module.route53_hosted_zones.public_hosted_zone_id
}

output "public_hosted_zone_name_servers" {
  value = module.route53_hosted_zones.public_hosted_zone_name_servers
}

output "private_hosted_zone_arn" {
  value = module.route53_hosted_zones.private_hosted_zone_arn
}

output "private_hosted_zone_id" {
  value = module.route53_hosted_zones.private_hosted_zone_id
}

output "private_hosted_zone_name_servers" {
  value = module.route53_hosted_zones.private_hosted_zone_name_servers
}
