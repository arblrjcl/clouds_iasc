
variable "project_name" {
  type = string
}

variable "vpc_ipv4_cidr_block" {
  type = string
}

variable "vpc_tenancy" {
  type = string
}

variable "vpc_enable_dns_support" {
  type = bool
}

variable "vpc_enable_dns_hostnames" {
  type = bool
}

variable "vpc_tags" {
  type = map(string)
}

variable "vpc_igw_instance_tags" {
  type = map(string)
}

variable "vpc_public_subnets_cidr_blocks" {
  type = list(string)
}

variable "vpc_public_subnets_map_public_ip_on_launch" {
  type = bool
}

variable "vpc_public_subnets_availability_zones" {
  type = list(string)
}

variable "vpc_public_subnets_tags" {
  type = map(string)
}

variable "vpc_private_subnets_cidr_blocks" {
  type = list(string)
}

variable "vpc_private_subnets_availability_zones" {
  type = list(string)
}

variable "vpc_private_subnets_tags" {
  type = map(string)
}

variable "ipv4_cidr_block_to_all_ip_addresses" {
  type = string
}

variable "vpc_public_route_table_tags" {
  type = map(string)
}

variable "vpc_public_acl_tags" {
  type = map(string)
}

variable "vpc_private_acl_tags" {
  type = map(string)
}

variable "vpc_private_route_table_tags" {
  type = map(string)
}

variable "vpc_nat_gateway_tags" {
  type = map(string)
}

variable "vpc_nat_gws_eips_tags" {
  type = map(string)
}

variable "random_strings_count" {
  type = number
}