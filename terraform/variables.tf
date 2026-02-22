variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "ap-south-1"
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "node_state" {
  description = "The desired state of the NixOS node (running or stopped)"
  type        = string
  default     = "running"
}
