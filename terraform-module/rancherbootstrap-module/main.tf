provider "rancher2"  {
  alias = "bootstrap"

  api_url   = var.rancher-url
  bootstrap = true

  insecure = true
}

resource "rancher2_bootstrap" "admin" {
  provider = rancher2.bootstrap
  password = var.admin-password
  telemetry = true
}

provider "rancher2" {
  alias = "admin"

  api_url = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token

  insecure = true
}


resource "rancher2_setting" "url" {
  provider = rancher2.admin
  name = "server-url"
  value = var.rancher-url
}
