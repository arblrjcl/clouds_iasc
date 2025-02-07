
variable "tf_layer_name" {
  type    = string
  default = "4_eks"
}

variable "eks_cluster_endpoint_private_access" {
  type    = bool
  default = false
}
