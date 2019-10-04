provider "cloudflare" {
  email = "${var.cloudflare-email}"
  api_key = "${var.cloudflare-token}"
}

data "cloudflare_zones" "zones" {
  filter {
    name   = "mymanagementcluster.*"
    status = "active"
    paused = false
  }
}

# Add a record to the domain
resource "cloudflare_record" "domain" {
  zone_id = data.cloudflare_zones.zones.id
  name   = var.domain-name
  value  = var.ip-address
  type   = "A"
  ttl    = "1"
  proxied = "false"
}