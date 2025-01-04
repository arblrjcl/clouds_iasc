
variable "vpc_enable_dns_support" {
  type      = bool
  default   = true
  sensitive = false
}

variable "vpc_enable_dns_hostnames" {
  type      = bool
  default   = true
  sensitive = false
}

variable "tf_layer_name" {
  type    = string
  default = "1_vpc_subnets"
}

