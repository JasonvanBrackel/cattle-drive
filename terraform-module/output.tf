output "rancher-domain-name" {
  description = "Domain name of the Rancher server"
  value = var.rancher-domain-name
}

output "rancher-admin-password" {
  sensitive = true
  description = "Admin password for Rancher server"
  value = module.rancherbootstrap-module.admin-password
}

output "lets-encrypt-environment" {
  description = "Let's encrypt environment for the Rancher server"
  value = var.lets-encrypt-environment
}

output "lets-encrypt-email" {
  description = "Let's encrypt email for the Rancher server"
  value = var.lets-encrypt-email
}