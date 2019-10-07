provider "azurerm" {

}

# Configure the Rancher2 provider
provider "rancher2" {
  api_url    = var.rancher_api_url
  token_key  = var.rancher_api_token

  insecure = true
}

################################## Rancher
resource "rancher2_cluster" "manager" {
  name = var.cluster-name
  description = "Hybrid cluster with Windows and Linux workloads"
  rke_config {
    network {
      plugin = "canal"
    }
    cloud_provider {
      azure_cloud_provider {
        aad_client_id = var.service-principal.client-id
        aad_client_secret = var.service-principal.client-secret
        subscription_id = var.service-principal.subscription-id
        tenant_id = var.service-principal.tenant-id
      }
    }
  }
}
