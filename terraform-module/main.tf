# Configure the Azure Provider
provider "azurerm" {
  version = "1.32.1"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  environment     = var.environment
}

# Resource Group
resource "azurerm_resource_group" "resource-group" {
  name     = var.azure_resource_group_name
  location = var.azure_region
}

# Nodes
# Bastion Node / Jump Box

module "network" {
  source = "./network-module"
  
  resource_group = azurerm_resource_group.resource-group
}

module "jump" {
  source = "./node-module"
  prefix = "jump"
  
  resource_group = azurerm_resource_group.resource-group
  node_count = 1
  subnet_id = module.network.subnet-id

  node_definition = {
    admin_username = "jason"
    ssh_keypath = "~/.ssh/id_rsa.pub"
    size = "Standard_DS1_v2"
    disk_type = "Premium_LRS"
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

# Etcd Nodes
module "etcd" {
  source = "./node-module"
  prefix = "etcd"
  
  resource_group = azurerm_resource_group.resource-group
  node_count = var.rancher-etcd-node-count
  subnet_id = module.network.subnet-id

  node_definition = {
    admin_username = "jason"
    ssh_keypath = "~/.ssh/id_rsa.pub"
    size = "Standard_DS1_v2"
    disk_type = "Premium_LRS"
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

# Control Plane (Master) Nodes
module "controlPlane" {
  source = "./node-module"
  prefix = "control"
  
  resource_group = azurerm_resource_group.resource-group
  node_count = var.rancher-controlplane-node-count
  subnet_id = module.network.subnet-id

  node_definition = {
    admin_username = "jason"
    ssh_keypath = "~/.ssh/id_rsa.pub"
    size = "Standard_DS1_v2"
    disk_type = "Premium_LRS"
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

module "workers" {
  source = "./node-module"
  prefix = "worker"
  
  resource_group = azurerm_resource_group.resource-group
  node_count = var.rancher-worker-node-count
  subnet_id = module.network.subnet-id

  node_definition = {
    admin_username = "jason"
    ssh_keypath = "~/.ssh/id_rsa.pub"
    size = "Standard_DS1_v2"
    disk_type = "Premium_LRS"
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}