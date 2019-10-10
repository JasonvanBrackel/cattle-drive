output "admin-username" {
  value = var.node-definition.admin-username
}

output "admin-password" {
  value = var.node-definition.admin-password
}

output "nodes" {
  value = local.nodes_output
}

output "publicIps" {
  value = local.public_ip_address_output
}

output "privateIps" {
  value = local.private_ip_address_output
}