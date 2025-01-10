
variable "twingate_api_token" {
  type    = string
  default = "" #  Use correct / required TWINGATE API TOKEN.
}

variable "twingate_network_or_account_name" {
  type    = string
  default = "arblr"
}

variable "twingate_remotenetwork_id" {
  type    = string
  default = ""
}

variable "tf_twingate_provier_version" {
  type    = string
  default = "3.0.14"
}
