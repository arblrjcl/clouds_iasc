
variable "project_name" {
  type = string
}

variable "tf_civo_provider_version" {
  type = string
}

variable "cidr_v4" {
  type    = string
  default = "192.168.1.0/24"
}

variable "default_network_instance" {
  type = bool
}

variable "domain_name" {
  type = string
}

variable "custom_v4_nameservers" {
  type = list(string)
}
