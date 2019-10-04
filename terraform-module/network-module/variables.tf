variable "resource-group" {
  description = "Resource Group for the Rancher cluster"

}

output "subnet-id" {
  value = azurerm_subnet.subnet.id
}

