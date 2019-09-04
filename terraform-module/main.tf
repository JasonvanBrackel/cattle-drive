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

# module "jump" {
#   source = "./node-module"
#   prefix = "jump"
  
#   resource_group = azurerm_resource_group.resource-group
#   node_count = 1
#   subnet_id = module.network.subnet-id

#   node_definition = {
#     admin_username = "jason"
#     ssh_keypath = "~/.ssh/id_rsa.pub"
#     ssh_keypath_private = "~/.ssh/id_rsa"
#     size = "Standard_DS1_v2"
#     disk_type = "Premium_LRS"
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }
# }

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
    ssh_keypath_private = "~/.ssh/id_rsa"
    size = "Standard_DS1_v2"
    disk_type = "Premium_LRS"
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  docker_version = "18.09"
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
    ssh_keypath_private = "~/.ssh/id_rsa"
    size = "Standard_DS1_v2"
    disk_type = "Premium_LRS"
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  docker_version = "18.09"
}

module "worker" {
  source = "./node-module"
  prefix = "worker"
  
  resource_group = azurerm_resource_group.resource-group
  node_count = var.rancher-worker-node-count
  subnet_id = module.network.subnet-id

  node_definition = {
    admin_username = "jason"
    ssh_keypath = "~/.ssh/id_rsa.pub"
    ssh_keypath_private = "~/.ssh/id_rsa"
    size = "Standard_DS1_v2"
    disk_type = "Premium_LRS"
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  docker_version = "18.09"
}

resource rke_cluster "rancher_cluster" {
  dynamic nodes {
    for_each = module.etcd.nodes
    content {
      address = module.etcd.publicIps[nodes.key].ip_address
      internal_address = module.etcd.privateIps[nodes.key].private_ip_address
      user    = module.etcd.node_definition.admin_username
      role    = [module.etcd.prefix]
      ssh_key = file(module.etcd.node_definition.ssh_keypath_private)
    }
  }

  dynamic nodes {
    for_each = module.controlPlane.nodes
    content {
      address = module.controlPlane.publicIps[nodes.key].ip_address
      internal_address = module.controlPlane.privateIps[nodes.key].private_ip_address
      user    = module.controlPlane.node_definition.admin_username
      role    = ["controlplane"]
      ssh_key = file(module.controlPlane.node_definition.ssh_keypath_private)
    }
  }

  dynamic nodes {
    for_each = module.worker.nodes
    content {
      address = module.worker.publicIps[nodes.key].ip_address
      internal_address = module.worker.privateIps[nodes.key].private_ip_address
      user    = module.worker.node_definition.admin_username
      role    = [module.worker.prefix]
      ssh_key = file(module.worker.node_definition.ssh_keypath_private)
    }
  }
}