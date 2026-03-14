terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# =============================================================================
# Cloudflare DNS Records
# =============================================================================

data "cloudflare_zone" "main" {
  zone_id = var.cloudflare_zone_id
}

# -----------------------------------------------------------------------------
# Root Domain (A Record)
# -----------------------------------------------------------------------------

resource "cloudflare_record" "root" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  content = var.lab
  type    = "A"
  ttl     = 1 # Auto TTL when proxied
  proxied = false
}

# -----------------------------------------------------------------------------
# Wildcard (A Record) - Catches all subdomains
# -----------------------------------------------------------------------------

resource "cloudflare_record" "wildcard" {
  zone_id = var.cloudflare_zone_id
  name    = "*"
  content = var.lab
  type    = "A"
  ttl     = 1
  proxied = false
}
