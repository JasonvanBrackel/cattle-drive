provider "cloudflare" {
  email = "${var.cloudflare-email}"
  api_token = "${var.cloudflare-token}"
}

resource "cloudflare_zone" "zone" {
  zone = var.domain-name
}

# Add a record to the domain
resource "cloudflare_record" "domain" {
  zone_id = cloudflare_zone.zone.id
  name   = var.domain-name
  value  = var.ip-address
  type   = "A"
  ttl    = "1"
  proxied = "false"
}