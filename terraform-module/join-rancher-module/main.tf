provider "azurerm" {
  
}


locals {
  commandToExecute = replace(replace(var.join-command, "PowerShell -NoLogo -NonInteractive -Command \"& {", ""), " | iex}\"", " --worker | powershell")
}

resource "azurerm_virtual_machine_extension" "join-rancher" {
  count                = var.node-count
  name                 = "${var.nodes[count.index].name}-join-rancher"
  location             = var.resource-group.location
  resource_group_name  = var.resource-group.name
  virtual_machine_name = var.nodes[count.index].name
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = "{ \"commandToExecute\": \"${replace(local.commandToExecute, "--worker", "--worker --internal-address ${ var.private-Ips[count.index].ip_configuration[0].private_ip_address } --address ${var.public-Ips[count.index].ip_address}")}\" }"
}