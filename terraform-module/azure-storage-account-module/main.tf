resource "azurerm_storage_account" "storage-account" {
  name                     = var.storage-account-name
  resource_group_name      = var.resource-group.name
  location                 = var.resource-group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}