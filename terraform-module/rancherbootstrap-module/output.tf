output "admin-token" {
  sensitive = true
  description = "Administrator token to connect to the Rancher cluster"
  value = rancher2_bootstrap.admin.token
}

output "admin-password" {
  sensitive = true
  description = "Administrator password to the Rancher cluster"
  value = var.admin-password
}

output "rancher-url" {
  description = "Rancher url"
  value = rancher2_bootstrap.admin.url
}




