output "admin-token" {
  description = "Administrator token to connect to the Rancher cluster"
  value = rancher2_bootstrap.admin.token
}
