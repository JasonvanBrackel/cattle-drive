provider "azurerm" {

}

resource "azuread_application" "ad-application" {
  name                       = var.application-name
  homepage                   = "https://${var.application-name}"
  identifier_uris            = ["http://${var.application-name}"]
  available_to_other_tenants = false
}

resource "azuread_service_principal" "service-principal" {
  application_id                = azuread_application.ad-application.application_id
  app_role_assignment_required  = true
}


resource "azurerm_role_assignment" "serviceprincipal-role" {
  scope                = var.resource-group-id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.service-principal.id
}

resource "random_string" "random" {
  length = 32
  special = true
}

resource "azuread_service_principal_password" "service-principal-password" {
  service_principal_id = azuread_service_principal.service-principal.id
  value                = random_string.random.result
  end_date_relative    = "720h"
}