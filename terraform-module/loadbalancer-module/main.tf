resource "azurerm_public_ip" "frontendloadbalancer_publicip" {
  name                = "rke-lb-publicip"
  location            = var.resource-group.location
  resource_group_name = var.resource-group.name
  allocation_method   = "Static"
  domain_name_label   = replace(var.domain-name, ".", "-")
}

resource "azurerm_lb" "frontendloadbalancer" {
  name                = "rke-lb"
  location            = var.resource-group.location
  resource_group_name = var.resource-group.name

  frontend_ip_configuration {
    name                 = "rke-lb-frontend"
    public_ip_address_id = azurerm_public_ip.frontendloadbalancer_publicip.id
  }
}

resource "azurerm_lb_backend_address_pool" "frontendloadbalancer_backendpool" {
  resource_group_name = var.resource-group.name
  loadbalancer_id     = azurerm_lb.frontendloadbalancer.id
  name                = "rke-lb-backend"
}

resource "azurerm_network_interface_backend_address_pool_association" "worker_address_pool_association" {
  count                   = length(var.backend-nics)
  network_interface_id    = var.backend-nics[count.index].id
  ip_configuration_name   = "worker-ip-configuration-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.frontendloadbalancer_backendpool.id
}

resource "azurerm_lb_nat_rule" "loadbalancer_nat_http_rule" {
  resource_group_name            = var.resource-group.name
  loadbalancer_id                = azurerm_lb.frontendloadbalancer.id
  name                           = "httpAccess"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "rke-lb-frontend"
}

resource "azurerm_network_interface_nat_rule_association" "worker_nat_association_http" {
  count                 = length(var.backend-nics)
  network_interface_id  = var.backend-nics[count.index].id
  ip_configuration_name = "worker-ip-configuration-${count.index}"
  nat_rule_id           = azurerm_lb_nat_rule.loadbalancer_nat_http_rule.id
}

resource "azurerm_lb_nat_rule" "loadbalancer_nat_https_rule" {
  resource_group_name            = var.resource-group.name
  loadbalancer_id                = azurerm_lb.frontendloadbalancer.id
  name                           = "httpsAccess"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "rke-lb-frontend"
}

resource "azurerm_network_interface_nat_rule_association" "worker_nat_association_https" {
  count                 = length(var.backend-nics)
  network_interface_id  = var.backend-nics[count.index].id
  ip_configuration_name = "worker-ip-configuration-${count.index}"
  nat_rule_id           = azurerm_lb_nat_rule.loadbalancer_nat_https_rule.id
}