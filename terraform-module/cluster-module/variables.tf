variable "rancher_api_url" {
  description = "Url to the Rancher API"
  type = string
}

variable "rancher_api_token" {
  description = "API Token for Rancher"
  type = string
}

variable "service-principal" {
  description = "Service principal for the Azure Provider"
  type = object({client-id=string,client-secret=string,subscription-id=string,tenant-id=string})  
}