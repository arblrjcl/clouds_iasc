
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.12"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 3.37"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
    twingate = {
      # https://registry.terraform.io/providers/Twingate/twingate/latest
      source  = "twingate/twingate"
      version = "~> 3.0.13"
    }
  }
  backend "local" {
    path = "./terraform.tfstate"
  }
}
