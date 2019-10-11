provider "cloudflare" {
  email = "${var.cloudflare-email}"
  api_key = "${var.cloudflare-token}"
}

data "cloudflare_zones" "zones" {
  filter {
    name   = "${replace(var.domain-name, ".com", "")}.*" # Modify for other suffixes
    status = "active"
    paused = false
  }
}

# Add a record to the domain
resource "cloudflare_record" "domain" {
  zone_id = data.cloudflare_zones.zones.zones[0].id
  name   = var.domain-name
  value  = var.ip-address
  type   = "A"
  ttl    = "120"
  proxied = "false"
}