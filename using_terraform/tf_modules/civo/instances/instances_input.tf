
variable "project_name" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "instance_tags" {
  type = list(string)
}

variable "instance_notes" {
  type = string
}

variable "instance_size" {
  type = string
}

variable "ssh_public_key_file_name_with_path" {
  type = string
}

variable "volume_type" {
  type = string
}
