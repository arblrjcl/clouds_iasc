
variable "project_environment_name" {
  type        = string
  default     = "staging"
  description = "Mininum 4 characters string, Project name to name reqired Civo resources and create relevant tags"
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.project_environment_name) > 4 && length(var.project_environment_name) == length(regex("[[:alnum:]]+$", var.project_environment_name))
    error_message = "The project_environment_name variable value must be of 4 or more alphanumeric characters string."
  }
}

variable "project_name" {
  type        = string
  default     = "civodemo"
  description = "Mininum 4 characters string, Project name to name reqired Civo resources and create relevant tags"
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.project_name) > 4 && length(var.project_name) == length(regex("[[:alnum:]]+$", var.project_name))
    error_message = "The project_name variable value must be of 4 or more alphanumeric characters string."
  }
}

variable "suppoted_civo_regions" {
  type        = list(string)
  default     = ["fra1", "phx1", "lon1", "nyc1"]
  description = "All supported Civo region names"
  sensitive   = false
  nullable    = false
}

variable "civo_region" {
  type        = string
  default     = "lon1"
  description = "Valid Civo region name like lon1"
  sensitive   = false
  nullable    = false
  validation {
    condition     = contains(var.suppoted_civo_regions, "${var.civo_region}") && can(regex("[a-z]+1", var.civo_region))
    error_message = "${var.civo_region} is NOT a valid supported Civo region."
  }
}

variable "cidr_v4" {
  type    = string
  default = "10.254.10.0/24"
}

variable "tf_civo_provider_version" {
  type    = string
  default = "1.1.3"
}

locals {
  common_tags = {
    PROJECT_NAME = "${var.project_environment_name}-${var.project_name}"
    TERRAFORM    = "yes"
    RESPONSIBLE  = "Ravi"
  }
}

variable "public_hosted_zone_name" {
  type    = string
  default = "example.com" # Need to use a valid domain name insted of example.com
}

variable "private_hosted_zone_name" {
  type    = string
  default = "example.com" # Need to use a valid domain name insted of example.com
}

variable "google_v4_nameservers" {
  type    = list(string)
  default = ["8.8.8.8", "1.1.1.1"]
}

