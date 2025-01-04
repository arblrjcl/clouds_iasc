
variable "project_name" {
  type = string
}

variable "tf_civo_provider_version" {
  type = string
}

variable "applications" {
  type = string
}

variable "cidr_v4" {
  type = string
}

variable "node_count" {
  type = number
}

variable "node_size" {
  type = string
}
