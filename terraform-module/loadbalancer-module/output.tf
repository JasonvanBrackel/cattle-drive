output "ip-address" {
  value = azurerm_public_ip.frontendloadbalancer_publicip.ip_address 
}

output "fqdn" {
  value =  azurerm_public_ip.frontendloadbalancer_publicip.fqdn
}
