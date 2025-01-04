
terraform {
  required_providers {
    twingate = {
      source = "twingate/twingate"
      //version = "${var.tf_twingate_provider_version}"
      version = "3.0.14"
    }
  }
}
