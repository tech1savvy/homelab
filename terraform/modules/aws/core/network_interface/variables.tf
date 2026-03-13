variable "subnet_id" {
  description = "Subnet ID to create the ENI in"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the ENI"
  type        = list(string)
}

variable "interface_name" {
  description = "Name tag for the ENI"
  type        = string
}
