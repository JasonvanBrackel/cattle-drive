variable "prefix" {
  description = "Prefix to differentiate these nodes."
}

variable "resource-group" {
  description = "Resource Group where the nodes reside."

}

variable "node-count" {
  description = "Number of the nodes."
}

variable "address-starting-index" {
  description = "Offset for private addresses."
  type = number
}

variable "commandToExecute" {
  description = "Command added to the script extension to execute at setup time"
  type = string
}


variable "subnet-id" {
  description = "Subnet where the nics are created."
}

variable "node-definition" {
  description = "credentials, size, os information for the nodes."

  default = {
    admin-username = "iamsuperman"
    admin-password = "IamSuper3m@n"
    size = "Standard_D2_v3"
    disk-type = "Premium_LRS"
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServerSemiAnnual"
    sku       = "Datacenter-Core-1809-with-Containers-smalldisk"
    version   = "latest"
  }
}