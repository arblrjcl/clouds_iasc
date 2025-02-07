
variable "project_name" {
  type = string
}

variable "vn_ipv4_cidr_block" {
  type = string
}

variable "vn_tags" {
  type = map(string)
}

variable "vn_public_subnets_cidr_blocks" {
  type = list(string)
}

variable "vn_private_subnets_cidr_blocks" {
  type = list(string)
}
