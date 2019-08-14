# Service Principal Variables
variable "subscription_id" {
  type = "string"
  description = "Azure Subscription Id"
}

variable "client_id" {
  type = "string"
  description = "Azure Service Principal Client / App Id"
}

variable "client_secret" {
  type = "string"
  description = "Azure Service Principal Secret / Password Id"
}

variable "tenant_id" {
  type = "string"
  description = "Azure Service Principal Tenant Id"
}
variable "environment" {
  type = "string"
  description = "Azure Environment"

  default = "public"
}

# Azure Environment Variables
variable "azure_resource_group_name" {
  description = "Resource Group for the Rancher cluster"

}

variable "azure_region" {
  description = "Region for the Rancher cluster"
}

