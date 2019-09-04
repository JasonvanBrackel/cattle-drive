locals {
  prefix = var.prefix
}


resource "azurerm_public_ip" "publicIp" {
  count                        = var.node_count
  name                         = "${local.prefix}-${count.index}-publicIp"
  location                     = var.resource_group.location
  resource_group_name          = var.resource_group.name
  allocation_method = "Static"
}

resource "azurerm_network_interface" "nic" {
  count               = var.node_count
  name                = "${local.prefix}-${count.index}-nic"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "${local.prefix}-ip-config-${count.index}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicIp[count.index].id
  }
}

resource "azurerm_virtual_machine" "vm" {
  count                 = var.node_count
  name                  = "${local.prefix}-${count.index}-vm"
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  vm_size               = var.node_definition.size

  # Warning there be dragons
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.node_definition.publisher
    offer     = var.node_definition.offer
    sku       = var.node_definition.sku
    version   = var.node_definition.version
  }
  
  storage_os_disk {
    name              = "${local.prefix}-${count.index}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.node_definition.disk_type
  }
  os_profile {
    computer_name = "${local.prefix}-${count.index}-vm"
    admin_username = var.node_definition.admin_username
  }
  os_profile_linux_config {
    disable_password_authentication = true    
    ssh_keys {
      path     = "/home/${var.node_definition.admin_username}/.ssh/authorized_keys"
      key_data = "${file(var.node_definition.ssh_keypath)}"
    }
  }

   provisioner "remote-exec" {
    inline = [
      "curl https://releases.rancher.com/install-docker/${var.docker_version}.sh | sh && sudo usermod -a -G docker  ${var.node_definition.admin_username}",
    ]

    connection {
      host     = azurerm_public_ip.publicIp[count.index].ip_address
      type     = "ssh"
      user     = "${var.node_definition.admin_username}"
      private_key = "${file("${var.node_definition.ssh_keypath_private}")}"
    }
  }
}

locals {
  nodes_output = azurerm_virtual_machine.vm
  public_ip_address_output = azurerm_public_ip.publicIp.*
  private_ip_address_output = azurerm_network_interface.nic.*  
}