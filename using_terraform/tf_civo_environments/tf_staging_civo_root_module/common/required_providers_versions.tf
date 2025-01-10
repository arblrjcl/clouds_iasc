
terraform {
  required_providers {
    civo = {
      source  = "registry.terraform.io/civo/civo"
      version = "1.1.3"
      //version = "${var.tf_civo_provider_version}"
      //version = "~> ${var.tf_civo_provider_version}"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
    twingate = {
      source = "twingate/twingate"
      //version = var.tf_twingate_provier_version
      version = "3.0.14"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.0"
    }
  }
  backend "local" {
    path = "./terraform.tfstate"
  }
}
