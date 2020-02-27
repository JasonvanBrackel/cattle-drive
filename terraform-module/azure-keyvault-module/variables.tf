variable "vault-name" {
  description = "Name of the Azure Key Vault"
}

variable "resource-group" {
  description = "Resource Group for the Rancher cluster"
}

variable "tenant-id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
}

variable "serviceprincipal-id" {
  description = "The Azure AD Service Principal that has access to the KeyVault"
}