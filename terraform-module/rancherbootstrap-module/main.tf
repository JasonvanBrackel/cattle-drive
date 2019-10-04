provider "rancher2"  {
  alias = "bootstrap"
  api_url   = var.rancher-url
  bootstrap = true
}

resource "rancher2_bootstrap" "admin" {
  provider = rancher2.bootstrap
  password = var.admin-password
  telemetry = true
}

resource "rancher2_setting" "url" {
  provider = rancher2.bootstrap
  name = "server-url"
  value = var.rancher-url
}
