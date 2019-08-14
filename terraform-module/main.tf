# Configure the Azure Provider
provider "azurerm" {
    # version = "=1.28.0"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  environment     = "${var.environment}"
}

# Resource Group
resource "azurerm_resource_group" "resource-group" {
  name     = "${var.azure_resource_group_name}"
  location = "${var.azure_region}"
}

