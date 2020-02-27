provider "azurerm" {

}

resource "azurerm_key_vault" "kubernetes-vault" {
  name                        = "k8s-vault"
  location                    = var.resource-group.location
  resource_group_name         = var.resource-group.name
  tenant_id                   = var.tenant-id

  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant-id
    object_id = var.serviceprincipal-id

    key_permissions = [
      "create",
      "encrypt",
      "decrypt",
      "get",
      "list"
    ]
  }
}