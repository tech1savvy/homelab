variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "sg_name" {
  description = "The name for the security group"
  type        = string
}

variable "sg_description" {
  description = "The description for the security group"
  type        = string
  default     = "Security group for homelab"
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
