
data "aws_vpc" "vpc_instance" {
  cidr_block = local.vpc_ipv4_cidr_block
}

module "route53_hosted_zones" {
  source                   = "../../../tf_modules/aws/route53/"
  project_environment_name = var.project_environment_name
  public_hosted_zone_name  = var.public_hosted_zone_name
  private_hosted_zone_name = var.private_hosted_zone_name
  public_hosted_zone_tags  = merge(local.common_tags, { Name : "${var.public_hosted_zone_name}" })
  private_hosted_zone_tags = merge(local.common_tags, { Name : "${var.private_hosted_zone_name}" })
  vpc_instance_id          = data.aws_vpc.vpc_instance.id
}

module "public_domain_ssl_certificate" {
  source            = "../../../tf_modules/aws/acm/"
  certificate_tags  = merge(local.common_tags, { "TF_LAYER_NAME" : var.tf_layer_name })
  domain_name       = var.public_hosted_zone_name
  alternative_names = "*.${var.public_hosted_zone_name}"
  depends_on        = [module.route53_hosted_zones]
}
