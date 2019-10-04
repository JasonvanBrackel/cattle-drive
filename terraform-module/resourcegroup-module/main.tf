resource "azurerm_resource_group" "resource-group" {
  name     = var.group-name
  location = var.region
}