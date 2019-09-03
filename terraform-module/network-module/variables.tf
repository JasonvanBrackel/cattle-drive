# Azure Environment Variables
variable "resource_group" {
  description = "Resource Group for the Rancher cluster"

}

# Output

output "subnet-id" {
  value = azurerm_subnet.subnet.id
}

