# Configure the Azure Provider
provider "azurerm" {
  version = "1.32.1"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  environment     = "${var.environment}"
}

# Resource Group
resource "azurerm_resource_group" "resource-group" {
  name     = "${var.azure_resource_group_name}"
  location = "${var.azure_region}"
}

# Nodes
# Bastion Node / Jump Box

module "network" {
  source = "./network-module"
  
  resource_group = azurerm_resource_group.resource-group
}


# etcd
variable "etcd-prefix" {
  default = "etcd"
}

resource "azurerm_network_interface" "etcd-nic" {
  count               = var.rancher-etcd-node-count
  name                = "${var.etcd-prefix}-${count.index}-nic"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name

  ip_configuration {
    name                          = "etcd-ip-config-${count.index}"
    subnet_id                     = module.network.subnet-id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "etcd-vm" {
  count                 = var.rancher-etcd-node-count
  name                  = "${var.etcd-prefix}-${count.index}-vm"
  location              = azurerm_resource_group.resource-group.location
  resource_group_name   = azurerm_resource_group.resource-group.name
  network_interface_ids = ["${element(azurerm_network_interface.etcd-nic.*.id, count.index)}"]
  vm_size               = "Standard_DS1_v2"

  # Warning there be dragons
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.etcd-prefix}-${count.index}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name = "${var.etcd-prefix}-${count.index}-vm"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

# Control Plane (Master)
variable "controlplane-prefix" {
  default = "controlplane"
}

resource "azurerm_network_interface" "controlplane-nic" {
  count               = var.rancher-controlplane-node-count
  name                = "${var.controlplane-prefix}-${count.index}-nic"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name

  ip_configuration {
    name                          = "controlplane-ip-config-${count.index}"
    subnet_id                     = module.network.subnet-id
    private_ip_address_allocation = "dynamic"
  }
}

# Workers for Rancher



