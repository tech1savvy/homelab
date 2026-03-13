
# =============================================================================
# Input Variables
# =============================================================================

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for the domain"
  type        = string
}

variable "lab" {
  description = "Public IP address of the lab server"
  type        = string
  sensitive   = true
}
