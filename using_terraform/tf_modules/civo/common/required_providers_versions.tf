
terraform {
  required_providers {
    civo = {
      source = "registry.terraform.io/civo/civo"
      //version = var.tf_civo_provider_version
      version = "1.1.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.0"
    }
  }
}
