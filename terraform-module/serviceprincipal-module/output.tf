output "application-id" {
  description = "application id for the service principal"
  value = azuread_application.ad-application.application_id
}

output "secret" {
  description = "Client secret for the service principal"
  value = azuread_service_principal_password.service-principal-password.value
}
