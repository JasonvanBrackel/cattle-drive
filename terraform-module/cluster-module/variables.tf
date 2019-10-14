variable "cluster-name" {
  description = "Name of the cluster managed by Rancher"
  type = string
}


variable "rancher_api_url" {
  description = "Url to the Rancher API"
  type = string
}

variable "rancher_api_token" {
  description = "API Token for Rancher"
  type = string
}

variable resource-group {
  description = "Resource group of the service principal"
}

variable tenant-id {
  description = "Tenant for this cluster"
}

variable subscription-id {
  description = "Subscription for this cluster"
}