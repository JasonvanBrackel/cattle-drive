## Input Variables

variable "prefix" {
  description = "Prefix to differentiate these nodes."
}

variable "resource_group" {
  description = "Resource Group where the nodes reside."

}

variable "node_count" {
  description = "Number of the nodes."
}

variable "subnet_id" {
  description = "Subnet where the nics are created."
}



variable "node_definition" {
  description = "ssh, size, os information for the nodes."

  default = {
    admin_username = "admin"
    ssh_keypath = "~/.ssh/id_rsa.pub"
    size = "Standard_DS1_v2"
    disk_type = "Ultra_disk"
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

## Output Variables