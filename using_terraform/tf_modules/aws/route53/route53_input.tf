
variable "project_environment_name" {
  type = string
}

variable "public_hosted_zone_name" {
  type = string
}

variable "public_hosted_zone_tags" {
  type = map(string)
}

variable "private_hosted_zone_name" {
  type = string
}

variable "private_hosted_zone_tags" {
  type = map(string)
}

variable "vpc_instance_id" {
  type = string
}
