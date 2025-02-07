
variable "project_environment_name" {
  type        = string
  default     = "staging"
  description = "Mininum 4 characters string, Project name to name reqired Azure resources and create relevant tags"
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.project_environment_name) > 4 && length(var.project_environment_name) == length(regex("[[:alnum:]]+$", var.project_environment_name))
    error_message = "The project_environment_name variable value must be of 4 or more alphanumeric characters string."
  }
}

variable "project_name" {
  type        = string
  default     = "k8sans"
  description = "Mininum 4 characters string, Project name to name reqired Azure resources and create relevant tags"
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.project_name) > 4 && length(var.project_name) == length(regex("[[:alnum:]]+$", var.project_name))
    error_message = "The project_name variable value must be of 4 or more alphanumeric characters string."
  }
}

variable "suppoted_azure_regions" {
  type        = list(string)
  default     = ["South India", "Singapore", "East US", "West US", "North Central US", "South Central US", "UK West", "West Europe"]
  description = "Supported Azure region names. Here we did not include all supported Azure region names."
  sensitive   = false
  nullable    = false
}

variable "azure_region" {
  type        = string
  default     = "South India"
  description = "Valid Azure region name like eu-central-1 and we use this region name to deploy required Azure resources."
  sensitive   = false
  nullable    = false
  validation {
    condition     = contains(var.suppoted_azure_regions, "${var.azure_region}") //&& can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.azure_region))
    error_message = "${var.azure_region} is NOT a valid supported Azure region."
  }
}

locals {
  # Tags to be attached to each AWS resource that we create.
  common_tags = {
    PROJECT_NAME = "${var.project_environment_name}-${var.project_name}"
    TERRAFORM    = "Yes"
    RESPONSIBLE  = "Ravi"
  }
  vn_ipv4_cidr_block                          = "10.254.0.0/16"
  vn_tenancy                                  = "default"
  private_tier                                = "Private"
  public_tier                                 = "Public"
  ipv4_cidr_block_containing_all_ip_addresses = "0.0.0.0/0"

  # To create one IPv4 public subnet per availability zone up to 5 availability zones.
  //number_of_availability_zones = length(data.azure_availability_zones.available_zones.names) >= 5 ? 5 : length(data.azure_availability_zones.available_zones.names)
  //public_network_ipv4_cidr_blocks = [for index in range(0, local.number_of_availability_zones, 1) : "10.254.${10 + index}.0/24"]
  public_network_ipv4_cidr_blocks = ["10.254.10.0/24", "10.254.11.0/24", "10.254.52.0/24"]

  /* To create one IPv4 private subnet per availability zone up to 5 availability zones. */
  //private_network_ipv4_cidr_blocks = [for index in range(0, local.number_of_availability_zones, 1) : "10.254.${50 + index}.0/24"]
  private_network_ipv4_cidr_blocks = ["10.254.50.0/24", "10.254.51.0/24", "10.254.52.0/24"]

  # https://developer.hashicorp.com/terraform/language/functions/cidrsubnets
  # https://developer.hashicorp.com/terraform/language/functions/cidrsubnet
  # We may need to use cidrsubnets and cidrsubnet functions to deal with mentioned ipv4_cidr_blocks definition
}
