
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
  name = var.private_hosted_zone_name
  tags = var.private_hosted_zone_tags
  vpc {
    vpc_id = var.vpc_instance_id
  }
}

resource "aws_route53_zone" "environment_specific_private_hosted_zone" {
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

data "aws_caller_identity" "current_user_caller_identity" {}

# AWS Asymmetric KMS Key  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
resource "aws_kms_key" "public_hosted_zone_dnssec_kms_cmk" {
  description              = "ECC_NIST_P256 asymmetric KMS key for signing and verification"
  deletion_window_in_days  = 7
  customer_master_key_spec = "ECC_NIST_P256"
  key_usage                = "SIGN_VERIFY"
  enable_key_rotation      = false
  tags                     = var.public_hosted_zone_tags
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:Sign",
          "kms:Verify",
          "kms:DescribeKey",
          "kms:GetPublicKey",
        ],
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Resource = "*"
        Sid      = "Allow Route 53 DNSSEC Service",
      },
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current_user_caller_identity.account_id}:root"
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}

resource "aws_route53_key_signing_key" "public_hosted_zone_dnssec_ksk" {
  hosted_zone_id             = aws_route53_zone.public_hosted_zone.zone_id
  key_management_service_arn = aws_kms_key.public_hosted_zone_dnssec_kms_cmk.arn
  name                       = "${var.public_hosted_zone_name}-dnssec-ksk"
}

resource "aws_route53_hosted_zone_dnssec" "enable" {
  hosted_zone_id = aws_route53_key_signing_key.public_hosted_zone_dnssec_ksk.hosted_zone_id
  depends_on     = [aws_route53_key_signing_key.public_hosted_zone_dnssec_ksk]
}
