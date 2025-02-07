
# Configure the Microsoft Azure Provider
provider "azurerm" {
  //resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  subscription_id = "00000000-0000-0000-0000-000000000000" //  We need to correct subscription_id
}
