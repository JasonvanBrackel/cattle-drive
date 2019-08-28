# Azure Environment Variables
variable "resource_group" {
  description = "Resource Group for the Rancher cluster"

}

variable "region" {
  description = "Region for the Rancher cluster"
}

# Output
output "resource-group" {
  value = azurerm_resource_group.resource-group
}

output "location" {
  value = azurerm_resource_group.resource-group.location
}

output "subnet-id" {
  value = azurerm_subnet.subnet.id
}

