locals {
  prefix = var.prefix
}


resource "azurerm_public_ip" "publicIp" {
  count                        = var.node-count
  name                         = "${local.prefix}-${count.index}-publicIp"
  location                     = var.resource-group.location
  resource_group_name          = var.resource-group.name
  allocation_method = "Static"
}

resource "azurerm_network_interface" "nic" {
  count               = var.node-count
  name                = "${local.prefix}-${count.index}-nic"
  location            = var.resource-group.location
  resource_group_name = var.resource-group.name

  ip_configuration {
    name                          = "${local.prefix}-ip-config-${count.index}"
    subnet_id                     = var.subnet-id
    private_ip_address_allocation = "static"
    private_ip_address            = cidrhost("10.0.1.0/24", count.index + var.address-starting-index + 4)
    public_ip_address_id          = azurerm_public_ip.publicIp[count.index].id
  }
}

resource "azurerm_virtual_machine" "vm" {
  count                 = var.node-count
  depends_on            = [azurerm_network_interface.nic]
  name                  = "${local.prefix}-${count.index}-vm"
  location              = var.resource-group.location
  resource_group_name   = var.resource-group.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  vm_size               = var.node-definition.size

  # Warning there be dragons
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.node-definition.publisher
    offer     = var.node-definition.offer
    sku       = var.node-definition.sku
    version   = var.node-definition.version
  }
  
  storage_os_disk {
    name              = "${local.prefix}-${count.index}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.node-definition.disk-type
  }
  os_profile {
    computer_name = "${local.prefix}-${count.index}-vm"
    admin_username = var.node-definition.admin-username
    custom_data    = templatefile("./cloud-init.template", { docker-version = var.node-definition.docker-version, admin-username = var.node-definition.admin-username  })
  }
  os_profile_linux_config {
    disable_password_authentication = true    
    ssh_keys {
      path     = "/home/${var.node-definition.admin-username}/.ssh/authorized_keys"
      key_data = file(var.node-definition.ssh-keypath)
    }
  }
}

resource "null_resource" "wait-for-cloud-init" {
  depends_on = [azurerm_virtual_machine.vm]
  provisioner "local-exec" {
    command = "sleep 180"
  }
}

locals {
  nodes_output = azurerm_virtual_machine.vm
  public_ip_address_output = azurerm_public_ip.publicIp.*
  private_ip_address_output = azurerm_network_interface.nic.*  
}